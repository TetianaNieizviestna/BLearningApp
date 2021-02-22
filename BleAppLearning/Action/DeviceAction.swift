//
//  DeviceAction.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 22.02.2021.
//

import Foundation

struct DeviceConnectedAction: Action {
    let device: Device
}

struct DeviceDisconnectedAction: Action {
    let device: Device
}

struct DeviceFoundAction: Action {
    let device: Device
}

struct DeviceChangeStateAction:Action {
    let device: Device
}

struct MainFailureAction: Action {
    let error: String
}

struct BLEStateAction: Action {
    let name: String
}
