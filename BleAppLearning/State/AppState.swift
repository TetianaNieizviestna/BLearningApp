//
//  AppState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

extension AppState: Equatable {}

struct AppState {
    static let initial = AppState()

    let main: MainState
    let state: BLEState
    let deviceInfo: DeviceInfoState
    
    init(
        main: MainState = .initial,
        state: BLEState = .initial,
        deviceInfo: DeviceInfoState = .initial
    ) {
        self.main = main
        self.state = state
        self.deviceInfo = deviceInfo
    }
}

func reduce(_ state: AppState, _ action: Action) -> AppState {
    switch action {
    case is AppInitializationAction:
        return .initial
    default:
        return .init(
            main: reduce(state.main, action),
            state: reduce(state.state, action),
            deviceInfo: reduce(state.deviceInfo, action)
        )
    }
}
