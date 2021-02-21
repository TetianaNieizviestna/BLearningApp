//
//  UIStoryboard.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit

enum Storyboard {
    static let main = storyboard(name: "Main")
    static let deviceInfo = storyboard(name: "DeviceInfo")
}

private func storyboard(name: String, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: bundle)
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    func instantiate<T: StoryboardIdentifiable>() -> T {
        guard let controller = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Controller is nil with the identifier: \(T.storyboardIdentifier)")
        }
        return controller
    }
}

extension UIViewController: StoryboardIdentifiable {}
