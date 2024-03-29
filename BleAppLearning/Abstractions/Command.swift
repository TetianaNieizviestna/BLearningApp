//
//  Command.swift
//  BleAppLearning
//
//  Created by Tetiana Nieizviestna on 21.02.2021.
//

import Foundation

final class Command {
    static let nop = Command {}
    private let file: StaticString
    private let function: StaticString
    private let line: Int
    private let id: String
    private let action: () -> Void

    init(
        id: String = "unnamed",
        file: StaticString = #file,
        function: StaticString = #function,
        line: Int = #line,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.action = action
        self.function = function
        self.file = file
        self.line = line
    }
    
    func dispatched(on queue: DispatchQueue) -> Command {
        return Command {
            queue.async {
                self.perform()
            }
        }
    }
    
    func perform() {
        action()
    }
    
    /// Support for Xcode quick look feature.
    @objc
    func debugQuickLookObject() -> AnyObject? {
        return """
            type: \(String(describing: type(of: self)))
            id: \(id)
            file: \(file)
            function: \(function)
            line: \(line)
            """ as NSString
    }
}

extension Command: Equatable {
    static func == (lhs: Command, rhs: Command) -> Bool {
        return true
    }
}

extension Command: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init { }
    }
    
    func encode(to encoder: Encoder) throws {}
}

final class CommandWith<T> {
    static var nop: CommandWith {
        return CommandWith { _ in }
    }
    let action: (T) -> Void
    
    init(action: @escaping (T) -> Void) {
        self.action = action
    }
    
    func perform(with value: T) {
        action(value)
    }
    
    func bind(to value: T) -> Command {
        return Command { self.perform(with: value) }
    }
    
    func dispatched(on queue: DispatchQueue) -> CommandWith {
        return CommandWith { value in
            queue.async {
                self.perform(with: value)
            }
        }
    }
    
    func then(_ another: CommandWith) -> CommandWith {
        return CommandWith { value in
            self.perform(with: value)
            another.perform(with: value)
        }
    }
}

extension CommandWith: Equatable {
    static func == (lhs: CommandWith<T>, rhs: CommandWith<T>) -> Bool {
        return true
    }
}

extension CommandWith: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
}

extension CommandWith: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init { _ in }
    }
    
    func encode(to encoder: Encoder) throws {}
}

extension CommandWith {
    func map<U>(transform: @escaping (U) -> T) -> CommandWith<U> {
        return CommandWith<U> { u in
            self.perform(with: transform(u))
        }
    }
}
