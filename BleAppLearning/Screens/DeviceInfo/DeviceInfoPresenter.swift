//
//  DeviceInfoPresenter.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

struct DeviceInfoPresenter {
    typealias Props = DeviceInfoViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let onClose: Command
    let endObserving: Command
    
    func present(state: AppState, device: Device) {
        render.perform(
            with: .init(
                title: "Device: \(device.name ?? "no name")",
                state:  getState(state),
                onClose: onClose,
                onDestroy: endObserving
            )
        )
    }
    
    private func getState(_ state: AppState) -> Props.State {
        return .initial
    }
}
