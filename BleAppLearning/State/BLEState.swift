//
//  BLEState.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 23.02.2021.
//

import Foundation
import CoreBluetooth

struct BLEState: Equatable {
    static let initial = BLEState(
        manager: CBCentralManager(),
        bleState: ""
    )
    
    var manager: CBCentralManager
    var bleState: String
    
    init(manager: CBCentralManager, bleState: String) {
        self.manager = manager
        self.bleState = bleState
    }
}

func reduce(_ state: BLEState, _ action: Action) -> BLEState {
    switch action {
    case is BLEManagerInit:
        return .init(
            manager: CBCentralManager(),
            bleState: ""
        )
    case let action as BLEStateAction:
        return .init(
            manager: state.manager,
            bleState: action.name
        )
    default:
        return state
    }
}

struct BLEManagerInit: Action {}
