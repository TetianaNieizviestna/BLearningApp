//
//  DeviceAction.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 22.02.2021.
//

import Foundation

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

struct ScanStartAction: Action {}
struct ScanStopAction: Action {}

struct ServicesFoundAction: Action {
    let services: [BTService]
}

struct ConnectionStartAction: Action {}
struct ConnectionStopAcrtion: Action {}
