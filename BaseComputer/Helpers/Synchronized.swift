//
//  Synchronized.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 07.09.2021.
//

import Foundation

@propertyWrapper struct Synchronized<T> {
    private var value: T
    
    public var wrappedValue: T {
        get {
            value
        }
        set {
            syncMain {
                value = newValue
            }
        }
    }
    
    public init (wrappedValue: T) {
        self.value = wrappedValue
    }
}
