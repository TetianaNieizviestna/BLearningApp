//
//  DeviceTableViewCell.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit
import CoreBluetooth

class DeviceTableViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var stateImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String, id: String, state: CBPeripheralState) {
        nameLabel.text = title
        idLabel.text = id
        activityIndicator.hidesWhenStopped = true
        
        stateImageView.isHidden = state != .connected

        switch state {
        case .connected:
            activityIndicator.stopAnimating()
            stateImageView.image = UIImage(named: "checkmark.circle.fill")
        case .connecting, .disconnecting:
            activityIndicator.startAnimating()
        case .disconnected:
            activityIndicator.stopAnimating()
        @unknown default:
            activityIndicator.stopAnimating()
            break
        }
    }
}
