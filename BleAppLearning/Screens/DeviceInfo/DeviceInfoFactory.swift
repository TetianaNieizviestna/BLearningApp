//
//  DeviceInfoFactory.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

extension DeviceInfoFactory {
    struct Output {
        let close: Command
        
        static let initial = Output(close: .nop)
    }
}

final class DeviceInfoFactory {
    private let store: Store<AppState>

    init(store: Store<AppState> = StoreLocator.shared) {
        self.store = store
    }
    
    func `default`(_ output: Output = .initial, device: Device) -> DeviceInfoViewController {
        let controller: DeviceInfoViewController = Storyboard.deviceInfo.instantiate()
        controller.modalPresentationStyle = .overFullScreen
        
        var disposable: Disposable?
        
        let endObserving = Command {
            disposable?.dispose()
        }
        
        let dispatcher = CommandWith { [weak store] in store?.dispatch($0) }
        let render = CommandWith<DeviceInfoViewController.Props> { [weak controller] props in
            controller?.render(props)
        }
 
        let presenter = DeviceInfoPresenter(
            render: render.dispatched(on: .main),
            dispatch: dispatcher,
            onService: CommandWith { service in
                // TODO: Open Service Info
//                output.serviceInfo.perform()
            },
            onClose: Command {
                output.close.perform()
            },
            endObserving: endObserving
        )
        let observer: (AppState) -> Void = {
            presenter.present(state: $0, device: device)
        }
        disposable = store.subscribe(observer: observer)
        return controller
    }

}
