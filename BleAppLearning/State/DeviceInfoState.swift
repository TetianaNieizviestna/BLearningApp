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
        services: [],
        currentDevice: nil)
    
    var state: State; enum State {
        case initial
        case connection
        case serviceLoading
        case loaded
        case failure(String)
    }
    
    var services: [BTService] = []
    
    let currentDevice: Device?
    
    init(
        state: State,
        services: [BTService],
        currentDevice: Device?
    ) {
        self.state = state
        self.services = services
        self.currentDevice = currentDevice
    }
}

func reduce(_ state: DeviceInfoState, _ action: Action) -> DeviceInfoState {
    switch action {
    case let action as DeviceCurrentInitAction:
        let services = state.currentDevice?.state == .connected ? state.services : []
        return .init(
            state: .initial,
            services: services,
            currentDevice: action.device
        )
    case let action as DeviceChangeStateAction:
        var screenState: DeviceInfoState.State
        
        switch action.device.state{
        case .connected:
            screenState = .serviceLoading
        case .connecting, .disconnecting:
            screenState = .connection
        case .disconnected:
            screenState = .loaded
        default:
            screenState = state.state
        }
        return .init(
            state: screenState,
            services: state.services,
            currentDevice: action.device
        )
    case let action as ServicesFoundAction:
        return .init(
            state: .loaded,
            services: action.services,
            currentDevice: state.currentDevice
        )
    default:
        return state
    }
}
