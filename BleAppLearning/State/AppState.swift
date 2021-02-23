//
//  AppState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

extension AppState: Equatable {}//, AutoLenses, AutoCodable {}

struct AppState {
    static let initial = AppState()

    let main: MainState
    let bleState: BLEState
    let deviceInfo: DeviceInfoState
    
    init(
        main: MainState = .initial,
        bleState: BLEState = .initial,
        deviceInfo: DeviceInfoState = .initial
    ) {
        self.main = main
        self.bleState = bleState
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
            bleState: reduce(state.bleState, action),
            deviceInfo: reduce(state.deviceInfo, action)
        )
    }
}
