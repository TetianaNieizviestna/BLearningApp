//
//  AppCoordinator.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit

extension AppCoordinator {
    private enum Route {
        case main
        case deviceInfo(Device)
    }
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private weak var rootController: UIViewController?
    private var disposable: Disposable?
    private let store: Store<AppState>
    private var activeCoordinator: Coordinator?
    
    init(window: UIWindow, store: Store<AppState> = StoreLocator.shared) {
        self.window = window
        self.store = store
    }
    
    func start() {

        let mainCoordinator = MainCoordinator(window: window)
        mainCoordinator.start()
        activeCoordinator = mainCoordinator

//        let rootController = main()
//        window.rootViewController = rootController
//        self.rootController = rootController

//        disposable = store.subscribeUnique(on: .main) { [weak self] state in
//            guard let `self` = self else { return }
//                self.route(.main)
//                self.store.dispatch(AppInitializationAction())
//        }
    }
//
//    private func route(_ route: Route) {
//        switch route {
//        case .main:
//            let output = MainCoordinator.Output(
//                deviceInfo: CommandWith { [weak self] device in
//                    self?.route(.deviceInfo(device))
//            })
//
//        case .deviceInfo(let device):
//            deviceInfo(device)
//            let output = DeviceInfoFactory.Output(close: Command { [weak self] in
//                self?.route(.deviceInfo(device))
//            })
//
//        }
//    }
    
//    private func deviceInfo(_ device: Device) -> DeviceInfoViewController {
//        let output = DeviceInfoFactory.Output(
//            close: Command { [weak self] in
//                self?.route(.deviceInfoDismiss(device))
//            }
//        )
//        return DeviceInfoFactory().default(output, device: device)
//    }
    
//    private func splash() -> SplashViewController {
//        let output = SplashScreenFactory.Output(
//            main: Command { [weak self] in
//                self?.route(.main)
//            }
//        )
//        return SplashScreenFactory().default(output)
//    }

    deinit {
        disposable?.dispose()
        printDeinit(self)
    }
}
