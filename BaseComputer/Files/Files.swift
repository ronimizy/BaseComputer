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


func saveTracing(_ traceTable: [Status], mode: Bool) {
    
    
    let manager = FileManager.default
    guard let window: NSWindow = NSApplication.shared.keyWindow else { return }
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["html"]
    
    print("Save panel will appear")
    
    panel.beginSheetModal(for: window) { (response) in
        print("Save panel have appeared")
        if response == NSApplication.ModalResponse.OK {
            guard let url = panel.url else { return }
            
            print("HTML table building started")
            
            var file: String = ""
            
            file += HTML.header("Трассировка программы")
            file += HTML.tableOpen()
            
            if mode {
                file += HTML.tableHeader(["СМК", "Микро команда", "РМК", "БР", "А", "С", "РА", "РК", "РД", "РС", "ВУ 1 Статус", "ВУ 1 Значение", "ВУ 2 Статус", "ВУ 2 Значение", "ВУ 3 Статус", "ВУ 3 Значение"])
                
                for stat in traceTable as! [MicroCommandLevelStatus] {
                    file += HTML.tableRow(
                        [String(stat.microCommand.number, radix: 16).commandFormat(3),
                         stat.microCommand.string,
                         String.init(stat.microCommandRegister, radix: 16).commandFormat(),
                         String.init(stat.buffer, radix: 16).commandFormat(),
                         String.init(stat.accumulator, radix: 16).commandFormat(),
                         stat.shift ? "1" : "0", String.init(stat.addressRegister, radix: 16),
                         String.init(stat.commandRegister, radix: 16),
                         String.init(stat.dataRegister, radix: 16),
                         String.init(stat.statusRegister, radix: 16),
                        stat.externalDevices[0].isReady ? "Готов" : "Не готов", stat.externalDevices[0].string,
                        stat.externalDevices[1].isReady ? "Готов" : "Не готов", stat.externalDevices[1].string,
                        stat.externalDevices[2].isReady ? "Готов" : "Не готов", stat.externalDevices[2].string])
                }
            } else {
                file += HTML.tableHeader(["СК", "Команда", "Мнемоника","А", "С", "РА", "РК", "РД", "РС", "Номер ячейки поменявшей значение","Новое значение", "ВУ 1 Статус", "ВУ 1 Значение", "ВУ 2 Статус", "ВУ 2 Значение", "ВУ 3 Статус", "ВУ 3 Значение"])
                
                for stat in traceTable as! [CommandLevelStatus] {
                    file += HTML.tableRow(
                        [String(stat.command.number, radix: 16).commandFormat(3),
                         stat.command.string,
                         stat.command.mnemonics,
                         String.init(stat.accumulator, radix: 16).commandFormat(),
                         stat.shift ? "1" : "0",
                         String.init(stat.addressRegister, radix: 16).commandFormat(),
                         String.init(stat.commandRegister, radix: 16).commandFormat(),
                         String.init(stat.dataRegister, radix: 16).commandFormat(),
                         String.init(stat.statusRegister, radix: 16).commandFormat(),
                         stat.changedCommand == nil ? "" : String.init(stat.changedCommand!.number, radix: 16).commandFormat(3),
                         stat.changedCommand == nil ? "" : stat.changedCommand!.string,
                         stat.externalDevices[0].isReady ? "Готов" : "Не готов",
                         stat.externalDevices[0].string, stat.externalDevices[1].isReady ? "Готов" : "Не готов",
                         stat.externalDevices[1].string, stat.externalDevices[2].isReady ? "Готов" : "Не готов",
                         stat.externalDevices[2].string])
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
