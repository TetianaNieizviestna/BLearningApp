//
//  MainFactory.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import UIKit

extension MainFactory {
    struct Output {
        let onDevice: CommandWith<Device>
        
        static let initial = Output(onDevice: .nop)
    }
}

final class MainFactory {
    private let store: Store<AppState>
    
    init(store: Store<AppState> = StoreLocator.shared) {
        self.store = store
    }
    
    func `default`(_ output: Output = .initial)
        -> MainViewController {
            let controller: MainViewController = Storyboard.main.instantiate()
            
            var disposable: Disposable?
            let endObserving = Command { disposable?.dispose() }
            let dispatcher = CommandWith { [weak store] in store?.dispatch($0) }
            let render = CommandWith { [weak controller] props in
                controller?.render(props)
            }
            
            let presenter = MainPresenter(
                render: render.dispatched(on: .main),
                dispatch: dispatcher,
                onDevice: CommandWith { device in
                    output.onDevice.perform(with: device)
                },
                endObserving: endObserving
            )
            
            let observer: (AppState) -> Void = { state in
                presenter.present(state: state)
            }
            disposable = store.subscribeUnique(observer: observer)
            return controller
    }
    
    deinit {
        printDeinit(self)
    }
}
