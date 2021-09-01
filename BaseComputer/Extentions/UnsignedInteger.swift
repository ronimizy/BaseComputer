//
//  UnsignedInteger.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 03.11.2020.
//

import SwiftUI

extension UnsignedInteger where Self: FixedWidthInteger {
    subscript(range: ClosedRange<Int>) -> Self {
        get {
            var result: Self = 0

            for i in range {
                if i >= bitWidth {
                    break
                }

                result += self & (1 << i)
            }

            return result >> range.lowerBound
        }
    }

    subscript(index: Int) -> Self {
        get {
            self[index...index]
        }
    }

    mutating func mask(_ n: Int) {
        self = self[0...(n - 1)]
    }

    func masked(_ n: Int) -> Self {
        self[0...(n - 1)]
    }

    func signed() -> String {
        String((self[bitWidth - 1] == 1
                ? -1 * Int(Self.max[0...(bitWidth - 2)] - self[0...(bitWidth - 2)]) + 1
                : Int(self[0...14])))
    }
}
