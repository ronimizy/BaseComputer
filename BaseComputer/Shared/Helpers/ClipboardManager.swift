//
// Created by Георгий Круглов on 28.04.2021.
//

import AppKit

class ClipboardManager {
    static func copy(_ value: String) {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(value, forType: .string)
    }

    static func paste() -> String {
        NSPasteboard.general.string(forType: .string) ?? ""
    }
}
