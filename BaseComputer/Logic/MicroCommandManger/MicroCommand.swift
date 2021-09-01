//
//  MicroCommand.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

struct MicroCommand: ComputerCommand, Hashable {
    var value: UInt16
    var number: Int

    var string: String {
        get {
            String(value, radix: 16).commandFormat()

        }
        set {
            value = UInt16(newValue, radix: 16) ?? 0
        }
    }

    func operationCode() -> UInt16 {
        let v = value[14...15]
        return v > 1 ? 2 : v

    }

    var description: String {
        get {
            switch operationCode() {
            case 0:
                var result = "ОМК0: "

                if reverseCode() > 0 {
                    result += "~"
                }
                switch leftGate() {
                case 0:
                    result += "0 "
                case 1:
                    result += "A "
                case 2:
                    result += "РС "
                case 3:
                    result += "КР "
                default:
                    print("Unknown left gate")
                    return ""
                }

                switch operation() {
                case 0:
                    result += "+ "
                case 1:
                    result += "+ "
                case 2:
                    result += "& "
                default:
                    print("Unknown operation")
                    return ""
                }

                if reverseCode() > 1 {
                    result += "~"
                }
                switch rightGate() {
                case 0:
                    result += "0 "
                case 1:
                    result += "РД "
                case 2:
                    result += "РК "
                case 3:
                    result += "СК "
                default:
                    print("Unknown right gate")
                    return ""
                }
                if operation() == 1 {
                    result += "+ 1"
                }

                result += " -> БР; "

                if !(shifts() == 0 && memory() == 0) {
                    switch shifts() {
                    case 0:
                        ()
                    case 1:
                        result += "(A >> 1) -> БР; "
                    case 2:
                        result += "(A << 1) -> БР; "
                    default:
                        print("Unknown shift")
                        return ""
                    }

                    switch memory() {
                    case 0:
                        ()
                    case 1:
                        result += "ОП(РА) -> РД;"
                    case 2:
                        result += "РД -> ОП(РА);"
                    default:
                        print("Unknown memory")
                        return ""
                    }
                }

                return result

            case 1:
                var result = "ОМК1: "

                if shift() == 1 || null() == 1 || sign() == 1 {
                    result += "БР -> "
                    if shift() == 1 {
                        result += "C, "
                    }
                    if null() == 1 {
                        result += "N, "
                    }
                    if sign() == 1 {
                        result += "S; "
                    }
                }

                if (shift() > 1) {
                    result += "\(shift() == 2 ? "0" : "1") -> C "
                }

                if (terminate() == 1) {
                    result += "0 -> РС(7) "
                }

                switch destination() {
                case 0:
                    ()
                case 1:
                    result += "БР -> РА"
                case 2:
                    result += "БР -> РД"
                case 3:
                    result += "БР -> РК"
                case 4:
                    result += "БР -> СК"
                case 5:
                    result += "БР -> А"
                case 7:
                    result += "БР -> РА, РД, РК, А"
                default:
                    print("Unknown destination")
                    return ""
                }

                return result

            case 2:
                var result = "УМК: IF "

                switch register() {
                case 0:
                    result += "РС"
                case 1:
                    result += "РД"
                case 2:
                    result += "РК"
                case 3:
                    result += "А"
                default:
                    print("Unknown register")
                    return ""
                }

                result += "(\(bitChecked())) == \(compareField()) THEN "

                result += "\(String(address(), radix: 16).commandFormat(2)) -> CМK"

                return result

            default:
                print("Unknown micro command")
                return ""
            }
        }
    }

    //MARK: Операционная микрокоманда 0
    func leftGate() -> UInt16 {
        value[12...13]
    }

    func rightGate() -> UInt16 {
        value[8...9]
    }

    func reverseCode() -> UInt16 {
        value[6...7]
    }

    func operation() -> UInt16 {
        value[4...5]
    }

    func shifts() -> UInt16 {
        value[2...3]
    }

    func memory() -> UInt16 {
        value[0...1]
    }

    //MARK: Операционная микрокоманда 1
    func unused() -> UInt16 {
        value[12...13]
    }

    func exchange() -> UInt16 {
        value[8...11]
    }

    func shift() -> UInt16 {
        value[6...7]
    }

    func null() -> UInt16 {
        value[5]
    }

    func sign() -> UInt16 {
        value[4]
    }

    func terminate() -> UInt16 {
        value[3]
    }

    func destination() -> UInt16 {
        value[0...2]
    }

    //MARK: Управляющая микрокоманда
    func compareField() -> UInt16 {
        value[14]
    }

    func register() -> UInt16 {
        value[12...13]
    }

    func bitChecked() -> UInt16 {
        value[8...11]
    }

    func address() -> UInt16 {
        value[0...7]
    }

    init(number: Int, value: UInt16 = UInt16(0)) {
        self.value = value
        self.number = number
    }

    init(number: Int, value: String) {
        self.number = number
        self.value = UInt16(value, radix: 16) ?? 0
    }

    static func array(_ strings: [String]) -> [MicroCommand] {
        var array: [MicroCommand] = []
        for i in strings.indices {
            array.append(MicroCommand(number: i, value: strings[i]))
        }
        return array
    }
}
