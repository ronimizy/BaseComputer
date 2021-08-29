//
// Created by Георгий Круглов on 27.04.2021.
//

import AppKit

class AlertManager {
    @discardableResult
    static func runAlert(message: String, style: NSAlert.Style, _ withOptions: ((NSAlert) -> ())? = nil) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.alertStyle = style
        alert.messageText = message

        withOptions?(alert)

        return alert.runModal()
    }
}
