//
//  ExternalDeviceView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.08.2021.
//

import Cocoa

class ExternalDeviceView: NSView {
    private let device: ExternalDevice

    private let nameLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBezeled = false

        return label
    }()

    private let dataField: NSTextField = {
        let field = NSTextField()
        field.action = #selector(setData)
        field.focusRingType = .none

        return field
    }()

    private let readyToggle: NSButton = {
        let toggle = NSButton(checkboxWithTitle: "Готовность", target: nil, action: #selector(setReady))

        return toggle
    }()
    private let queueLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBezeled = false

        return label
    }()

    private let queueField: NSTextField = {
        let field = NSTextField()
        field.action = #selector(setQueue)
        field.focusRingType = .none

        return field
    }()

    public var updater: (() -> ())?


    public init(frame: NSRect, device: ExternalDevice, number: Int) {
        self.device = device

        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupLabels(number: number)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    private func setupViews() {
        addSubview(nameLabel)
        addSubview(dataField)
        addSubview(readyToggle)
        addSubview(queueLabel)
        addSubview(queueField)
        
        dataField.target = self
        readyToggle.target = self
        
        queueField.target = self
        queueField.usesSingleLineMode = true
        
        queueLabel.toolTip = "Записывайте значения через пробелы"
        
        readyToggle.state = device.isReady ? .on : .off
    }

    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dataField.translatesAutoresizingMaskIntoConstraints = false
        readyToggle.translatesAutoresizingMaskIntoConstraints = false
        queueLabel.translatesAutoresizingMaskIntoConstraints = false
        queueField.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10

        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true

        dataField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: padding).isActive = true
        dataField.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        dataField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        dataField.widthAnchor.constraint(equalToConstant: 30).isActive = true

        readyToggle.leadingAnchor.constraint(equalTo: dataField.trailingAnchor, constant: padding).isActive = true
        readyToggle.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        readyToggle.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        readyToggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true

        queueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        queueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding).isActive = true
        queueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true

        queueField.leadingAnchor.constraint(equalTo: dataField.leadingAnchor).isActive = true
        queueField.topAnchor.constraint(equalTo: queueLabel.topAnchor).isActive = true
        queueField.bottomAnchor.constraint(equalTo: queueLabel.bottomAnchor).isActive = true
        queueField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
    }

    private func setupLabels(number: Int) {
        nameLabel.stringValue = "ВУ-\(number) РД:"
        queueLabel.stringValue = "Очередь"
    }

    @objc private func setReady() {
        device.isReady = readyToggle.state == .on
        updater?()
    }

    @objc private func setData() {
        device.string = dataField.stringValue
    }

    @objc private func setQueue() {
        device.queue = queueField.stringValue
    }
}
