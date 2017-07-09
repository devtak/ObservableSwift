//
//  Weak.swift
//  Weak
//
//  Created by devtak on 2017. 6. 12..
//  Copyright (c) 2017 devtak. All rights reserved.
//

import Foundation

public struct Weak<T: AnyObject> {
    
    private(set) weak var object: T?
    private(set) var rawPointer: UnsafeRawPointer
    init(_ object: T) {
        self.object = object
        self.rawPointer = UnsafeRawPointer(Unmanaged.passUnretained(object).toOpaque())
    }
    
}

extension Weak: Hashable, Equatable {
    
    public var hashValue: Int {
        return self.rawPointer.hashValue
    }
    
    public static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.rawPointer == rhs.rawPointer
    }
    
}
