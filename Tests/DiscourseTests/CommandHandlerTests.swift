//
//  CommandHandlerTests.swift
//  DiscourseTests
//
//  Created by Seb Skuse on 22/07/2019.
//

@testable import Discourse
import XCTest

class CommandHandlerTests: OutputStreamTestCase {
    var handler: CommandHandler!

    override func setUp() {
        handler = CommandHandler()
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        handler = nil
    }

    func testWhenThereIsNoHandlerRegisteredForAGivenVerbAnAppropriateErrorMessageIsReturned() {
        handler.register(TestCommand(verb: "test1"))
        handler.register(TestCommand(verb: "test2"))

        var passedStream: TextOutputStream = stream
        do {
            try handler.run(verb: "Test", arguments: [], outputStream: &passedStream)
            XCTFail("Handling an invalid command should raise an error")
        } catch {
            guard let err = error as? CommandHandler.HandlerError,
                let errorMessage = err.errorDescription else {
                return XCTFail("Did not get a handler error")
            }

            let expectedMessage = """
            Unknown command `Test`. Available commands:
            test1:
            Test manual command
            --arg1, --a1\t\t(Required) Test usage description
            --arg2\t\t(Required) Test usage description

            test2:
            Test manual command
            --arg1, --a1\t\t(Required) Test usage description
            --arg2\t\t(Required) Test usage description

            """

            XCTAssertEqual(errorMessage, expectedMessage)
        }
    }

    func testWhenThereIsAHandlerRegisteredButTheArgumentsAreInvalidAnErrorIsReturned() {
        handler.register(TestCommand(verb: "test1"))
        var passedStream: TextOutputStream = stream
        do {
            try handler.run(verb: "test1", arguments: [], outputStream: &passedStream)
            XCTFail("Handling an invalid command should raise an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Argument not found for arg1")
        }
    }
}

private class TestCommand: Command {
    let verb: String

    var description: String = "Test manual command"

    let arg1 = TestArgument(name: "arg1", aliases: ["a1"])
    let arg2 = TestArgument(name: "arg2")

    func run(outputStream: inout TextOutputStream) throws {
        outputStream.write("Test argument1 is: \(arg1.value ?? "")")
        outputStream.write("Test argument2 is: \(arg2.value ?? "")")
    }

    init(verb: String) {
        self.verb = verb
    }
}
