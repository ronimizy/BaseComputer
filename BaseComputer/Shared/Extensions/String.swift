//
//  String.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI
import AppKit

extension String {
    func commandFormat(_ length: Int = 4) -> String {
        self.withLength(length).uppercased()
    }

    func withLength(_ length: Int) -> String {
        var value = self
        value = String(repeating: "0", count: length - value.count) + value

        if value.count > length {
            value.removeFirst(value.count - length)
        }

        return value
    }

    func widthOfString(usingFont font: NSFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
