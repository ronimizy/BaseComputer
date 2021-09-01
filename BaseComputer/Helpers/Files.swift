//
//  Menu.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 24.10.2020.
//

import SwiftUI
import AppKit

class ProgramFileManager {
    private static let queue = DispatchQueue(label: "com.ronimizy.file", attributes: .concurrent)
    
    public static func saveProgram(_ computer: Computer) {
        guard let window: NSWindow = NSApplication.shared.keyWindow else {
            return
        }

        let panel = NSSavePanel()
        panel.allowedFileTypes = ["bc"]

        computer.program.initial = computer.program.commands

        panel.beginSheetModal(for: window) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    return
                }

                queue.async {
                    let text: String = ProgramCoder.encodeProgram(program: computer.program)
                    let manager = FileManager.default

                    if !manager.fileExists(atPath: url.absoluteString) {
                        manager.createFile(atPath: url.path, contents: text.data(using: .utf8), attributes: nil)
                        print(url.path)
                    } else {
                        do {
                            try text.write(toFile: url.absoluteString,
                                    atomically: true,
                                    encoding: .utf8)
                        } catch {
                            AlertManager.runAlert(message: "File not saved. Error: \(error)", style: .critical)
                        }
                    }
                }
            }
        }
    }

    public static func openProgram(_ computer: Computer) {
        guard let window = NSApplication.shared.keyWindow else {
            return
        }

        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["bc"]

        panel.beginSheetModal(for: window, completionHandler: { (result) in
            if result == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    return
                }
                let fileData = NSData.init(contentsOf: url)

                guard let dataString = NSString(data: fileData! as Data, encoding: String.Encoding.utf8.rawValue) else {
                    AlertManager.runAlert(message: "File damaged", style: .critical)
                    return
                }
                
                queue.async {
                    let program = ProgramCoder.decodeProgram(data: dataString) ?? Program()
                    
                    syncMain {
                        computer.clear()

                        computer.program = program
                        computer.commandCounter.value = computer.program.start
                        
                        print("Program assigned", computer.program.commands.count)
                        print(computer.commandCounter.value)
                    }
                }
            }
        })
    }


    public static func saveMicroProgram(_ computer: Computer) {
        guard let window: NSWindow = NSApplication.shared.keyWindow else {
            return
        }

        let panel = NSSavePanel()
        panel.allowedFileTypes = ["bcmp"]

        panel.beginSheetModal(for: window) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    return
                }

                queue.async {
                    let text: String = ProgramCoder.encodeMicroProgram(manager: computer.microCommandManager)

                    let manager = FileManager.default

                    if !manager.fileExists(atPath: url.absoluteString) {
                        manager.createFile(atPath: url.path, contents: text.data(using: .utf8), attributes: nil); print(url.path)
                    } else {
                        do {
                            try text.write(toFile: url.absoluteString,
                                    atomically: true,
                                    encoding: .utf8)
                        } catch {
                            AlertManager.runAlert(message: "File not saved. Error: \(error)", style: .critical)
                        }
                    }
                }
            }
        }
    }

    public static func openMicroProgram(_ computer: Computer) {
        guard let window = NSApplication.shared.keyWindow else {
            return
        }

        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["bcmp"]

        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    return
                }
                
                queue.async {
                    let fileData = NSData.init(contentsOf: url)

                    guard let dataString = NSString(data: fileData! as Data, encoding: String.Encoding.utf8.rawValue) else {
                        AlertManager.runAlert(message: "File damaged", style: .critical)
                        return
                    }

                    ProgramCoder.decodeMicroProgram(data: dataString, manager: &computer.microCommandManager)
                }
            }
        }
    }

    public static func saveTracing(_ traceTable: [CommandStatus], mode: Bool) {
        let manager = FileManager.default
        guard let window: NSWindow = NSApplication.shared.keyWindow else {
            return
        }
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["html"]
        panel.nameFieldStringValue = "Tracing"

        print("Save panel will appear")

        panel.beginSheetModal(for: window) { (response) in
            print("Save panel have appeared")
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    return
                }

                print("HTML table building started")

                queue.async {
                    var file: String = ""

                    file += Html.header("Трассировка программы")
                    file += Html.tableOpen(border: 1)


                    if mode {
                        file += Html.tableHeader(["#", "СК", "Команда", "", "", "А", "С", "РА", "РК", "РД", "РС", "Номер ячейки поменявшей значение", "Новое значение", "ВУ-1 Статус", "ВУ-1 Значение", "ВУ-2 Статус", "ВУ-2 Значение", "ВУ-3 Статус", "ВУ-3 Значение"],
                                attributes: "align=\"right\" bgcolor=\"silver\"")
                    } else {
                        file += Html.tableHeader(["#", "СК", "Команда", "А", "С", "РА", "РК", "РД", "РС", "Номер ячейки поменявшей значение", "Новое значение", "ВУ-1 Статус", "ВУ-1 Значение", "ВУ-2 Статус", "ВУ-2 Значение", "ВУ-3 Статус", "ВУ-3 Значение"],
                                attributes: "align=\"right\" bgcolor=\"silver\"")
                    }

                    for command in traceTable {
                        file += command.toHTMLTableRow(mode: mode, attributes: "bgcolor=\"\(mode ? "gray" : "#d6d6d6")\" align=\"right\"")

                        if mode {
                            file += Html.tableHeader(["СМК", "Микро-команда", "РМК", "БР", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
                                    attributes: "align=\"right\" bgcolor=\"silver\"")

                            for microCommand in command.microCommands {
                                file += microCommand.toHTMLTableRow(attributes: "bgcolor=\"#d6d6d6\" align=\"right\"")
                            }
                        }
                    }

                    print("HTML table was built")

                    file += "</table>\n"
                    file += "</body>\n"
                    file += "</html>"


                    manager.createFile(atPath: url.path, contents: file.data(using: .utf8), attributes: nil)
                    print("HTML file was created at \(url.path)")
                }
            }
        }
    }

    public static func saveDescription(_ array: [[String]]) {
        let manager = FileManager.default
        guard let window: NSWindow = NSApplication.shared.keyWindow else {
            return
        }
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["html"]
        panel.nameFieldStringValue = "Description"

        print("Save panel will appear")

        panel.beginSheetModal(for: window) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    return
                }

                print("HTML table building started")

                queue.async {
                    var file: String = ""

                    file += Html.header("Описание программы")
                    file += Html.tableOpen(border: 1, padding: 2, width: 0)


                    file += Html.tableHeader(["Номер", "Код", "Мнемоника", "Описание"],
                            attributes: "align=\"left\" bgcolor=\"silver\"")

                    for row in array {
                        file += Html.tableRow(row,
                                attributes: "bgcolor=\"#d6d6d6\" align=\"left\"")
                    }

                    print("HTML table was built")

                    file += "</table>\n"
                    file += "</body>\n"
                    file += "</html>"


                    manager.createFile(atPath: url.path, contents: file.data(using: .utf8), attributes: nil)
                    print("HTML file was created at \(url.path)")
                }
            }
        }
    }
}
