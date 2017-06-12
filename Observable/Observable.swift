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
    
}

extension Observable {
    
    public func addObserver(_ observer: Observer) {
        if self.getObservers().contains(where: { ($0 as AnyObject) === (observer as AnyObject) }) { return }
        self.observers.insert(Weak(observer as AnyObject))
    }
    
    public func removObserver(_ observer: Observer) {
        let rawPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(observer as AnyObject).toOpaque())
        let trashs = self.observers.filter{ $0.rawPointer == rawPointer }
        for trash in trashs.reversed() {
            self.observers.remove(trash)
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
        let fitered = self.observers.filter{ $0.object != nil }.map{ $0.object! as! Observer }
        if self.observers.count != fitered.count {
            self.clearZombieListener()
        }
        return fitered
    }
    
    func fire(method: (Observer) -> Void) {
        for element in self.getObservers() {
            method(element)
        }
    }
    
    func clearZombieListener() {
        let trashs = self.observers.filter{ $0.object == nil }
        for trash in trashs.reversed() {
            self.observers.remove(trash)
        }
    }
    
}
