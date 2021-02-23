//
//  DeviceInfoPresenter.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

struct DeviceInfoPresenter {
    typealias Props = DeviceInfoViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let onService: CommandWith<BTService>
    let onClose: Command
    let endObserving: Command
    
    func present(state: AppState, device: Device) {
        render.perform(
            with: .init(
                state:  getState(state),
                bleManager: state.bleState.manager,
                device: device,
                title: device.name ?? "no name",
                items: getItems(state),
                services: getServices(state),
                changeBleStatus: CommandWith { status in
                    dispatch.perform(with: BLEStateAction(name: status))
                },
                changeState: CommandWith { device in
                    dispatch.perform(with: DeviceChangeStateAction(device: device))
                },
                servicesFound: CommandWith { services in
                    dispatch.perform(with: ServicesFoundAction(services: services))
                },
                onClose: onClose,
                onDestroy: endObserving
            )
        )
    }
    
    private func getServices(_ state: AppState) -> [BTService] {
        return state.deviceInfo.services
    }
    
    private func getItems(_ state: AppState) -> [ServiceTableViewCell.Props] {
        let services = state.deviceInfo.services
        return services.map { getItem($0) }
    }
    
    private func getItem(_ service: BTService) -> ServiceTableViewCell.Props {
        let included = service.includedServices.map { "\($0.description)\n" } ?? ""
        let str = "\(included)"
        return ServiceTableViewCell.Props(
            title: "\(service.uuid)",
            id: "\(str)",
            onSelect: Command {
                self.onService.perform(with: service)
            }
        )
    }
    
    private func getState(_ state: AppState) -> Props.State {
        switch state.deviceInfo.state {
        case .initial:
            return .initial
        case .loading:
            return .loading
        case .failure(let error):
            return .failure(error)
        }
    }
}
