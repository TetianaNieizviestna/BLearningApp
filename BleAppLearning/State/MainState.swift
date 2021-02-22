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
        devices: [],
        connectedDevices: [],
        currentDevice: nil)
    
    var state: MainScreenState; enum MainScreenState {
        case initial
        case scanning
        case failure(String)
    }
    
    var bleState: String
    var devices: [Device] = []
    var connectedDevices: [Device] = []
    
    let currentDevice: Device?
    
    init(
        state: MainScreenState,
        bleState: String,
        devices: [Device],
        connectedDevices: [Device],
        currentDevice: Device?
    ) {
        self.state = state
        self.bleState = bleState
        self.devices = devices
        self.connectedDevices = connectedDevices
        self.currentDevice = currentDevice
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
        var newCurrent = state.currentDevice
        if action.device.identifier == state.currentDevice?.identifier {
            if action.device.state != .connected {
                newCurrent = nil
            }
        }

        return .init(
            state: state.state,
            bleState: state.bleState,
            devices: newDevices,
            connectedDevices: state.connectedDevices,
            currentDevice: newCurrent
        )
    case let action as DeviceConnectedAction:
        var newConnected = state.connectedDevices
        newConnected.append(action.device)
        return .init(
            state: state.state,
            bleState: state.bleState,
            devices: state.devices,
            connectedDevices: newConnected,
            currentDevice: action.device
        )
    case let action as DeviceDisconnectedAction:
        var newConnected = state.connectedDevices
        newConnected.removeAll(where: { $0.identifier == action.device.identifier })
        return .init(
            state: state.state,
            bleState: state.bleState,
            devices: state.devices,
            connectedDevices: newConnected,
            currentDevice: nil
        )
    case let action as DeviceChangeStateAction:
        var newDevices = state.devices
        if let firstIndex = newDevices.firstIndex(where: { $0.identifier == action.device.identifier }) {
            newDevices[firstIndex] = action.device
        }
        var newCurrent = state.currentDevice
        if action.device.identifier == state.currentDevice?.identifier {
            if action.device.state != .connected {
                newCurrent = nil
            }
        }
        return .init(
            state: state.state,
            bleState: state.bleState,
            devices: newDevices,
            connectedDevices: state.connectedDevices,
            currentDevice: newCurrent
        )
    case let action as MainFailureAction:
        return .init(
            state: .failure(action.error),
            bleState: state.bleState,
            devices: state.devices,
            connectedDevices: state.connectedDevices,
            currentDevice: state.currentDevice
        )
    case let action as BLEStateAction:
        return .init(
            state: .initial,
            bleState: action.name,
            devices: state.devices,
            connectedDevices: state.connectedDevices,
            currentDevice: state.currentDevice
        )
    default:
        return state
    }
}
