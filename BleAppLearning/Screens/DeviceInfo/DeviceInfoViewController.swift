//
//  DeviceInfoViewController.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit
import CoreBluetooth

extension DeviceInfoViewController.Props.State: Equatable {}

final class DeviceInfoViewController: UIViewController {
    struct Props {
        let state: State; enum State {
            case initial
            case connection
            case loadingServices
            case loaded
            case failure(String)
        }
        let bleManager: CBCentralManager
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
            bleManager: CBCentralManager(),
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
        props.device?.discoverServices(nil)

    }
    
    func render(_ props: Props) {
        self.props = props
        bleManager = props.bleManager
        bleManager?.delegate = self
        
        titleLabel.text = props.title
        
        stateImageView.isHidden = props.device?.state != .connected
        
        switch props.state {
        case .initial:
            break
        case .connection:
            activityIndicator.startAnimating()
        case .loadingServices:
            props.device?.discoverServices(nil)
            print("Loading Services...")
        case .loaded:
            activityIndicator.stopAnimating()
        case .failure(let error):
            activityIndicator.stopAnimating()
            showAlert(title: "Error!", message: error)
        }
        
        servicesTableView.reloadData()

        displayDeviceState(self.props.device?.state)

    }
    
    private func displayDeviceState(_ state: DeviceState?) {
        var title: String
        var color: UIColor
        switch state {
        case .connected, .connecting:
            title = "Disconnect"
            color = UIColor.systemOrange
        default:
            title = "Connect"
            color = UIColor.systemGreen
        }
        connectBtn.setTitle(title, for: .normal)
        connectBtn.setTitleColor(color, for: .normal)
    }
    
    private func setupUI() {
        servicesTableView.setDataSource(self, delegate: self)
        servicesTableView.register([ServiceTableViewCell.identifier])
        servicesTableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.hidesWhenStopped = true
        displayDeviceState(props.device?.state)
    }
    
    private func changeDeviceConnection() {
        guard let device = props.device else { return }
        switch device.state {
        case .disconnected:
            bleManager?.connect(device)
            device.delegate = self
        case .connected:
            bleManager?.cancelPeripheralConnection(device)
        default:
            bleManager?.cancelPeripheralConnection(device)
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
            showAlert(title: "Error!", message: "Bluetooth is \(central.state.name). Please turn on Bluetooth in settings of your device.")
        }
        
        connectBtn.isEnabled = central.state == .poweredOn
        props.changeBleStatus.perform(with: central.state.name)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        props.changeState.perform(with: peripheral)
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        handleError(source: "didDisconnectPeripheral", error: error) {
            self.props.changeState.perform(with: peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        props.changeState.perform(with: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        handleError(source: "didFailToConnect", error: error, completion: {
            self.props.changeState.perform(with: peripheral)
        })
    }
}

extension DeviceInfoViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if props.device?.identifier == peripheral.identifier {
            handleError(source: "didDiscoverServices", error: error) {
                self.props.servicesFound.perform(with: peripheral.services ?? [])
                self.props.services.forEach { service in
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        handleError(source: "didDiscoverCharacteristicsFor", error: error) {
            service.characteristics?.forEach({
                peripheral.readValue(for: $0)
                Printer.printData($0.value)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        handleError(source: "didUpdateValueFor", error: error) {
//            print("Characteristic value updated! \(characteristic.description)")
//        }
    }
}

extension DeviceInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect.perform()
    }
}

extension DeviceInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier) as? ServiceTableViewCell else { return UITableViewCell() }
        let cellProps = props.items[indexPath.row]
        cell.render(cellProps)
        return cell
    }
}
