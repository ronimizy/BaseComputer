//
//  Syncronization.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 01.09.2021.
//

import Foundation

func syncMain<T>(_ closure: () -> T) -> T {
    if Thread.isMainThread {
        return closure()
    } else {
        return DispatchQueue.main.sync(execute: closure)
    }
}
