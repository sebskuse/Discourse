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
    
    private static var usableArguments: ArraySlice<String> {
        return allArguments.dropFirst()
    }

    static var verb: String? {
        return usableArguments.first
    }

    static var commandArguments: [String] {
        return Array(usableArguments.dropFirst())
    }
}
