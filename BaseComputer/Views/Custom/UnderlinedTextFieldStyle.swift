//
//  UnderlinedTextFieldStyle.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.04.2021.
//

import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get {
            .none
        }
        set {
        }
    }
}

struct UnderlinedTextFieldStyle: TextFieldStyle {
    private var fieldHeight: CGFloat

    init(fieldHeight: CGFloat) {
        self.fieldHeight = fieldHeight
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
                .textFieldStyle(PlainTextFieldStyle())
                .background(
                        VStack(alignment: .center) {
                            Spacer()
                                    .frame(height: fieldHeight * 0.5)

                            Rectangle()
                                    .fill(Color.secondary)
                                    .frame(height: 1)
                        }
                )
    }
}

struct UnderlinedTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        TextField("0", text: .constant("Str"))
                .textFieldStyle(UnderlinedTextFieldStyle(fieldHeight: 50))
                .frame(height: 50)
                .padding()
    }
}
