//
//  BindingForEach.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 30.08.2021.
//

import SwiftUI

struct BindingForEach<Data: MutableCollection, Content: View>: DynamicViewContent where Data.Index: Hashable,
                                                                                        Data.Indices == Range<Int> {
    @Binding public var data: Data
    private var builder: (Binding<Data.Element>) -> Content
    private var elementBindings = FunctionCache<Data.Index, Binding<Data.Element>>()
    
    init(_ collection: Binding<Data>, @ViewBuilder _ content: @escaping (Binding<Data.Element>) -> Content) {
        self._data = collection
        self.builder = content
        self.elementBindings = FunctionCache<Data.Index, Binding<Data.Element>> { [self] (i) in
            Binding<Data.Element> { [self] in
                self.data[i]
            } set: { [self] in
                self.data[i] = $0
            }
        }
    }
    
    var body: some View {
        ForEach(data.enumerated().map({ (i, _) in i }), id: \.self) { i in
            builder(elementBindings[i])
        }
    }
}

//struct BindingForEach_Previews: PreviewProvider {
//    static var previews: some View {
//        BindingForEach()
//    }
//}
