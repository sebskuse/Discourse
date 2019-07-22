@testable import Discourse
import XCTest

#if swift(>=5.1)

    final class ArgumentParsingTests: OutputStreamTestCase {
        var command: PrintNameCommand!

        override func setUp() {
            super.setUp()
            command = PrintNameCommand()
        }

        override func tearDown() {
            super.tearDown()
            command = nil
        }

        func testTheCommandsArgumentsCanBeParsed() {
            let argumentNames = command.arguments.map { $0.name }
            XCTAssertEqual(argumentNames, ["name", "nickname", "isAvailable"])
        }

        func testWhenAllArgumentsAreProvidedTheyAreParsedCorrectlyUsingTheirLongformNames() throws {
            try command.populateArguments(from: ["name", "Gregg", "nickname", "Tester", "isAvailable", "true"])
            var passedStream: TextOutputStream = stream
            try command.run(outputStream: &passedStream)
            XCTAssertEqual(stream.receivedWriteMessages[0], "Hi, my name is Gregg")
            XCTAssertEqual(stream.receivedWriteMessages[1], "My nickname is Tester")
            XCTAssertEqual(stream.receivedWriteMessages[2], "I am available")
        }

        func testAliasesCanBeParsed() throws {
            try command.populateArguments(from: ["n", "Gregg", "nickname", "Tester", "isAvailable", "true"])
            var passedStream: TextOutputStream = stream
            try command.run(outputStream: &passedStream)
            XCTAssertEqual(stream.receivedWriteMessages[0], "Hi, my name is Gregg")
        }

        func testWhenRequiredArgumentsAreOmittedParsingTheArgumentsThrows() {
            // swiftlint:disable:next line_length
            XCTAssertThrowsError(try command.populateArguments(from: ["nickname", "Tester", "isAvailable", "true"])) { err in
                guard let error = err as? ArgumentValueUpdateError else {
                    XCTFail("Did not get correct error type")
                    return
                }
                switch error {
                case let .argumentNotFound(string):
                    XCTAssertEqual(string, "name")
                }
            }
        }

        func testPassingATypeThatIsNotConvertibleReturnsAnAppropriateError() {
            XCTAssertThrowsError(try command.populateArguments(from: ["n", "Gregg", "isAvailable", "String"])) { err in
                guard let error = err as? InvalidArgumentError else {
                    XCTFail("Did not get correct error type")
                    return
                }
                XCTAssertEqual(error.errorDescription, "String does not represent a boolean")
            }
        }

        func testOptionalArgumentsNotBeingPresentStillAllowTheCommandToRun() throws {
            try command.populateArguments(from: ["n", "Gregg", "isAvailable", "true"])
            var passedStream: TextOutputStream = stream
            try command.run(outputStream: &passedStream)
            XCTAssertEqual(stream.receivedWriteMessages.count, 2)
        }
    }

    class PrintNameCommand: Command {
        var verb: String = "test"

        var description: String = "Runs a test"

        @RequiredArgument(name: "name", aliases: ["n"], usage: "The user's name")
        var name: String

        @OptionalArgument(name: "nickname", usage: "The user's nickname")
        var nickname: String?

        @OptionalArgument(name: "isAvailable", usage: "Whether the user is available")
        var isAvailable: Bool?

        func run(outputStream: inout TextOutputStream) throws {
            outputStream.write("Hi, my name is \(name)")
            if let nick = nickname {
                outputStream.write("My nickname is \(nick)")
            }
            outputStream.write("I am\(isAvailable == false ? " not" : "") available")
        }
    }

#endif
