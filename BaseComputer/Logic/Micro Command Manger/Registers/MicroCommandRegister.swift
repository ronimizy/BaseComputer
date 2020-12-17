//
//  MicroCommandRegister.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

class MicroCommandRegister
{
    var value: UInt16 = 0
    var string: String { get { return String.init(value, radix: 16).commandFormat() } }
}
