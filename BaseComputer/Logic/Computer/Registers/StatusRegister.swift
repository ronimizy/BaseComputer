//
//  StatusRegister.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

struct StatusRegister {
    private var computer: Computer?
    
    @Synchronized var shift: Bool = false
    @Synchronized var null: Bool = true
    @Synchronized var sign: Bool = false
    @Synchronized var zero: Bool = false
    private var allowInterruptBuffer: Bool = false
    @Synchronized var interrupted: Bool = false
    @Synchronized var working: Bool = true
    @Synchronized var program: Bool = false
    @Synchronized var commandFetch: Bool = false
    @Synchronized var addressFetch: Bool = false
    @Synchronized var execution: Bool = false
    @Synchronized var IO: Bool = false
    
    var allowInterrupt: Bool {
        get {
            return allowInterruptBuffer
        }
        set {
            syncMain {
                allowInterruptBuffer = newValue
                interrupted = interrupted && newValue
            }
        }
    }
    var externalDevice: Bool {
        get {
            return computer?.externalDevices[0].isReady ?? false ||
                computer?.externalDevices[1].isReady ?? false ||
                computer?.externalDevices[2].isReady ?? false
        }
        set {
            fatalError("This setter is not supposed to be used")
        }
    }
    
    var value: UInt16 {
        get {
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
        set {
            syncMain {
                shift = newValue[0] == 1
                null = newValue[1] == 1
                sign = newValue[2] == 1
                zero = newValue[3] == 1
                allowInterrupt = newValue[4] == 1
                interrupted = newValue[5] == 1
                
                working = newValue[7] == 1
                program = newValue[8] == 1
                commandFetch = newValue[9] == 1
                addressFetch = newValue[10] == 1
                execution = newValue[11] == 1
                IO = newValue[12] == 1
            }
        }
    }
    
    init(_ computer: Computer? = nil) {
        self.computer = computer
    }
}
