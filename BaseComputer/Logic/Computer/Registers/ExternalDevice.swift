//
//  ExternalDevice.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.10.2020.
//

import SwiftUI

struct ExternalDevice {
    var isReady: Bool = false

    var value: UInt8 = 0
    var string: String {
        get {
            String(value, radix: 16).uppercased()
        }
        set {
            value = UInt8(newValue, radix: 16) ?? 0
        }
    }

    var queue: String = ""

    mutating func getValue() -> UInt8 {
        let value = self.value

        var components = queue.components(separatedBy: " ")

        guard UInt8(components[0], radix: 16) != nil else {
            self.queue = ""
            return value
        }

        self.value = UInt8(components[0], radix: 16)!

        components.removeFirst()

        self.queue = components.count == 0 ? " " : components.joined(separator: " ")

        return value
    }
}
