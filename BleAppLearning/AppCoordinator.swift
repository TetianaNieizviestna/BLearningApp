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
//        disposable = store.subscribeUnique(on: .main) { [weak self] state in
//            guard let strongSelf = self else { return }
//            let mainCoordinator = MainCoordinator(window: strongSelf.window)
//            mainCoordinator.start()
//            strongSelf.activeCoordinator = mainCoordinator
//        }

        let mainCoordinator = MainCoordinator(window: window)
        mainCoordinator.start()
        activeCoordinator = mainCoordinator
    }

    deinit {
        disposable?.dispose()
        printDeinit(self)
    }
}
