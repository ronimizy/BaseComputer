//
//  String.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

extension String
{    
    func commandFormat(_ len: Int = 4) -> String
    {
        return self.setLength(len).uppercased()
    }
    
    mutating func commandFormat(_ len: Int = 4) {
        self = self.commandFormat(len)
    }
    
    func setLength(_ length: Int) -> String
    {
        var value = self
        while value.count < length
        {
            value = "0" + value
        }
        if value.count > length { value.removeFirst(value.count - length)}
        
        return value
    }
}
