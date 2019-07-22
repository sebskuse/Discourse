//
//  ArgumentStringConvertible.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

/// A type that can be converted to from a command line argument.
public protocol ArgumentStringConvertible {
    /// Parses the given argument value string to `Self`.
    static func parse(argumentString: String) throws -> Self
}

// MARK: Implementations

extension String: ArgumentStringConvertible {
    public static func parse(argumentString: String) throws -> String {
        return argumentString
    }
}

extension URL: ArgumentStringConvertible {
    public static func parse(argumentString: String) throws -> URL {
        return URL(fileURLWithPath: argumentString).standardizedFileURL
    }
}

extension Bool: ArgumentStringConvertible {
    public static func parse(argumentString: String) throws -> Bool {
        guard let result = Bool(argumentString) else {
            throw InvalidArgumentError(message: "\(argumentString) does not represent a boolean")
        }
        return result
    }
}

extension Optional where Wrapped: ArgumentStringConvertible {
    public static func parse(argumentString: String) throws -> Wrapped {
        return try Wrapped.parse(argumentString: argumentString)
    }
}

struct InvalidArgumentError: LocalizedError {
    let message: String

    var errorDescription: String? {
        return message
    }
}
