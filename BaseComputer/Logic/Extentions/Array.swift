//
//  Array.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 10.12.2020.
//

import Foundation

extension Array {
    subscript (_ a: UInt16) -> Element {
        get {
            return self[Int(a)]
        }
        set {
            self[Int(a)] = newValue
        }
    }
}
