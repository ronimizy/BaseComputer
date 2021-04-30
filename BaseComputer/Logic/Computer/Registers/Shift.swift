//
//  Shift.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import Foundation

struct Shift {
    var value: Bool = false
    var string: String {
        get {
            value ? "1" : "0"
        }
        set {
            value = ((newValue == "0") ? false : ((newValue == "1") ? false : value))
        }
    }

    mutating func clear() {
        self.value = false
    }

    mutating func inverse() {
        self.value.toggle()
    }
}
