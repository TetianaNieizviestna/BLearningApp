//
//  MainPresenter.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation
struct MainPresenter {
    typealias Props = MainViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let onDevice: CommandWith<Device>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: .init(
                state: getState(state),
                status: getStatus(state),
                items: getItems(state),
                devices: state.main.devices,
                connectedDevices: state.main.connectedDevices,
                currentDevice: state.main.currentDevice,
                foundDevice: CommandWith { device in
                    dispatch.perform(with: DeviceFoundAction(device: device))
                },
                connectDevice: CommandWith { device in
                    dispatch.perform(with: DeviceConnectedAction(device: device))
                },
                disconnectDevice: CommandWith { device in
                    dispatch.perform(with: DeviceDisconnectedAction(device: device))
                },
                changeState: CommandWith { device in
                    dispatch.perform(with: DeviceChangeStateAction(device: device))
                },
                changeBleStatus: CommandWith { status in
                    dispatch.perform(with: BLEStateAction(name: status))
                },
                onDestroy: endObserving
            )
        )
    }
    
    private func getState(_ state: AppState) -> Props.State {
        return .initial
    }
    
    private func getStatus(_ state: AppState) -> String {
        return "Bluetooth: \(state.main.bleState)"
    }
    
    private func getItems(_ state: AppState) -> [DeviceTableViewCell.Props] {
        let devices = state.main.devices
        let props = devices.map { getItem(from: $0) }
        return props
    }
    
    private func getItem(from device: Device) -> DeviceTableViewCell.Props {
        return .init(
            title: device.name ?? "",
            id: "\(device.identifier)",
            state: device.state,
            onSelect: Command {
                self.onDevice.perform(with: device)
            }
        )
    }
}
