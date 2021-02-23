//
//  DeviceInfoViewController.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit
import CoreBluetooth

final class DeviceInfoViewController: UIViewController {
    struct Props {
        let state: State; enum State {
            case initial
            case loading
            case failure(String)
        }
        
        let device: Device?
        let title: String
        let items: [ServiceTableViewCell.Props]
        let services: [BTService]
        let changeBleStatus: CommandWith<String>
        let changeState: CommandWith<Device>
        let servicesFound: CommandWith<[BTService]>

        let onClose: Command
        let onDestroy: Command
        
        static let initial: Props = .init(
            state: .initial,
            device: nil,
            title: "",
            items: [],
            services: [],
            changeBleStatus: .nop,
            changeState: .nop,
            servicesFound: .nop,
            onClose: .nop,
            onDestroy: .nop
        )
    }
    
    private var props: Props = .initial
    var bleManager: CBCentralManager?

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var stateImageView: UIImageView!
    @IBOutlet private var closeBtn: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var servicesTableView: UITableView!
    @IBOutlet private var connectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bleManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        bleManager?.delegate = self
    }
    
    func render(_ props: Props) {
        self.props = props

        titleLabel.text = props.title
        self.props.device?.delegate = self
        setConnectBtn()
        switch self.props.device?.state {
        case .connected:
            activityIndicator.stopAnimating()
            stateImageView.isHidden = false
        case .disconnected:
            activityIndicator.stopAnimating()
            stateImageView.isHidden = true
        default:
            activityIndicator.startAnimating()
            stateImageView.isHidden = true
        }
        self.view.setNeedsLayout()
    }
    
    private func setupUI() {
        bleManager?.delegate = self
        
        servicesTableView.setDataSource(self, delegate: self)
        servicesTableView.register([ServiceTableViewCell.identifier])
        servicesTableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.hidesWhenStopped = true
        setConnectBtn()
    }
    
    private func setConnectBtn() {
        var title = "Connect"
        var color = UIColor.systemGreen
        if let state = props.device?.state {
            switch state {
            case .connected:
                title = "Disconnect"
                color = UIColor.systemGreen
                connectBtn.isEnabled = true
            case .disconnected:
                title = "Connect"
                color = UIColor.systemGreen
                connectBtn.isEnabled = true
            case .connecting:
                title = "Connecting..."
                color = UIColor.systemGray
                connectBtn.isEnabled = false
            case .disconnecting:
                title = "Disconnecting..."
                color = UIColor.systemGray
                connectBtn.isEnabled = false
            @unknown default:
                break
            }
        }

        connectBtn.setTitle(title, for: .normal)
        connectBtn.setTitle(title, for: .focused)
        connectBtn.setTitle(title, for: .highlighted)

        connectBtn.setTitleColor(color, for: .normal)
        connectBtn.setTitleColor(color, for: .focused)
        connectBtn.setTitleColor(color, for: .highlighted)
    }
    
    private func changeDeviceConnection() {
        guard let device = props.device else { return }
        switch device.state {
        case .disconnected:
            bleManager?.connect(device, options: nil)
        case .connected:
            bleManager?.cancelPeripheralConnection(device)
        default:
            break
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        props.onClose.perform()
    }
    
    @IBAction func swipeGestureAction(_ sender: UISwipeGestureRecognizer) {
        props.onClose.perform()
    }
    
    @IBAction func connectBtn(_ sender: UIButton) {
        changeDeviceConnection()
        if let device = props.device {
            self.props.changeState.perform(with: device)
        }
    }
}

extension DeviceInfoViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            showAlert(title: "Error!", message: "Bluetooth is not powered on. State: \(central.state.name). Please turn on Bluetooth in settings of your device.")
        }
        
        connectBtn.isEnabled = central.state == .poweredOn
        props.changeBleStatus.perform(with: central.state.name)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        props.changeState.perform(with: peripheral)
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        handleError(source: "didFailToConnect", error: error) {
            self.props.changeState.perform(with: peripheral)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        props.changeState.perform(with: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if props.device?.identifier == peripheral.identifier {
            handleError(source: "DeviceInfoViewController.didFailToConnect", error: error, completion: nil)
        }
    }
}

extension DeviceInfoViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if props.device?.identifier == peripheral.identifier {
            handleError(source: "peripheral.didDiscoverServices", error: error) {
                self.props.servicesFound.perform(with: peripheral.services ?? [])
//                self.services = peripheral.services ?? []
//                self.services.forEach { service in
//                    peripheral.discoverCharacteristics(nil, for: service)
//                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        handleError(source: "peripheral.didDiscoverCharacteristicsFor", error: error) {
//            service.characteristics?.forEach({
//                if !self.characteristics.contains($0) {
//                    self.characteristics.append($0)
//                    peripheral.readValue(for: $0)
//
//                    Printer.printData($0.value)
//                }
//            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        handleError(source: "peripheral.didUpdateValueFor", error: error) {
            print("Characteristic value updated! \(characteristic.description)")
        }
    }
}

extension DeviceInfoViewController: UITableViewDelegate {
    
}

extension DeviceInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.device?.services?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellProps = props.items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier) as? ServiceTableViewCell else { return UITableViewCell() }
        cell.render(cellProps)
        return cell
    }
}
