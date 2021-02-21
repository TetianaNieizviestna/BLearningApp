//
//  Functions.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

func undefined<T>(
    hint: String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> T {
    let message = hint.isEmpty ? "" : ": \(hint)"
    fatalError("undefined \(T.self)\(message)", file: file, line: line)
}

func cast<Value, Result>(_ value: Value) -> Result? {
    return value as? Result
}

func printInDebug(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}

func printDeinit<T>(_ type: T) {
    #if DEBUG
    print("Deinit " + typeString(type))
    #endif
}

func typeString<T>(_ value: T) -> String {
    return typeString(type(of: value))
}

func typeString<T>(_ type: T.Type) -> String {
    return String(describing: type)
}
