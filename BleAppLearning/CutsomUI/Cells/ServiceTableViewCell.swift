//
//  ServiceTableViewCell.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 23.02.2021.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    struct Props {
        let title: String
        let id: String

        let onSelect: Command
        
        static let initial: Props = .init(
            title: "",
            id: "",
            onSelect: .nop
        )
    }
    
    private var props: Props = .initial
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func render(_ props: Props) {
        self.props = props
        nameLabel.text = props.title
        idLabel.text = props.id
    }

}
