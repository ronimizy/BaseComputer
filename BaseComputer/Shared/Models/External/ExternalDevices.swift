//
// Created by Георгий Круглов on 25.08.2021.
//

import Foundation

class ExternalDevices: RandomAccessCollection, MutableCollection {
    typealias Element = Array<ExternalDevice>.Element
    typealias Index = Array<ExternalDevice>.Index
    typealias SubSequence = Array<ExternalDevice>.SubSequence
    typealias Indices = Array<ExternalDevice>.Indices

    private var devices: [ExternalDevice]

    var startIndex: Array<ExternalDevice>.Index {
        devices.startIndex
    }

    var endIndex: Array<ExternalDevice>.Index {
        devices.endIndex
    }

    subscript(position: Array<ExternalDevice>.Index) -> Array<ExternalDevice>.Element {
        get {
            devices[position]
        }
        set {
            devices[position] = newValue
        }
    }

    init(_ devices: [ExternalDevice] = []) {
        self.devices = devices
    }
}
