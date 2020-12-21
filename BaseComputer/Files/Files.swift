//
//  Menu.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 24.10.2020.
//

import SwiftUI
import Cocoa

func saveProgram(_ computer: Computer) {
    guard let window: NSWindow = NSApplication.shared.keyWindow else { return }
    
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["bc"]
    
    computer.program.initial = computer.program.commands
    
    
    panel.beginSheetModal(for: window) { (response) in
        if response == NSApplication.ModalResponse.OK
        {
            guard let url = panel.url else { return }
            
            var text: String = ""
            let manager = FileManager.default
            
            for command in computer.program.commands
            {
                if command.value == 0 { continue }
                if command.number == computer.program.start { text += "+ " }
                text += String.init(command.number, radix: 16).setLength(3).uppercased()
                    + " "
                    + command.string
                    + "\n"
            }
            
            if !manager.fileExists(atPath: url.absoluteString) { manager.createFile(atPath: url.path, contents: text.data(using: .utf8) , attributes: nil); print(url.path)}
            else
            {
                do {
                    try text.write(toFile: url.absoluteString,
                                   atomically: true,
                                   encoding: .utf8)
                } catch {
                    let alert = NSAlert()
                    alert.alertStyle = .critical
                    alert.messageText = "File not saved. Error: \(error)"
                    
                    alert.runModal()
                }
            }
        }
    }
}

func openProgram(_ computer: Computer) {
    guard let window = NSApplication.shared.keyWindow else { return }
    
    let panel = NSOpenPanel()
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    panel.allowsMultipleSelection = false
    panel.allowedFileTypes = ["bc"]
    
    panel.beginSheetModal(for: window) { (result) in
        if result == NSApplication.ModalResponse.OK
        {
            guard let url = panel.url else { return }
            let fileData = NSData.init(contentsOf: url)
            
            let dataString = NSString(data: fileData! as Data, encoding: String.Encoding.utf8.rawValue)
            
            
            if dataString != nil {
                computer.program = dataString!.toProgram() ?? Program()
                computer.commandCounter.setValue(computer.program.start)
                
                print("Program assigned", computer.program.commands.count)
            } else {
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "File damaged"
                
                alert.runModal()
            }
        }
    }
}


func saveMicroProgram(_ computer: Computer) {
    guard let window: NSWindow = NSApplication.shared.keyWindow else { return }
    
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["bcmp"]
    
    panel.beginSheetModal(for: window) { (response) in
        if response == NSApplication.ModalResponse.OK {
            guard let url = panel.url else { return }
            
            var text = ""
            
            for microCommand in computer.microCommandManager.microCommandMemory {
                text += "\(microCommand.string)\n"
            }
            
            let manager = FileManager.default
            
            if !manager.fileExists(atPath: url.absoluteString) { manager.createFile(atPath: url.path, contents: text.data(using: .utf8) , attributes: nil); print(url.path)}
            else
            {
                do {
                    try text.write(toFile: url.absoluteString,
                                   atomically: true,
                                   encoding: .utf8)
                } catch {
                    let alert = NSAlert()
                    alert.alertStyle = .critical
                    alert.messageText = "File not saved. Error: \(error)"
                    
                    alert.runModal()
                }
            }
        }
    }
}

func openMicroProgram(_ computer: Computer) {
    guard let window = NSApplication.shared.keyWindow else { return }
    
    let panel = NSOpenPanel()
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    panel.allowsMultipleSelection = false
    panel.allowedFileTypes = ["bcmp"]
    
    panel.beginSheetModal(for: window) { (result) in
        if result == NSApplication.ModalResponse.OK
        {
            guard let url = panel.url else { return }
            let fileData = NSData.init(contentsOf: url)
            
            let dataString = NSString(data: fileData! as Data, encoding: String.Encoding.utf8.rawValue)
            
            
            if dataString != nil {
                let array = dataString!.components(separatedBy: "\n")
                var commands: [String] = []
                
                for microCommand in array {
                    let components = microCommand.components(separatedBy: " ")
                    
                    if components.count != 1 {
                        let alert = NSAlert()
                        alert.alertStyle = .critical
                        alert.messageText = "Wrong file format"
                        
                        alert.runModal()
                        
                        return
                    }
                    
                    commands.append(components[0])
                }
                
                computer.microCommandManager.microCommandMemory = MicroCommand.array(commands)
                
            } else {
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "File damaged"
                
                alert.runModal()
            }
        }
    }
}

func insertMicroProgram(_ computer: Computer) {
    guard let window = NSApplication.shared.keyWindow else { return }
    
    let panel = NSOpenPanel()
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    panel.allowsMultipleSelection = false
    panel.allowedFileTypes = ["bcmp"]
    
    panel.beginSheetModal(for: window) { (result) in
        if result == NSApplication.ModalResponse.OK
        {
            guard let url = panel.url else { return }
            let fileData = NSData.init(contentsOf: url)
            
            let dataString = NSString(data: fileData! as Data, encoding: String.Encoding.utf8.rawValue)
            
            
            if dataString != nil {
                let array = dataString!.components(separatedBy: "\n")
                var commands: [String] = []
                var index: Int? = nil
                
                for microCommand in array {
                    let components = microCommand.components(separatedBy: " ")
                    
                    if components.count != 1 {
                        let alert = NSAlert()
                        alert.alertStyle = .critical
                        alert.messageText = "Wrong file format"
                        
                        alert.runModal()
                        
                        return
                    }
                    
                    if components[0] == "POSITION" {
                        index = array.firstIndex(of: microCommand)
                    }
                    
                    commands.append(components[0])
                }
                
                if index == nil {
                    let alert = NSAlert()
                    alert.alertStyle = .critical
                    alert.messageText = "Wrong file format"
                    
                    alert.runModal()
                } else {
                    for i in index!..<(index! + commands.count) {
                        computer.microCommandManager.microCommandMemory[i] = MicroCommand(number: i, value: commands[i - index!])
                    }
                }
                
            } else {
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "File damaged"
                
                alert.runModal()
            }
        }
    }
}


func saveTracing(_ traceTable: [CommandStatus], mode: Bool) {
    let manager = FileManager.default
    guard let window: NSWindow = NSApplication.shared.keyWindow else { return }
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["html"]
    panel.nameFieldStringValue = "Tracing"
    
    print("Save panel will appear")
    
    panel.beginSheetModal(for: window) { (response) in
        print("Save panel have appeared")
        if response == NSApplication.ModalResponse.OK {
            guard let url = panel.url else { return }
            
            print("HTML table building started")
            
            var file: String = ""
            
            file += HTML.header("Трассировка программы")
            file += HTML.tableOpen(border: 1)
            
            
            if mode {
                file += HTML.tableHeader(["СК", "Команда", "", "","А", "С", "РА", "РК", "РД", "РС", "Номер ячейки поменявшей значение","Новое значение", "ВУ-1 Статус", "ВУ-1 Значение", "ВУ-2 Статус", "ВУ-2 Значение", "ВУ-3 Статус", "ВУ-3 Значение"],
                                         attributes: "align=\"right\" bgcolor=\"silver\"")
            } else {
                file += HTML.tableHeader(["СК", "Команда", "А", "С", "РА", "РК", "РД", "РС", "Номер ячейки поменявшей значение","Новое значение", "ВУ-1 Статус", "ВУ-1 Значение", "ВУ-2 Статус", "ВУ-2 Значение", "ВУ-3 Статус", "ВУ-3 Значение"],
                                         attributes: "align=\"right\" bgcolor=\"silver\"")
            }
            
            for command in traceTable {
                if mode {
                    file += HTML.tableRow(
                        [String(command.command.number, radix: 16).commandFormat(3),
                         command.command.string,
                         "",
                         "",
                         String.init(command.accumulator, radix: 16).commandFormat(),
                         command.shift ? "1" : "0",
                         String.init(command.addressRegister, radix: 16).commandFormat(),
                         String.init(command.commandRegister, radix: 16).commandFormat(),
                         String.init(command.dataRegister, radix: 16).commandFormat(),
                         String.init(command.statusRegister, radix: 16).commandFormat(),
                         command.changedCommand == nil ? "" : String.init(command.changedCommand!.number, radix: 16).commandFormat(3),
                         command.changedCommand == nil ? "" : command.changedCommand!.string,
                         command.externalDevices[0].isReady ? "Готов" : "Не готов", command.externalDevices[0].string,
                         command.externalDevices[1].isReady ? "Готов" : "Не готов", command.externalDevices[1].string,
                         command.externalDevices[2].isReady ? "Готов" : "Не готов", command.externalDevices[2].string],
                        attributes: "bgcolor=\"\("gray")\" align=\"right\"")
                    
                    file += HTML.tableHeader(["СМК", "Микро-команда", "РМК", "БР", "", "", "", "", "", "", "", "","", "", "", "", "", ""],
                                             attributes: "align=\"right\" bgcolor=\"silver\"")
                    
                    for mStat in command.microCommands {
                        file += HTML.tableRow(
                            [String(mStat.microCommand.number, radix: 16).commandFormat(3),
                             mStat.microCommand.string,
                             String.init(mStat.microCommandRegister, radix: 16).commandFormat(),
                             String.init(mStat.buffer, radix: 16).commandFormat(),
                             String.init(mStat.accumulator, radix: 16).commandFormat(),
                             mStat.shift ? "1" : "0", String.init(command.addressRegister, radix: 16),
                             String.init(mStat.commandRegister, radix: 16).commandFormat(),
                             String.init(mStat.dataRegister, radix: 16).commandFormat(),
                             String.init(mStat.statusRegister, radix: 16).commandFormat(),
                             "",
                             "",
                             mStat.externalDevices[0].isReady ? "Готов" : "Не готов", mStat.externalDevices[0].string,
                             mStat.externalDevices[1].isReady ? "Готов" : "Не готов", mStat.externalDevices[1].string,
                             mStat.externalDevices[2].isReady ? "Готов" : "Не готов", mStat.externalDevices[2].string],
                            attributes: "bgcolor=\"#d6d6d6\" align=\"right\"")
                    }
                } else {
                    file += HTML.tableRow(
                        [String(command.command.number, radix: 16).commandFormat(3),
                         command.command.string,
                         String.init(command.accumulator, radix: 16).commandFormat(),
                         command.shift ? "1" : "0",
                         String.init(command.addressRegister, radix: 16).commandFormat(),
                         String.init(command.commandRegister, radix: 16).commandFormat(),
                         String.init(command.dataRegister, radix: 16).commandFormat(),
                         String.init(command.statusRegister, radix: 16).commandFormat(),
                         command.changedCommand == nil ? "" : String.init(command.changedCommand!.number, radix: 16).commandFormat(3),
                         command.changedCommand == nil ? "" : command.changedCommand!.string,
                         command.externalDevices[0].isReady ? "Готов" : "Не готов", command.externalDevices[0].string,
                         command.externalDevices[1].isReady ? "Готов" : "Не готов", command.externalDevices[1].string,
                         command.externalDevices[2].isReady ? "Готов" : "Не готов", command.externalDevices[2].string],
                        attributes: "bgcolor=\"\("#d6d6d6")\" align=\"right\"")
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

func saveDescription(_ array: [[String]]) {
    let manager = FileManager.default
    guard let window: NSWindow = NSApplication.shared.keyWindow else { return }
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["html"]
    panel.nameFieldStringValue = "Description"
    
    print("Save panel will appear")
    
    panel.beginSheetModal(for: window) { (response) in
        if response == NSApplication.ModalResponse.OK {
            guard let url = panel.url else { return }
            
            print("HTML table building started")
            
            var file: String = ""
            
            file += HTML.header("Описание программы")
            file += HTML.tableOpen(border: 1, padding: 2, width: 0)
            
            
            file += HTML.tableHeader(["Номер", "Код", "Мнемоника", "Описание"],
                                     attributes: "align=\"left\" bgcolor=\"silver\"")
            
            for row in array {
                file += HTML.tableRow(row,
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
