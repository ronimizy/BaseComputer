//
//  ExternalDevice.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.10.2020.
//

import SwiftUI

class ExternalDevice: Equatable {
    static func ==(lhs: ExternalDevice, rhs: ExternalDevice) -> Bool {
        lhs.id == rhs.id
    }

    private let id = UUID()
    public var isReady: Bool = false

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

    func getValue() -> UInt8 {
        let value = self.value
        guard let index = queue.firstIndex(of: " ") else {
            queue = ""
            return 0
        }

        let prefix = queue.prefix(upTo: index)
        queue = String(queue[index...queue.endIndex])
        queue.removeFirst()

        guard let value = UInt8(prefix, radix: 16) else {
            self.queue = ""
            self.value = 0
            return value
        }

        self.value = value

        return value
    }
}
