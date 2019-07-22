//
//  Argument+Update.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

public struct ArgumentUpdate<T: ArgumentStringConvertible> {
    public let name: String
    public let value: T

    public init(name: String, value: T) {
        self.name = name
        self.value = value
    }
}

public extension Argument {
    /// Produces an `ArgumentUpdate`, representing a potential update to
    /// and `Argument`s value based on new values coming from `pairs`.
    /// - Parameter pairs: A dictionary of new arguments
    /// An error will be thrown if the argument type fails to parse, or if
    /// there is no argument present.
    func argumentValue<T: ArgumentStringConvertible>(from pairs: [String: String]) throws -> ArgumentUpdate<T> {
        if let valueUsingPrimaryKey = pairs[name] {
            return ArgumentUpdate(name: name, value: try T.parse(argumentString: valueUsingPrimaryKey))
        }
        if let secondaryKeys = aliases,
            let firstValidAlias = secondaryKeys.first(where: { pairs[$0] != nil }),
            let value = pairs[firstValidAlias] {
            return ArgumentUpdate(name: firstValidAlias, value: try T.parse(argumentString: value))
        }

        throw ArgumentValueUpdateError.argumentNotFound(name)
    }
}
