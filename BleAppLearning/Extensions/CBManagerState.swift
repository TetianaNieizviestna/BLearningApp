//
//  CBManagerState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import CoreBluetooth

extension CBManagerState {
    var name: String {
        switch self {
        case .poweredOn:
            return "ON"
        case .resetting:
            return "RESET"
        case .unknown:
            return "UNKNOWN"
        case .unsupported:
            return "UNSUPPORTED"
        case .unauthorized:
            return "UNAUTHORIZED"
        case .poweredOff:
            return "OFF"
        @unknown default:
            return "UNKNOWN DEFAULT"
        }
    }
}

extension CBPeripheralState {
    var name: String {
        switch self {
        case .connected:
            return "CONNECTED"
        case .connecting:
            return "CONNECTING"
        case .disconnected:
            return "DISCONNECTED"
        case .disconnecting:
            return "DISCONNECTING"
        @unknown default:
            return "UNKNOWN DEFAULT"
        }
    }
}
