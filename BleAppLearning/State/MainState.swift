//
//  MainState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

extension MainState: Equatable {}

struct MainState {
    static let initial = MainState(currentDevice: nil)
    
    let currentDevice: Device?

    init(
        currentDevice: Device?
    ) {
        self.currentDevice = currentDevice
    }
}

func reduce(_ state: MainState, _ action: Action) -> MainState {
    switch action {
//    case is AccountAutorizedLoadedAction:
//        return .init(
//            initialization: .initial,
//            authorization: .initial,
//            authorized: reduce(state.authorized, action)
//        )
    default:
        return .init(
            currentDevice: nil
        )
    }
}
