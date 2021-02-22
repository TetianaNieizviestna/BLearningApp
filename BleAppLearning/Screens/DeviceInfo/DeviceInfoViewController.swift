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

    @IBOutlet private var closeBtn: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func render(_ props: Props) {
        self.props = props
        titleLabel.text = props.title
        self.view.setNeedsLayout()
    }

    @IBAction func closeBtnAction(_ sender: UIButton) {
        props.onClose.perform()
    }
    
    @IBAction func swipeGestureAction(_ sender: UISwipeGestureRecognizer) {
        props.onClose.perform()
    }
}
