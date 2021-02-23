//
//  UIViewController+Alert.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction) in
            alertVC.dismiss(animated: true, completion: completion)
        }
        
        alertVC.addAction(okay)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func handleError(source: String, error: Error?, completion: (() -> Void)?) {
        if let error = error {
            var message = error.localizedDescription
            #if DEBUG
            message = "\(self.self).\(source): \(error.localizedDescription)"
            #endif
            print("[ERROR]: \(message)")
            showAlert(title: "Error!", message: message)
        } else {
            completion?()
        }
    }
}
