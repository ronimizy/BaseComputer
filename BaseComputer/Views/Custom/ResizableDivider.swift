//
// Created by Георгий Круглов on 24.04.2021.
//

import SwiftUI

struct ResizableDivider: View {
    let color: Color
    let width: CGFloat
    var direction: Axis.Set

    init(_ width: CGFloat, direction: Axis.Set = .horizontal, color: Color = .gray) {
        self.color = color
        self.width = width
        self.direction = direction
    }

    var body: some View {
        ZStack {
            Rectangle()
                    .fill(color)
                    .applyIf(direction == .vertical) {
                        $0.frame(width: width)
                                .edgesIgnoringSafeArea(.vertical)
                    } else: {
                        $0.frame(height: width)
                                .edgesIgnoringSafeArea(.horizontal)
                    }
        }
    }
}
