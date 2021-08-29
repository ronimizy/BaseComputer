//
//  HoverableButton.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.08.2021.
//

import AppKit

class HoverableButton: NSButton {
    private let callback: (HoverableButton, Bool) -> ()
    
    init(_ callback: @escaping (HoverableButton, Bool) -> ()) {
        self.callback = callback
        super.init(frame: .zero)
        assignArea()
    }
    
    init(checkBoxWithTitle title: String, _ callback: @escaping (HoverableButton, Bool) -> ()) {
        self.callback = callback
        super.init(frame: .zero)
        assignArea()
    }
    
    private func assignArea() {
        let area = NSTrackingArea(rect: bounds,
                                  options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
                                  owner: self,
                                  userInfo: nil)
        addTrackingArea(area)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        callback(self, true)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        callback(self, false)
    }
}
