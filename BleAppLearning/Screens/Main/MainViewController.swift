//
//  MainViewController.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit
import CoreBluetooth

final class MainViewController: UIViewController {
    struct Props {
        let state: State; enum State {
            case initial
            case loading
            case failure(message: String)
        }
        
        let onDevice: CommandWith<Device>
        let onDestroy: Command
        
        static let initial: Props = .init(
            state: .initial,
            onDevice: .nop,
            onDestroy: .nop
        )
    }
    private var props: Props = .initial

    var bleManager: CBCentralManager?

    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var deviceNameLabel: UILabel!
    @IBOutlet private var data3Label: UILabel!
    @IBOutlet private var data4Label: UILabel!
    @IBOutlet private var data5Label: UILabel!
    
    @IBOutlet private var devicesListTableView: UITableView!
    
    @IBOutlet private var startScanBtn: UIButton!
    @IBOutlet private var stopScanBtn: UIButton!
    
    @IBOutlet private var servicesBtn: UIButton!
    
    var devices: [CBPeripheral] = []
    var connectedDevises: [Device] = []
    
    var connectedDevice: Device?
   
    var services: [CBService] = []
    var characteristics: [CBCharacteristic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bleManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    func render(_ props: Props) {
        self.props = props
        
        devicesListTableView.reloadData()
        self.view.setNeedsLayout()
    }
    
    @IBAction func startScanBtnAction(_ sender: UIButton) {
        bleManager?.scanForPeripherals(withServices: nil, options: nil)
        startScanBtn.isEnabled = false
        stopScanBtn.isEnabled = true
    }

    @IBAction func stopScanBtnAction(_ sender: UIButton) {
        stopScan()
    }
    
    @IBAction func servicesBtnAction(_ sender: UIButton) {
        connectedDevice?.discoverServices(nil)
    }
    
    private func stopScan() {
        bleManager?.stopScan()
        setDefaultBtnStates()
    }
    
    private func setupUI() {
        startScanBtn.setTitle("Scan Devices...", for: .normal)
        startScanBtn.setTitle("Scan Devices...", for: .highlighted)
        startScanBtn.setTitle("Scan Devices...", for: .focused)
        startScanBtn.setTitle("Scaning...", for: .disabled)
        
        startScanBtn.setTitleColor(UIColor.systemPurple, for: .normal)
        startScanBtn.setTitleColor(UIColor.systemPurple, for: .highlighted)
        startScanBtn.setTitleColor(UIColor.systemPurple, for: .focused)
        startScanBtn.setTitleColor(UIColor.systemGray, for: .disabled)

        stopScanBtn.setTitleColor(UIColor.systemOrange, for: .normal)
        stopScanBtn.setTitleColor(UIColor.systemOrange, for: .highlighted)
        stopScanBtn.setTitleColor(UIColor.systemOrange, for: .focused)

        stopScanBtn.setTitleColor(UIColor.systemGray, for: .disabled)
        setDefaultBtnStates()
        setupTableView()
    }
    
    private func setupTableView() {
        devicesListTableView.setDataSource(self, delegate: self)
        devicesListTableView.register([DeviceTableViewCell.identifier])
    }
    
    private func changeDeviceConnection(_ index: Int) {
        switch devices[index].state {
        case .disconnected:
            bleManager?.connect(devices[index], options: nil)
            connectedDevice = devices[index]
            connectedDevice?.delegate = self
            deviceNameLabel.text = connectedDevice?.name ?? ""
        case .connected:
            bleManager?.cancelPeripheralConnection(devices[index])
            connectedDevice = nil
            deviceNameLabel.text = ""
        default:
            break
        }
    }
    
    private func reloadData() {
        
    }
    
    private func setDefaultBtnStates() {
        startScanBtn.isEnabled = true
        stopScanBtn.isEnabled = false
    }
    
    private func changeDeviceState(for device: CBPeripheral, error: Error? = nil) {
        print("DEVICE \"\(device.name ?? "no name")\" state: \(device.state.name)")
        handleError(source: "changeDeviceState", error: error) {
            if let firstIndex = self.devices.firstIndex(where: { $0.identifier == device.identifier }) {
                self.devices[firstIndex] = device
            }
            self.devicesListTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeDeviceConnection(indexPath.row)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.identifier) as? DeviceTableViewCell else { return UITableViewCell() }
        let device = devices[indexPath.row]
        cell.configure(title: device.name ?? "", id: "\(device.identifier)", state: device.state)
        return cell
    }
}

extension MainViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        stateLabel.text = "Bluetooth: \(central.state.name)"
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !devices.contains(where: { $0.identifier == peripheral.identifier }) {
            devices.append(peripheral)
        } else {
            changeDeviceState(for: peripheral)
        }
        devicesListTableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        stopScan()
        changeDeviceState(for: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        changeDeviceState(for: peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        changeDeviceState(for: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        changeDeviceState(for: peripheral, error: error)
    }
    
}

extension MainViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        handleError(source: "peripheral.didDiscoverServices", error: error) {
            self.services = peripheral.services ?? []
            self.services.forEach { service in
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        handleError(source: "peripheral.didDiscoverCharacteristicsFor", error: error) {
            service.characteristics?.forEach({
                if !self.characteristics.contains($0) {
                    self.characteristics.append($0)
                    peripheral.readValue(for: $0)
                    
                    Printer.printData($0.value)
                }
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        handleError(source: "peripheral.didUpdateValueFor", error: error) {
            print("Characteristic value updated! \(characteristic.description)")
        }
    }
    
    private func handleError(source: String, error: Error?, completion: (() -> Void)?) {
        if let error = error {
            var message = error.localizedDescription
            #if DEBUG
            message = "\(source): \(error.localizedDescription)"
            #endif
            print("[ERROR]: \(message)")
            showAlert(title: "Error!", message: message)
        } else {
            completion?()
        }
    }
}

