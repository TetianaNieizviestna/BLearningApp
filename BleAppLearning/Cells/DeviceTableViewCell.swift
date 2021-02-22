//
//  DeviceTableViewCell.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit
import CoreBluetooth

class DeviceTableViewCell: UITableViewCell {
    struct Props {
        let title: String
        let id: String
        let state: DeviceState

        let onSelect: Command
        
        static let initial: Props = .init(
            title: "",
            id: "",
            state: .disconnected,
            onSelect: .nop
        )
    }
    
    private var props: Props = .initial
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var stateImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func render(_ props: Props) {
        self.props = props
        nameLabel.text = props.title
        idLabel.text = props.id
        activityIndicator.hidesWhenStopped = true
        
        stateImageView.isHidden = props.state != .connected

        switch props.state {
        case .connected:
            activityIndicator.stopAnimating()
        case .connecting, .disconnecting:
            activityIndicator.startAnimating()
        case .disconnected:
            activityIndicator.stopAnimating()
        @unknown default:
            activityIndicator.stopAnimating()
        }
    }
}
