//
//  Logger.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 22.02.2021.
//

let loggerMiddleware: Middleware<AppState> = createMiddleware { getState, _, next in { action in
    guard let oldState = getState() else { return }
    printInDebug("[OLD ➡️]: \(oldState)")
    printInDebug("[MSG ✅]: \(action)")
    next(action)
    guard let newState = getState() else { return }
    printInDebug("[NEW ⬅️]: \(newState)\n")
    }
}
