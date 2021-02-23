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
        bleState: "",
        devices: []
        )
    
    var state: MainScreenState; enum MainScreenState {
        case initial
        case scanning
        case failure(String)
    }
    
    var bleState: String
    var devices: [Device] = []
    
    init(
        state: MainScreenState,
        bleState: String,
        devices: [Device]
    ) {
        self.state = state
        self.bleState = bleState
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
            bleState: state.bleState,
            devices: newDevices
        )
    case let action as MainFailureAction:
        return .init(
            state: .failure(action.error),
            bleState: state.bleState,
            devices: state.devices
        )
    case let action as BLEStateAction:
        return .init(
            state: .initial,
            bleState: action.name,
            devices: state.devices
        )
    case is ScanStartAction:
        return .init(
            state: .scanning,
            bleState: state.bleState,
            devices: state.devices
        )
    case is ScanStopAction:
        return .init(
            state: .initial,
            bleState: state.bleState,
            devices: state.devices
        )
    default:
        return state
    }
}
