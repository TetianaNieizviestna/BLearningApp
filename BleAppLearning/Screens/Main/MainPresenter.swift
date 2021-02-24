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
                bleManager: state.state.manager,
                status: getStatus(state),
                items: getItems(state),
                devices: state.main.devices,
                scanAction: Command {
                    if state.main.state == .scanning {
                        dispatch.perform(with: ScanStopAction())
                    } else {
                        dispatch.perform(with: ScanStartAction())
                    }
                },
                foundDevice: CommandWith { device in
                    dispatch.perform(with: DeviceFoundAction(device: device))
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
        switch state.main.state {
        case .initial:
            return .initial
        case .scanning:
            return .scanning
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func getStatus(_ state: AppState) -> String {
        return "Bluetooth: \(state.state.bleState)"
    }
    
    private func getItems(_ state: AppState) -> [DeviceTableViewCell.Props] {
        let devices = state.main.devices
        return devices.map { getItem(from: $0) }
    }
    
    private func getItem(from device: Device) -> DeviceTableViewCell.Props {
        return .init(
            title: device.name ?? "",
            id: "\(device.identifier)",
            state: device.state,
            onSelect: Command {
                dispatch.perform(with: ScanStopAction())
                self.onDevice.perform(with: device)
            }
        )
    }
}
