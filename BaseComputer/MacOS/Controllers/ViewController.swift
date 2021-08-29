//
//  ViewController.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.08.2021.
//

import AppKit

class ViewController: NSViewController {
    @IBOutlet weak var scrollView: NSScrollView!
    
    @IBOutlet private weak var tableView: NSTableView!

    @IBOutlet weak var commandCounterLabel: NSTextField!
    @IBOutlet weak var addressRegisterLabel: NSTextField!
    @IBOutlet weak var commandRegisterLabel: NSTextField!
    @IBOutlet weak var dataRegisterLabel: NSTextField!
    @IBOutlet weak var shiftRegisterLabel: NSTextField!
    @IBOutlet weak var accumulatorLabel: NSTextField!

    @IBOutlet weak var microCommandCounterLabel: NSTextField!
    @IBOutlet weak var microCommandRegisterLabel: NSTextField!
    @IBOutlet weak var bufferRegisterLabel: NSTextField!

    @IBOutlet weak var shiftFlag: NSButton!
    @IBOutlet weak var nullFlag: NSButton!
    @IBOutlet weak var signFlag: NSButton!
    @IBOutlet weak var zeroFlag: NSButton!
    @IBOutlet weak var allowInterruptFlag: NSButton!
    @IBOutlet weak var interruptedFlag: NSButton!
    @IBOutlet weak var externalStatusFlag: NSButton!
    @IBOutlet weak var workingFlag: NSButton!
    @IBOutlet weak var programFlag: NSButton!
    @IBOutlet weak var commandFetchingFlag: NSButton!
    @IBOutlet weak var addressFetchingFlag: NSButton!
    @IBOutlet weak var executionFlag: NSButton!
    @IBOutlet weak var ioFlag: NSButton!

    @IBOutlet weak var externalStack: NSStackView!
    
    private var programConstraint: NSLayoutConstraint?
    private var microProgramConstraint: NSLayoutConstraint?

    private var computer: Computer?
    private var configuration: PresentationConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        programConstraint = scrollView.widthAnchor.constraint(equalToConstant: 270)
        microProgramConstraint = scrollView.widthAnchor.constraint(equalToConstant: 450)

        setupFlags()
    }

    public func inject(_ computer: Computer) {
        self.computer = computer

        tableView.reloadData()

        updateLabels()
        updateFlags()
        setUpExternalDevices()
    }
    
    public func inject(_ configuration: PresentationConfiguration) {
        self.configuration = configuration
        
        tableView.reloadData()
        
        setupScrollViewWidth()
    }

    public func update() {
        updateLabels()
        setupFlags()

        tableView.reloadData()
        
        setupScrollViewWidth()
    }

    @IBAction func allowInterruptChanged(_ sender: NSButton) {
        computer?.statusRegister.allowInterrupt = sender.state == .on
        interruptedFlag.isEnabled = computer?.statusRegister.allowInterrupt ?? false
    }


    @IBAction func interruptedChanged(_ sender: NSButton) {
        computer?.statusRegister.interrupted = sender.state == .on
    }

    @IBAction func workingChanged(_ sender: NSButton) {
        computer?.statusRegister.working = sender.state == .on
    }

    private func updateLabels() {
        guard let computer = computer else { return }
        
        commandCounterLabel.stringValue = "СК: \(computer.commandCounter.string)"
        commandCounterLabel.toolTip = String(computer.commandCounter.value)
        
        addressRegisterLabel.stringValue = "РА: \(computer.addressRegister.string)"
        addressRegisterLabel.toolTip = String(computer.addressRegister.value)
        
        commandRegisterLabel.stringValue = "РК: \(computer.commandRegister.string)"
        commandRegisterLabel.toolTip = String(computer.commandRegister.value)
        
        dataRegisterLabel.stringValue = "РД: \(computer.dataRegister.string)"
        dataRegisterLabel.toolTip = String(computer.dataRegister.value)
        
        shiftRegisterLabel.stringValue = "С: \(computer.shift.string)"
        shiftRegisterLabel.toolTip = String(computer.shift.value)
        
        accumulatorLabel.stringValue = "А: \(computer.accumulator.string)"
        accumulatorLabel.toolTip = String(computer.accumulator.value)

        microCommandCounterLabel.stringValue = "СчМК: \(computer.microCommandManager.microCommandCounter.string)"
        microCommandCounterLabel.toolTip = String(computer.microCommandManager.microCommandCounter.value)
        
        microCommandRegisterLabel.stringValue = "РМК: \(computer.microCommandManager.microCommandRegister.string)"
        microCommandRegisterLabel.toolTip = String(computer.microCommandManager.microCommandRegister.value)
        
        bufferRegisterLabel.stringValue = "БР: \(computer.microCommandManager.buffer.string)"
        bufferRegisterLabel.toolTip = String(computer.microCommandManager.buffer.value)
    }

    private func setupFlags() {
        shiftFlag.title = "0 - Перенос"
        shiftFlag.isEnabled = false
        shiftFlag.toolTip = "Наличие значения в регистре переноса"

        nullFlag.title = "1 - Нуль"
        nullFlag.isEnabled = false
        nullFlag.toolTip = "Наличие значения в аккумуляторе"

        signFlag.title = "2 - Знак"
        signFlag.isEnabled = false
        signFlag.toolTip = "Положительное ли число в аккумуляторе"

        zeroFlag.title = "3 - Ноль"
        zeroFlag.isEnabled = false
        zeroFlag.toolTip = "Константный флаг, используется \nдля безусловных переходов МПУ"

        allowInterruptFlag.title = "4 - Разрешение Прерывания"
        allowInterruptFlag.isEnabled = true

        interruptedFlag.title = "5 - Прерывание"
        interruptedFlag.isEnabled = allowInterruptFlag.state == .on

        externalStatusFlag.title = "6 - Статус ВУ"
        externalStatusFlag.isEnabled = false
        externalStatusFlag.toolTip = "Готово ли хотя бы одно ВУ"

        workingFlag.title = "7 - Работа/Остановка"
        workingFlag.isEnabled = true

        programFlag.title = "8 - Программа"
        programFlag.isEnabled = false

        commandFetchingFlag.title = "9 - Выборка команды"
        commandFetchingFlag.isEnabled = false

        addressFetchingFlag.title = "10 - Выборка адреса"
        addressFetchingFlag.isEnabled = false

        executionFlag.title = "11 - Исполнение"
        executionFlag.isEnabled = false

        ioFlag.title = "12 - Ввод-вывод"
        ioFlag.isEnabled = false
        ioFlag.toolTip = "Происходит ли операция ввода-вывода"
    }

    private func updateFlags() {
        guard let computer = computer else { return }

        shiftFlag.state = computer.statusRegister.shift  ? .on : .off
        nullFlag.state = computer.statusRegister.null ? .on : .off
        signFlag.state = computer.statusRegister.sign ? .on : .off
        zeroFlag.state = computer.statusRegister.zero ? .on : .off
        allowInterruptFlag.state = computer.statusRegister.allowInterrupt ? .on : .off

        interruptedFlag.state = computer.statusRegister.interrupted ? .on : .off
        interruptedFlag.isEnabled = computer.statusRegister.allowInterrupt

        externalStatusFlag.state = computer.statusRegister.externalDevice ? .on : .off
        workingFlag.state = computer.statusRegister.working ? .on : .off
        programFlag.state = computer.statusRegister.program ? .on : .off
        commandFetchingFlag.state = computer.statusRegister.commandFetch ? .on : .off
        addressFetchingFlag.state = computer.statusRegister.addressFetch ? .on : .off
        executionFlag.state = computer.statusRegister.execution ? .on : .off
        ioFlag.state = computer.statusRegister.IO ? .on : .off
    }
    
    private func setupScrollViewWidth() {
        guard let configuration = configuration else { return }
        
        if configuration.mode == .program {
            self.microProgramConstraint?.isActive = false
            self.programConstraint?.isActive = true
        } else {
            self.programConstraint?.isActive = false
            self.microProgramConstraint?.isActive = true
        }
    }

    private func setUpExternalDevices() {
        guard let computer = computer else { return }

        let height: CGFloat = 300

        for (index, device) in computer.externalDevices.enumerated() {
            let deviceView = ExternalDeviceView(
                    frame: NSRect(x: 0, y: 0, width: externalStack.frame.width, height: height),
                    device: device,
                    number: index + 1)
            deviceView.updater = { [weak self] in
                self?.externalStatusFlag.state = self?.computer?.statusRegister.externalDevice ?? false
                    ? .on
                    : .off
            }

            externalStack.addArrangedSubview(deviceView)
        }

        externalStack.addArrangedSubview(NSView(frame: NSRect.infinite))
    }
    
    private func getCommand(index: Int) -> ComputerCommand? {
        guard let computer = computer,
              let configuration = configuration else { return nil }
        
        if configuration.mode == .program {
            return computer.program[index]
        } else {
            return computer.microCommandManager.microCommandMemory[index]
        }
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let computer = computer,
              let configuration = configuration else { return 0 }
        
        return configuration.mode == .program
            ? computer.program.count
            : computer.microCommandManager.microCommandMemory.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        40
    }

    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        true
    }

    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        tableColumn == tableView.tableColumns[1]
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let computer = computer,
              let command = getCommand(index: row),
              let tableColumn = tableColumn,
              let index = tableView.tableColumns.firstIndex(of: tableColumn),
              let view = tableView
                .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TextCell\(index)"), owner: nil),
              let cell = view as? NSTableCellView,
              let textField = cell.textField else {
            return nil
        }
        
        textField.isBordered = false
        textField.isBezeled = false
        textField.layer?.cornerRadius = 5
        textField.focusRingType = .none
        textField.isEditable = self.tableView(tableView, shouldEdit: tableColumn, row: row)
        
        textField.drawsBackground = true
        textField.backgroundColor = .clear
        
        textField.target = self
        textField.action = #selector(executeUpdate(_:))
        
        textField.tag = row

        if tableColumn == tableView.tableColumns[0] {
            cell.textField?.stringValue = String(command.number, radix: 16)
                .commandFormat(command is MicroCommand ? 2 : 3)
            cell.toolTip = String(command.number)
        } else if tableColumn == tableView.tableColumns[1] {
            cell.textField?.stringValue = command.string
            
        } else if tableColumn == tableView.tableColumns[2] {
            cell.textField?.stringValue = command.description

            if let command = command as? Command {
                cell.toolTip = command.longDescription
            } else if command is MicroCommand {
                cell.toolTip = command.description
            }
        }
        
        if command is Command && Int(computer.commandCounter.value) == command.number ||
            command is MicroCommand && Int(computer.microCommandManager.microCommandCounter.value) == command.number {
            cell.wantsLayer = true
            cell.layer = CALayer()
            cell.layer!.frame = NSRect(x: cell.layer?.frame.minX ?? 0,
                                       y: cell.layer?.frame.minY ?? 0,
                                       width: cell.frame.width,
                                       height: cell.frame.height)
            cell.layer!.backgroundColor = NSColor.systemBlue.cgColor
            
        } else {
            cell.wantsLayer = false
            cell.layer = nil
        }

        return cell
    }
    
    @objc private func executeUpdate(_ sender: Any) {
        guard let sender = sender as? NSTextField else { return }
        
        let tag = sender.tag
        computer?.program[tag].string = sender.stringValue
        tableView.reloadData(forRowIndexes: IndexSet(integer: tag),
                             columnIndexes: IndexSet(integersIn: 1...2))
    }
}
