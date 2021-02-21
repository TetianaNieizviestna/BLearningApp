//
//  Printer.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

class Printer {
    static func printData(_ data: Data?) {
        if let data = data {
            let dataStr = String(decoding: data, as: UTF8.self)
            print("[DATA]: \(dataStr)")
        }
    }
}
