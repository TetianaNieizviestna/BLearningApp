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
    let deviceInfo: DeviceInfoState
    
    init(
        main: MainState = .initial,
        deviceInfo: DeviceInfoState = .initial
    ) {
        self.main = main
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
            deviceInfo: reduce(state.deviceInfo, action)
        )
    }
}
