//
//  CommandHandler.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import var Darwin.stdout
import Foundation

/// Manages a set of registered commands.
public class CommandHandler {
    private var commands: [Command] = []

    enum HandlerError: Error, LocalizedError {
        case unknownCommand(String?, String)

        var errorDescription: String? {
            switch self {
            case let .unknownCommand(verb, usage):
                let command = verb ?? "(None)"
                return "Unknown command `\(command)`. Available commands:\n\(usage)"
            }
        }
    }

    public init() {}

    /// Registers a new command with the handler.
    ///
    /// - Parameter command: The command to register.
    public func register(_ command: Command) {
        commands.append(command)
    }

    public func run() throws {
        var standardOutput: TextOutputStream = StandardOutput()
        try run(verb: CommandLine.verb, arguments: CommandLine.commandArguments, outputStream: &standardOutput)
    }

    /// Attempts to run a registered command for the specified `verb` and `arguments`.
    public func run(verb: String?, arguments: [String]?, outputStream: inout TextOutputStream) throws {
        guard let arguments = arguments?,
            let command = commands.first(where: { $0.verb == verb }) else {
            throw HandlerError.unknownCommand(verb, usage())
        }
        try command.populateArguments(from: Array(arguments))
        try command.run(outputStream: &outputStream)
    }

    private func usage() -> String {
        return "\(commands.map { "\($0.verb):\n\($0.description)\n\($0.usage)\n" }.joined(separator: "\n"))"
    }
}

private extension Command {
    var usage: String {
        return arguments.map { $0.usageDescription }.joined(separator: "\n")
    }
}

struct StandardOutput: TextOutputStream {
    let handle = FileHandle.standardOutput

    mutating func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        handle.write(data)
    }
}
