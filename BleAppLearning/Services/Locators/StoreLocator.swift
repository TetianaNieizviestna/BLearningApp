//
//  StoreLocator.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

enum StoreLocator {
    static var shared: Store<AppState> {
        guard let instance = instance else { fatalError("Store not populated") }
        return instance
    }
    
    private static var instance: Store<AppState>?
    
    static func populate(instance: Store<AppState>) {
        self.instance = instance
    }
}
