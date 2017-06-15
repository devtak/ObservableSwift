//
//  Lock.swift
//  Lock
//
//  Created by devtak on 2017. 6. 14..
//  Copyright (c) 2017 devtak. All rights reserved.
//

import Foundation

public protocol Lock {
    
    func lock()
    func unlock()
    
}

public extension Lock {
    
    func scopeLock(criticalSection: () -> Void) -> Void {
        defer {
            self.unlock()
        }
        self.lock()
        criticalSection()
    }
    
}

extension NSLock: Lock {}
extension NSRecursiveLock: Lock {}
