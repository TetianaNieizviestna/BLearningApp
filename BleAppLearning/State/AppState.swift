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

    init(
        main: MainState = .initial
    ) {
        self.main = main
    }
}

func reduce(_ state: AppState, _ action: Action) -> AppState {
    switch action {
    case is AppInitializationAction:
        return .initial
    default:
        return .init(
            main: reduce(state.main, action)
        )
    }
}
