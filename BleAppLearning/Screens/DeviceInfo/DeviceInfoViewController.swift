//
//  DeviceInfoViewController.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit

class DeviceInfoViewController: UIViewController {
    struct Props {
        let title: String
        
        let state: State; enum State {
            case initial
            case loading
            case failure(message: String)
        }
        
        let onClose: Command
        let onDestroy: Command
        
        static let initial: Props = .init(
            title: "",
            state: .initial,
            onClose: .nop,
            onDestroy: .nop
        )
    }
    
    private var props: Props = .initial

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func render(_ props: Props) {
        self.props = props

        self.view.setNeedsLayout()
    }

}
