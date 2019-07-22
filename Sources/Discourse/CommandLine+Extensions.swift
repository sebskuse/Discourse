//
//  CommandLine+Extensions.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

extension CommandLine {
    private static var allArguments: ArraySlice<String> {
        return arguments[CommandLine.arguments.indices]
    }

    static var verb: String? {
        return allArguments.dropFirst().first
    }

    static var commandArguments: [String] {
        return Array(allArguments[1...])
    }
}
