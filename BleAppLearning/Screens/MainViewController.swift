//
//  MainViewController.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit
import CoreBluetooth

final class MainViewController: UIViewController {
    var bleManager: CBCentralManager?

    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var devicesListLabel: UILabel!
    @IBOutlet private var data3Label: UILabel!
    @IBOutlet private var data4Label: UILabel!
    @IBOutlet private var data5Label: UILabel!
    
    @IBOutlet private var devicesListTableView: UITableView!
    
    @IBOutlet private var startScanBtn: UIButton!
    @IBOutlet private var stopScanBtn: UIButton!
    
    var devices: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bleManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    @IBAction func startScanBtnAction(_ sender: UIButton) {
        bleManager?.scanForPeripherals(withServices: nil, options: nil)
        startScanBtn.isEnabled = false
        stopScanBtn.isEnabled = true
    }

    @IBAction func stopScanBtnAction(_ sender: UIButton) {
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
    
    private func connectDevice(_ index: Int) {
        bleManager?.connect(devices[index], options: nil)
    }
    
    private func setDefaultBtnStates() {
        startScanBtn.isEnabled = true
        stopScanBtn.isEnabled = false
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath.row)")
        connectDevice(indexPath.row)
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
        let text: String
        switch central.state {
        case .poweredOn:
            text = "State: ON"
        case .resetting:
            text = "State: RESET"
        case .unknown:
            text = "State: UNKNOWN"
        case .unsupported:
            text = "State: UNSUPPORTED"
        case .unauthorized:
            text = "State: UNAUTHORIZED"
        case .poweredOff:
            text = "State: OFF"
        @unknown default:
            text = "State: UNKNOWN DEFAULT"
        }
        print(text)
        stateLabel.text = text
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !devices.contains(where: { $0.identifier == peripheral.identifier }) {
            devices.append(peripheral)
        }
        devicesListTableView.reloadData()
    }

}
