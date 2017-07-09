//
//  Observable.swift
//  Observable
//
//  Created by devtak on 2017. 6. 12..
//  Copyright (c) 2017 devtak. All rights reserved.
//

import Foundation

public protocol Observable: class {
    
    associatedtype Observer
    typealias ObserverContainer = Set<Weak<AnyObject>>
    var observers: ObserverContainer { get set }
    var observersLock: NSRecursiveLock? { get }
    
}

extension Observable {
    
    public func addObserver(_ observer: Observer) {
        if self.getObservers().contains(where: { ($0 as AnyObject) === (observer as AnyObject) }) { return }
        if let lock = self.observersLock {
            lock.scopeLock {
                self.observers.insert(Weak(observer as AnyObject))
            }
        } else {
            self.observers.insert(Weak(observer as AnyObject))
        }
    }
    
    public func removObserver(_ observer: Observer) {
        let rawPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(observer as AnyObject).toOpaque())
        func remove() {
            let trashs = self.observers.filter { $0.rawPointer == rawPointer }
            for trash in trashs.reversed() {
                self.observers.remove(trash)
            }
        }
        
        if let lock = self.observersLock {
            lock.scopeLock {
                remove()
            }
        } else {
            remove()
        }
    }
    
    public func notify(method: (Observer) -> Void) {
        self.fire(method: method)
    }
    
    public func asyncNotify(queue: DispatchQueue, method: @escaping (Observer) -> Void) {
        queue.async {
            self.fire(method: method)
        }
    }
    
}

fileprivate extension Observable {
    
    func getObservers() -> [Observer] {
        var filtered: [Observer] = []
        if let lock = self.observersLock {
            lock.scopeLock {
                filtered = self.observers.filter { $0.object != nil }.flatMap { $0.object as? Observer }
            }
        } else {
            filtered = self.observers.filter { $0.object != nil }.flatMap { $0.object as? Observer }
        }

        if self.observers.count != filtered.count {
            self.clearInvalidListeners()
        }
        return filtered
    }
    
    func fire(method: (Observer) -> Void) {
        for element in self.getObservers() {
            method(element)
        }
    }
    
    func clearInvalidListeners() {
        func remove() {
            let trashs = self.observers.filter { $0.object == nil }
            for trash in trashs.reversed() {
                self.observers.remove(trash)
            }
        }

        if let lock = self.observersLock {
            lock.scopeLock {
                remove()
            }
        } else {
            remove()
        }
    }
    
}
