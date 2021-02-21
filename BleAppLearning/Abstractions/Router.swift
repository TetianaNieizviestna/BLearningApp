//
//  Router.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

protocol Router {
    associatedtype Route
    func route(to: Route)
}
