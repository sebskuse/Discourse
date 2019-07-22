//
//  ArgumentWrapper.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

enum ArgumentValueUpdateError: Error {
    case argumentNotFound
}

#if swift(>=5.1)

@propertyWrapper
public class RequiredArgument<T: ArgumentStringConvertible>: Argument {
    public let name: String
    public let aliases: [String]?
    
    public let required: Bool = true
    
    public let usage: String
    
    public var wrappedValue: T {
        guard let value = underlyingValue else {
            preconditionFailure("Argument has not been parsed from a required argument.")
        }
        return value
    }
    
    private var underlyingValue: T?

    init(name: String, aliases: [String]? = nil, defaultValue: T? = nil, usage: String) {
        self.name = name
        self.aliases = aliases
        self.usage = usage
        underlyingValue = defaultValue
    }
    
    public func updateValue(from argumentPairs: inout [String: String]) throws {
        let update: ArgumentUpdate<T> = try argumentValue(from: argumentPairs)
        underlyingValue = update.value
        argumentPairs.removeValue(forKey: update.name)
    }
}

@propertyWrapper
public class OptionalArgument<T: ArgumentStringConvertible>: Argument {
    public let name: String
    public let aliases: [String]?
    
    public let required: Bool = false
    
    public let usage: String
    
    public var wrappedValue: T?

    init(name: String, aliases: [String]? = nil, defaultValue: T? = nil, usage: String) {
        self.name = name
        self.aliases = aliases
        self.usage = usage
        wrappedValue = defaultValue
    }
    
    public func updateValue(from argumentPairs: inout [String: String]) throws {
        do {
            let update: ArgumentUpdate<T> = try argumentValue(from: argumentPairs)
            wrappedValue = update.value
            argumentPairs.removeValue(forKey: update.name)
        } catch ArgumentValueUpdateError.argumentNotFound {
            return
        } catch {
            throw error
        }
    }
}

#endif
