//
//  PresentationConfiguration.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.08.2021.
//

import Foundation

class PresentationConfiguration {
    public enum PresentationMode {
        case program
        case microProgram
    }
    
    public var mode: PresentationMode
    
    public init(mode: PresentationMode) {
        self.mode = mode
    }
}
