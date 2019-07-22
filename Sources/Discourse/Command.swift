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
