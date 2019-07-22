//
//  Command.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

public protocol Command {
    /// Returns the command verb, the method by which
    /// the command is accessed from the root tool.
    var verb: String { get }

    /// A description of what the command does.
    var description: String { get }

    /// Runs the given command with the user supplied arguments,
    /// and the command settings, if any.
    ///
    /// - Parameters:
    ///   - outputStream: The output stream to write to for any output.
    func run(outputStream: inout TextOutputStream) throws
}

public extension Command {
    /// All arguments present for this `Command`.
    var arguments: [Argument] {
        return Mirror(reflecting: self).children.compactMap { $0.value as? Argument }
    }

    /// Populates all `Command` arguments with arguments passed from the command line.
    /// - Parameter passedArguments: Arguments from the commandline.
    func populateArguments(from passedArguments: [String]) throws {
        var argumentPairs: [String: String] = [:]
        stride(from: 0, to: passedArguments.count - 1, by: 2).forEach {
            argumentPairs[passedArguments[$0]] = passedArguments[$0 + 1].escapedCommandLineString
        }

        try arguments.forEach { commandArg in
            try commandArg.updateValue(from: &argumentPairs)
        }
    }
}

extension String {
    var commandLineRepresentation: String {
        return "--\(self)"
    }

    var escapedCommandLineString: String {
        return trimmingCharacters(in: CharacterSet(["-"]))
    }
}
