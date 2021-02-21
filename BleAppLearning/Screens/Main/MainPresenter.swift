//
//  MainPresenter.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation
struct MainPresenter {
    typealias Props = MainViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let onDevice: CommandWith<Device>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: .init(
                state: getState(state),
                onDevice: onDevice,
                onDestroy: endObserving
            )
        )
    }
    
    private func getState(_ state: AppState) -> Props.State {
        return .initial
    }
}
