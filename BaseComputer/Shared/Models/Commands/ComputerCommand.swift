//
//  ComputerCommand.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 30.11.2020.
//

import Foundation

protocol ComputerCommand: AnyObject {
    var number: Int { get set }
    var value: UInt16 { get set }
    var string: String { get set }
    var description: String { get }
}
