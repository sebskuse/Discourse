//
//  ManualArgumentTests.swift
//  DiscourseTests
//
//  Created by Seb Skuse on 22/07/2019.
//

@testable import Discourse
import XCTest

class ManualArgumentTests: OutputStreamTestCase {
    var command: TestManualCommand!

    override func setUp() {
        super.setUp()
        command = TestManualCommand()
    }

    override func tearDown() {
        super.tearDown()
        command = nil
    }

    func testAManualCommandCanBeParsed() throws {
        try command.populateArguments(from: ["testArg", "NotTesting"])
        var passedStream: TextOutputStream = stream
        try command.run(outputStream: &passedStream)
        XCTAssertEqual(stream.receivedWriteMessages.first, "Test argument is: Testing")
    }
}

class TestManualCommand: Command {
    let verb: String = "test-manual"

    let description: String = "Test manual command"

    let argument = TestArgument(name: "testArg")

    func run(outputStream: inout TextOutputStream) throws {
        outputStream.write("Test argument is: \(argument.value ?? "")")
    }
}

class TestArgument: Argument {
    let name: String
    let usage: String = "Test usage description"
    let required: Bool = true
    let aliases: [String]?

    private(set) var value: String?

    func updateValue(from argumentPairs: inout [String: String]) throws {
        let update: ArgumentUpdate<String> = try argumentValue(from: argumentPairs)
        value = update.value
    }

    init(name: String, aliases: [String]? = nil) {
        self.name = name
        self.aliases = aliases
    }
}
