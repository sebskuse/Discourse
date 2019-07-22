//
//  ManualArgumentTests.swift
//  DiscourseTests
//
//  Created by Seb Skuse on 22/07/2019.
//

import XCTest
@testable import Discourse

class ManualArgumentTests: XCTestCase {
    var command: TestManualCommand!
    var stream: MockTextOutputStream!
    
    override func setUp() {
        super.setUp()
        command = TestManualCommand()
        stream = MockTextOutputStream()
    }

    override func tearDown() {
        super.tearDown()
        command = nil
        stream = nil
    }

    func testAManualCommandCanBeParsed() throws {
        try command.populateArguments(from: ["testArg", "Testing"])
        var passedStream: TextOutputStream = stream
        try command.run(outputStream: &passedStream)
        XCTAssertEqual(stream.receivedWriteMessages.first, "Test argument is: Testing")
    }
}

class TestManualCommand: Command {
    var verb: String = "test-manual"
    
    var description: String = "Test manual command"
    
    let argument = TestArgument()
    
    func run(outputStream: inout TextOutputStream) throws {
        outputStream.write("Test argument is: \(argument.value ?? "")")
    }
}

class TestArgument: Argument {
    let name: String = "testArg"
    let usage: String = "Test usage description"
    let required: Bool = true
    
    private(set) var value: String?
    
    func updateValue(from argumentPairs: inout [String : String]) throws {
        let update: ArgumentUpdate<String> = try argumentValue(from: argumentPairs)
        value = update.value
    }
}
