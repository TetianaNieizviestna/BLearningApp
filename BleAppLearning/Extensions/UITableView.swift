//
//  UITableView.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit

extension UITableView {
    func register(_ cells: [String]) {
        cells.forEach {
            register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }
    }
    
    func setDataSource(_ dataSource: UITableViewDataSource, delegate: UITableViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension UITableViewCell {
    
    class var identifier: String {
        let separator = "."
        let fullName = String(describing: self)
        if fullName.contains(separator) {
            let items = fullName.components(separatedBy: separator)
            if let name = items.last {
                return name
            }
        }
        
        return fullName
    }
}
