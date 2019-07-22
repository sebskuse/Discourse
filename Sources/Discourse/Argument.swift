//
//  Argument.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

public protocol Argument {
    /// The usage description for this argument.
    var usage: String { get }

    /// Whether this argument is required for the `Command`
    /// to be invoked.
    var required: Bool { get }

    /// The primary name (or key) for the argument.
    /// Typically arguments are passed in the
    /// form `command --name value`.
    var name: String { get }

    /// Other aliases for this argument.
    /// Typically these incluse a shorthand
    /// version of `name`.
    var aliases: [String]? { get }
}

public extension Argument {
    /// Updates the argument's value.
    /// - Parameter argumentPairs: The full list of argument pairs.
    ///   Will throw if the value is not found.
    /// Once an argument pair has been consumed by an `Argument`, it should
    /// be removed from `argumentPairs`.
    func updateValue(from argumentPairs: inout [String: String]) throws
}

public extension Argument {
    var aliases: [String]? { return nil }
}

public extension Argument {
    var usageDescription: String {
        let required = self.required ? "(Required)" : "(Optional)"
        var arguments: [String] = [name]
        if let aliases = aliases {
            arguments.append(contentsOf: aliases)
        }

        let names = arguments.map { $0.commandLineRepresentation }.joined(separator: ", ")

        return "\(names)\t\t\(required) \(usage)"
    }
}
