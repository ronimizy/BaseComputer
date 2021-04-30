//
// Created by Георгий Круглов on 24.04.2021.
//

import SwiftUI

extension View {
    @ViewBuilder func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T, else: (Self) -> T) -> some View {
        if condition() {
            apply(self)
        } else {
            `else`(self)
        }
    }

    @ViewBuilder func renderIfWillBeSeen(_ preload: CGFloat, viewGeometry: GeometryProxy, generalGeometry: GeometryProxy) -> some View {
        let position = viewGeometry.frame(in: .global).minY
        let size = viewGeometry.frame(in: .local).size

        let displayed = position > -preload * size.height && position < generalGeometry.size.height + preload * size.height

        if displayed {
            self
        } else {
            EmptyView()
                    .frame(width: size.width, height: size.height)
        }
    }
}
