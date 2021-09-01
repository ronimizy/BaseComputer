//
//  RenderIfWillBeSeen.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 01.09.2021.
//

import SwiftUI

struct RenderIfWillBeSeen<Content: View>: View {
    private let bounds: GeometryProxy
    private let preload: CGFloat
    private let size: CGSize
    private let content: () -> Content
    
    public init(bounds: GeometryProxy, preload: CGFloat = 2, size: CGSize, @ViewBuilder _ content: @escaping () -> Content) {
        self.bounds = bounds
        self.preload = preload
        self.size = size
        self.content = content
    }
    
    var body: some View {
        GeometryReader { g in
            let positionY = g.frame(in: .global).minY - bounds.frame(in: .global).minY
            let positionX = g.frame(in: .global).minX - bounds.frame(in: .global).minX
            
            let displayed =
                positionY > -(preload - 1) * size.height &&
                positionY < bounds.size.height + preload * size.height &&
                positionX > -(preload - 1) * size.width &&
                positionX < bounds.size.width + preload * size.width
            
            if displayed {
                content()
                    .frame(width: size.width, height: size.height)
            } else {
                EmptyView()
                    .frame(width: size.width, height: size.height)
            }
        }.frame(width: size.width, height: size.height)
    }
}

//struct RenderIfWillBeSeen_Previews: PreviewProvider {
//    static var previews: some View {
//        RenderIfWillBeSeen()
//    }
//}
