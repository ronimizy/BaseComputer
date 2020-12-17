//
//  StatusRegister.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

struct StatusRegister
{
    var shift: Bool = false
    var null: Bool = true
    var sign: Bool = false
    var zero: Bool = false
    
    var allowInterruptBuffer: Bool = false
    var allowInterrupt: Bool {
        get {
            return allowInterruptBuffer
        }
        set {
            allowInterruptBuffer = newValue
            interrupted = interrupted && newValue
        }
    }
    
    var interrupted: Bool = false
    var externalDevice: Bool = false
    var working: Bool = true
    var program: Bool = false
    var commandFetch: Bool = false
    var addressFetch: Bool = false
    var execution: Bool = false
    var IO: Bool = false
    
    var value: UInt16
    {
        get
        {
            var v: UInt16 = 0
            
            v += shift ? 1 : 0
            v += null ? 2 : 0
            v += sign ? 4 : 0
            v += zero ? 8 : 0
            v += allowInterrupt ? 16 : 0
            v += interrupted ? 32 : 0
            v += externalDevice ? 64 : 0
            v += working ? 128 : 0
            v += program ? 256 : 0
            v += commandFetch ? 512 : 0
            v += addressFetch ? 1024 : 0
            v += execution ? 2048 : 0
            v += IO ? 4096 : 0
            
            return v
        }
        set
        {
            shift = newValue.getBitsValue(0) == 1
            null = newValue.getBitsValue(1) == 1
            sign = newValue.getBitsValue(2) == 1
            zero = newValue.getBitsValue(3) == 1
            allowInterrupt = newValue.getBitsValue(4) == 1
            interrupted = newValue.getBitsValue(5) == 1
            externalDevice = newValue.getBitsValue(6) == 1
            working = newValue.getBitsValue(7) == 1
            program = newValue.getBitsValue(8) == 1
            commandFetch = newValue.getBitsValue(9) == 1
            addressFetch = newValue.getBitsValue(10) == 1
            execution = newValue.getBitsValue(11) == 1
            IO = newValue.getBitsValue(12) == 1
        }
    }
}
