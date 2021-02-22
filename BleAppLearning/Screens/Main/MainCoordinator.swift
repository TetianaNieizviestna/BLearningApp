//
//  MainCoordinator.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit

extension MainCoordinator {
    private enum Route {
        case deviceInfo(Device)
        case deviceInfoDismiss
    }
}

final class MainCoordinator: Coordinator {
    private let window: UIWindow
    private weak var rootController: UIViewController?
    
    init(window: UIWindow) { 
        self.window = window
    }
    
    func start() {
        let rootController = self.main()
        self.window.rootViewController = rootController
        self.rootController = rootController
    }
    
    private func route(_ route: Route) {
        switch route {
        case .deviceInfo(let device):
            rootController?.present(deviceInfo(device), animated: false)
        case .deviceInfoDismiss:
            rootController?.dismiss(animated: false)
        }
    }
    
    private func main() -> MainViewController {
        let output = MainFactory.Output(
            onDevice: CommandWith { device in
                self.route(.deviceInfo(device))
        })
        return MainFactory().default(output)
    }
    
    private func deviceInfo(_ device: Device) -> DeviceInfoViewController {
        let output = DeviceInfoFactory.Output(
            close: Command { [weak self] in
                self?.route(.deviceInfoDismiss)
            }
        )
        return DeviceInfoFactory().default(output, device: device)
    }
        
}
