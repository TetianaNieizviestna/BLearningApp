//
//  DeviceInfoState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 23.02.2021.
//

import Foundation
extension DeviceInfoState: Equatable {}
extension DeviceInfoState.State: Equatable {}

struct DeviceInfoState {
    static let initial = DeviceInfoState(
        state: .initial,
        bleState: "",
        services: [],
        currentDevice: nil)
    
    var state: State; enum State {
        case initial
        case loading
        case failure(String)
    }
    
    var bleState: String
    var services: [BTService] = []
    
    let currentDevice: Device?
    
    init(
        state: State,
        bleState: String,
        services: [BTService],
        currentDevice: Device?
    ) {
        self.state = state
        self.bleState = bleState
        self.services = services
        self.currentDevice = currentDevice
    }
}

func reduce(_ state: DeviceInfoState, _ action: Action) -> DeviceInfoState {
    switch action {
    case let action as DeviceChangeStateAction:
        return .init(
            state: state.state,
            bleState: state.bleState,
            services: state.services,
            currentDevice: action.device
        )
    case let action as ServicesFoundAction:
        return .init(
            state: state.state,
            bleState: state.bleState,
            services: action.services,
            currentDevice: state.currentDevice
        )
    default:
        return state
    }
}
