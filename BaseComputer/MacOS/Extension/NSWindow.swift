//
//  NSWindow.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.08.2021.
//

import Cocoa

extension NSWindow {
    var titlebarHeight: CGFloat {
        frame.height - contentRect(forFrameRect: frame).height
    }
}
