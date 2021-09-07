//
//  Shift.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import Foundation

struct Shift {
    @Synchronized var value: Bool = false
    
    var string: String {
        get {
            value ? "1" : "0"
        }
    }

    mutating func clear() {
        self.value = false
    }

    mutating func inverse() {
        self.value.toggle()
    }
}
