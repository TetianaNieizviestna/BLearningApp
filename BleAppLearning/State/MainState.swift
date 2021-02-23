//
//  MainState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

extension MainState: Equatable {}
extension MainState.MainScreenState: Equatable {}

struct MainState {
    static let initial = MainState(
        state: .initial,
        devices: []
    )
    
    var state: MainScreenState; enum MainScreenState {
        case initial
        case scanning
        case failure(String)
    }
    
    var devices: [Device] = []
    
    init(
        state: MainScreenState,
        devices: [Device]
    ) {
        self.state = state
        self.devices = devices
    }
}

func reduce(_ state: MainState, _ action: Action) -> MainState {
    switch action {
    case let action as DeviceFoundAction:
        var newDevices = state.devices

        if !newDevices.contains(where: { $0.identifier == action.device.identifier }) {
            newDevices.append(action.device)
        } else {
            if let firstIndex = newDevices.firstIndex(where: { $0.identifier == action.device.identifier }) {
                newDevices[firstIndex] = action.device
            }
        }
        return .init(
            state: state.state,
            devices: newDevices
        )
    case let action as MainFailureAction:
        return .init(
            state: .failure(action.error),
            devices: state.devices
        )
    case is ScanStartAction:
        return .init(
            state: .scanning,
            devices: state.devices
        )
    case is ScanStopAction:
        return .init(
            state: .initial,
            devices: state.devices
        )
    case let action as DeviceChangeStateAction:
        var newDevices = state.devices
        if let firstIndex = newDevices.firstIndex(where: { $0.identifier == action.device.identifier }) {
            newDevices[firstIndex] = action.device
        }
        return .init(
            state: state.state,
            devices: newDevices
        )
    default:
        return state
    }
}
