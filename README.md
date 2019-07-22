# Discourse 💬

Discourse is a zero dependency Command-line argument parser built in Swift, with Swift 5.1 property wrapper support built in.

There are three main concepts in Discourse - `Command`, `Argument` and `CommandHandler`.

## Command
A `Command` is a discrete piece of functionality within your command line application, identified by a `verb`. The protocol defines just two properties and a function:

```
public protocol Command {
    /// Returns the command verb, the method by which
    /// the command is accessed from the root tool.
    var verb: String { get }

    /// A description of what the command does.
    var description: String { get }

    /// Runs the given command, using the specified outputStream for output.
    ///
    /// - Parameters:
    ///   - outputStream: The output stream to write to for any output.
    func run(outputStream: inout TextOutputStream) throws
}
```

The provided `description` is used for discovery of available commands - running the root tool with no, or an invalid, verb outputs all available `Command`s and their arguments.

The `run` command runs the implementation of the `Command` after all of the arguments have been configured. Calling this is handled for you automatically by `CommandHandler`.

`Command`s define their arguments by declaring properties that conform to the `Argument` protocol. These are then automatically populated prior to the `Command` being run using reflection.

As an example, if you had a `user` application which allowed the user to change their name, you may have a class that conforms to the `Command` protocol, with its verb being `update`. Running `user update` would trigger the command, with arguments that follow the command.

## Argument
An `Argument` is a container for a piece of information consumed by the `Command`. `Argument`s can be optional or required, as defined by their protocol:

```
public protocol Argument {
    /// The usage description for this argument.
    var usage: String { get }

    /// Whether this argument is required for the `Command`
    /// to be invoked.
    var required: Bool { get }

    /// The primary name (or key) for the argument.
    /// Typically arguments are passed in the
    /// form `command --name value`.
    var name: String { get }

    /// Other aliases for this argument.
    /// Typically these incluse a shorthand
    /// version of `name`.
    var aliases: [String]? { get }
}
```

If required arguments are not provided, the whole set of `Argument`s for the command fail, and the execution halts before the `Command` runs.

It is assumed all arguments follow the format of "--`key` `value`", where `key` can either be the `Argument`s `name`, or one of it's `aliases`. As with `Command`, a `usage` string is provided for discovery of commands and arguments.

### Property Wrappers
For Swift 5.1, a set of property wrappers are provided as syntactic sugar, allowing `Arguments` to be declared as:

```
@RequiredArgument(name: "name", aliases: ["n"], usage: "The user's name")
var name: String
```

or:

```
@OptionalArgument(name: "nickname", usage: "The user's nickname")
var nickname: String?
```


## CommandHandler
The `CommandHandler` is a central store of `Command`s, with functionality to dispatch incoming arguments from the Swift `CommandLine` enum through to the appropriate `Command`. 

In your app you should create an instance of `CommandHandler`, register all of your `Commands` and invoke it:

```
let handler = CommandHandler()

handler.register(UserCommand())
handler.register(ServerCommand())
handler.register(TestCommand())
handler.register(AnotherCommand())

do {
    try handler.run()
} catch {
    print("\(error.localizedDescription)")
    exit(6)
}

```

Note that by default `CommandHandler` will output all messaging to `stdout`. If you would prefer to write this elsewhere, a `TextOutputStream` can be passed in.

## Example
Using the update user example from above, and using the provided Property Wrappers, an example of what a Command could look like is:

```
class UpdateUserCommand: Command {
    var verb: String = "update"

    var description: String = "Updates a user"

    @RequiredArgument(name: "id", usage: "The user's id")
    var id: String

    @RequiredArgument(name: "name", aliases: ["n"], usage: "The user's name")
    var name: String

    @OptionalArgument(name: "nickname", usage: "The user's nickname")
    var nickname: String?

    @RequiredArgument(name: "isAvailable", usage: "Whether the user is available")
    var isAvailable: Bool
    
    let userService: UserUpdateable

    func run(outputStream: inout TextOutputStream) throws {
        // Use a semaphore wait etc to wait for async response here.
        
        userService.updateUser(id, name: name, ...) { _ in
            // Handle response, signal the semaphore here. 
        }
    }
}
```