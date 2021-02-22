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
//                loggerMiddleware,
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

    // MARK: UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

}

