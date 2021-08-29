//
//  WindowContorller.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.08.2021.
//

import AppKit
import Combine

class WindowController: NSWindowController {
    private static let identifiers =
        [
            NSToolbarItem.Identifier.toggleProgramView,
            NSToolbarItem.Identifier.executeCommand,
            NSToolbarItem.Identifier.executeMicroCommand,
            NSToolbarItem.Identifier.clear,
            NSToolbarItem.Identifier.reset,
            NSToolbarItem.Identifier.trace,
            NSToolbarItem.Identifier.limitedTrace,
            NSToolbarItem.Identifier.microCommandTrace,
            NSToolbarItem.Identifier.programDescription,
            NSToolbarItem.Identifier.openProgram,
            NSToolbarItem.Identifier.saveProgram,
            NSToolbarItem.Identifier.openMicroProgram,
            NSToolbarItem.Identifier.saveMicroProgram
        ]
    
    
    @IBOutlet weak var toolbar: NSToolbar!
    
    private let configuration = PresentationConfiguration(mode: .program)
    
    private var computer: Computer?
    private var controller: ViewController?
    private var actions: [NSToolbarItem.Identifier : () -> ()] = [:]
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        injectData()
        
        window?.makeKey()
    }
    
    private func injectData() {
        do {
            try computer = Computer(2048)
        } catch let error {
            print(error)
            return
        }
        
        guard let controller = contentViewController as? ViewController else { return }
        
        self.controller = controller
        self.controller!.inject(computer!)
        self.controller!.inject(configuration)
    }
}

extension NSToolbarItem.Identifier {
    static let toggleProgramView = NSToolbarItem.Identifier("ToggleView")
    static let executeCommand = NSToolbarItem.Identifier("ExecuteCommand")
    static let executeMicroCommand = NSToolbarItem.Identifier("ExecuteMicroCommand")
    static let clear = NSToolbarItem.Identifier("Clear")
    static let reset = NSToolbarItem.Identifier("Reset")
    static let trace = NSToolbarItem.Identifier("Trace")
    static let limitedTrace = NSToolbarItem.Identifier("LimitedTrace")
    static let microCommandTrace = NSToolbarItem.Identifier("MicroCommandTrace")
    static let programDescription = NSToolbarItem.Identifier("ProgramDescription")
    static let openProgram = NSToolbarItem.Identifier("OpenProgram")
    static let saveProgram = NSToolbarItem.Identifier("SaveProgram")
    static let openMicroProgram = NSToolbarItem.Identifier("OpenMicroProgram")
    static let saveMicroProgram = NSToolbarItem.Identifier("SaveMicroProgram")
}

extension WindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        WindowController.identifiers
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        WindowController.identifiers
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .toggleProgramView:
            return createToolbarButton(identifier: .toggleProgramView,
                                       title: "Показать " + (configuration.mode == .program ? "микро-программу" : "программу"),
                                       tip: "Показать " + (configuration.mode == .program ? "микро-программу" : "программу") + " - ⌘Y",
                                       image: NSImage(named: .eyeglasses)!) { [weak self] in
                guard let configuration = self?.configuration,
                      let controller = self?.controller
                else {
                    return
                }

                configuration.mode = configuration.mode == .program ? .microProgram : .program
                controller.update()
            }


        case .executeCommand:
            return createToolbarButton(identifier: .executeCommand, title: "Выполнить команду",
                                       tip: "Выполнить команду - ⌘E",
                                       image: NSImage(named: .playFill)!) { [weak self] in
                self?.computer?.execute()
                self?.controller?.update()
            }

        case .executeMicroCommand:
            return createToolbarButton(identifier: .executeMicroCommand, title: "Выполнить микро-команду",
                                       tip: "Выполнить микро-команду - ⌘⇧E",
                                       image: NSImage(named: .play)!) { [weak self] in
                self?.computer?.microCommandManager.execute()
                self?.controller?.update()
            }

        case .clear:
            return createToolbarButton(identifier: .clear, title: "Сбросить БЭВМ",
                                       tip: "Сбросить БЭВМ - ⌘⇧C",
                                       image: NSImage(named: .trashFill)!) { [weak self] in
                do {
                    try self?.computer?.clear()
                } catch let error {
                    print(error)
                    return
                }
                self?.controller?.update()
            }

        case .reset:
            return createToolbarButton(identifier: .reset, title: "Перезагрузить программу БЭВМ",
                                       tip: "Перезагрузить программу - ⌘R",
                                       image: NSImage(named: "NSRefreshTemplate")!) { [weak self] in
                self?.computer?.restart()
                self?.controller?.update()
            }

        case .trace:
            return createToolbarButton(identifier: .trace, title: "Выполнить трассировку команд",
                                       tip: "Выполнить трассировку команд - ⌘T",
                                       image: NSImage(named: "NSListViewTemplate")!) { [weak self] in
                self?.computer?.trace(false)
                self?.controller?.update()
            }

        case .limitedTrace:
            return createToolbarButton(identifier: .limitedTrace, title: "Выполнить трассировку c ограниченным количеством команд",
                    tip: "Выполнить трассировку с ограниченным количеством команд - ⌘T",
                    image: NSImage(named: .listNumber)!) { [weak self] in

                let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
                let response = AlertManager.runAlert(
                        message: "Введите максимальное количество команд для трассировки",
                        style: .informational) { alert in
                    alert.addButton(withTitle: "OK")
                    alert.addButton(withTitle: "Cancel")
                    alert.accessoryView = field
                }

                if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                    guard let size = Int(field.stringValue) else {
                        AlertManager.runAlert(message: "Вы ввели не число", style: .critical)
                        return
                    }

                    self?.computer?.trace(false, size)
                    self?.controller?.update()
                }
            }
        case .microCommandTrace:
            return createToolbarButton(identifier: .microCommandTrace, title: "Выполнить трассировку микро комманд",
                                       tip: "Выполнить трассировку микро-команд - ⌘⇧T",
                                       image: NSImage(named: "NSPathTemplate")!) { [weak self] in
                self?.computer?.trace(true)
                self?.controller?.update()
            }

        case .programDescription:
            return createToolbarButton(identifier: .programDescription, title: "Получить описание программы",
                                       tip: "Получить описание программы - ⌘⇧D",
                                       image: NSImage(named: .listBulletRectangle)!) { [weak self] in
                guard let computer = self?.computer else { return }
                saveDescription(computer.program.description)
                self?.controller?.update()
            }
        case .openProgram:
            return createToolbarButton(identifier: .openProgram, title: "Открыть программу",
                                       tip: "Открыть программу - ⌘O",
                                       image: NSImage(named: .docFillBadgePlus)!) { [weak self] in
                guard let computer = self?.computer else { return }
                do {
                    try openProgram(computer)
                } catch let error {
                    print(error)
                    return
                }

                self?.controller?.update()
            }

        case .saveProgram:
            return createToolbarButton(identifier: .saveProgram, title: "Сохранить программу",
                                       tip: "Сохранить программу - ⌘S",
                                       image: NSImage(named: .arrowUpDocFill)!) { [weak self] in
                guard let computer = self?.computer else { return }
                saveProgram(computer)
            }

        case .openMicroProgram:
            return createToolbarButton(identifier: .openMicroProgram, title: "Открыть микро-программу",
                                       tip: "Открыть микро-программу - ⌘⇧O",
                                       image: NSImage(named: .docOnClipboard)!) { [weak self] in
                guard let computer = self?.computer else { return }
                openMicroProgram(computer)
                self?.controller?.update()
            }

        case .saveMicroProgram:
            return createToolbarButton(identifier: .saveMicroProgram, title: "Сохранить микро-програму",
                                       tip: "Сохранить микро-программу - ⌘⇧S",
                                       image: NSImage(named: .arrowUpDocOnClipboard)!) { [weak self] in
                guard let computer = self?.computer else { return }
                saveMicroProgram(computer)
            }

        default:
            return nil
        }
    }

    private func createToolbarButton(identifier: NSToolbarItem.Identifier,
                                     title: String,
                                     tip: String,
                                     image: NSImage,
                                     action: @escaping () -> ()) -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: identifier)
        item.toolTip = tip
        item.image = image
        item.target = self
        item.action = #selector(executeAction(_:))
        
        actions[identifier] = action

        let menuItem = NSMenuItem()
        menuItem.title = title

        item.menuFormRepresentation = menuItem

        return item
    }

    @objc private func executeAction(_ sender: Any) {
        guard let sender = sender as? NSToolbarItem,
              let action = actions[sender.itemIdentifier] else { return }
        action()
    }
}
