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
            case scanning
            case failure(String)
        }
        
        let bleManager: CBCentralManager
        let status: String
        let items: [DeviceTableViewCell.Props]
        
        let devices: [Device]
        
        let scanAction: Command
        let foundDevice: CommandWith<Device>
        let changeState: CommandWith<Device>
        let changeBleStatus: CommandWith<String>
        
        let onDestroy: Command
        
        static let initial: Props = .init(
            state: .initial,
            bleManager: CBCentralManager(),
            status: "",
            items: [],
            devices: [],
            scanAction: .nop,
            foundDevice: .nop,
            changeState: .nop,
            changeBleStatus: .nop,
            onDestroy: .nop
        )
    }
    private var props: Props = .initial

    var bleManager: CBCentralManager?

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var devicesListTableView: UITableView!
    @IBOutlet private var scanBtn: UIButton!
           
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.hidesWhenStopped = true
    }

    func render(_ props: Props) {
        self.props = props
        bleManager = props.bleManager
        bleManager?.delegate = self
        
        switch self.props.state {
        case .initial:
            setScanning(false)
        case .scanning:
            setScanning(true)
        case .failure(let error):
            setScanning(false)
            showAlert(title: "Error!", message: error)
        }
        stateLabel.text = props.status

        devicesListTableView.reloadData()
        self.view.setNeedsLayout()
    }
    
    private func setScanning(_ force: Bool) {
        force ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        let title = force ? "Stop" : "Start"
        let color = force ? UIColor.systemOrange : UIColor.systemPurple
        
        scanBtn.setTitle(title, for: .normal)
        scanBtn.setTitle(title, for: .highlighted)
        scanBtn.setTitle(title, for: .focused)
        scanBtn.setTitleColor(color, for: .normal)
        scanBtn.setTitleColor(color, for: .highlighted)
        scanBtn.setTitleColor(color, for: .focused)
    }
    
    @IBAction func startScanBtnAction(_ sender: UIButton) {
        switch props.state {
        case .scanning:
            bleManager?.stopScan()
        case .initial:
            bleManager?.scanForPeripherals(withServices: nil, options: nil)
        default:
            bleManager?.stopScan()
        }
        props.scanAction.perform()
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        devicesListTableView.setDataSource(self, delegate: self)
        devicesListTableView.register([DeviceTableViewCell.identifier])
        devicesListTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bleManager?.stopScan()
        props.items[indexPath.row].onSelect.perform()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellProps = props.items[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.identifier) as? DeviceTableViewCell else { return UITableViewCell() }
        cell.render(cellProps)
        return cell
    }
}

extension MainViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            showAlert(title: "Error!", message: "Bluetooth is not powered on. State: \(central.state.name). Please turn on Bluetooth in settings of your device.")
        }
        props.changeBleStatus.perform(with: central.state.name)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        props.foundDevice.perform(with: peripheral)
    }
}
