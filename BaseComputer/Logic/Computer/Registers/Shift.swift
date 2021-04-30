//
//  Shift.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import Foundation

struct Shift {
    var value: Bool {
        get {
            return buffer
        }
        set {
            string = newValue ? "1" : "0"
            buffer = newValue
        }
    }
    private var buffer: Bool = false
    var string: String {
        get {
            buffer ? "1" : "0"
        }
        set {
            buffer = ((newValue == "0") ? false : ((newValue == "1") ? false : buffer))
        }
    }

    mutating func clear() {
        self.value = false
    }

    mutating func inverse() {
        self.value.toggle()
    }
}
