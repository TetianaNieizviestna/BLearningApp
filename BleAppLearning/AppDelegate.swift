//
//  AppDelegate.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 20.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var activeCoordinator: Coordinator?

    private lazy var store: Store<AppState> = {
        .init(
            state: .initial,
            reducer: reduce,
            middleware: [
                loggerMiddleware
//                ProfileBalanceMiddleware().middleware(),
//                DataBaseMiddleware().middleware(),
            ]
        )
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        StoreLocator.populate(instance: store)
        
        startApp()
        return true
    }

    private func startApp() {
        guard let window = self.window else { return }
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        self.activeCoordinator = appCoordinator
    }

}

