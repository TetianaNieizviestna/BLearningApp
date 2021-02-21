//
//  SwiftyReduxBridging.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import SwiftyRedux

typealias GetAppState = SwiftyRedux.GetState<AppState>
typealias GetState<State> = SwiftyRedux.GetState<State>
typealias Dispatch = SwiftyRedux.Dispatch
typealias Store<State> = SwiftyRedux.Store<State>
typealias Disposable = SwiftyRedux.Disposable
typealias Middleware<State> = SwiftyRedux.Middleware<State>
typealias Action = SwiftyRedux.Action
typealias BatchAction = SwiftyRedux.BatchAction

func createMiddleware<State>(_ middleware: @escaping Middleware<State>) -> Middleware<State> {
    return SwiftyRedux.createMiddleware(middleware)
}

func batchDispatchMiddleware<State>() -> Middleware<State> {
    return SwiftyRedux.batchDispatchMiddleware()
}
