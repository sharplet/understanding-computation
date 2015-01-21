struct Rule<T: Equatable> {
    let state: T
    let character: Character
    let next: T
    let toWrite: Character
    let direction: Tape.Direction

    func appliesTo(configuration: Configuration<T>) -> Bool {
        return state == configuration.state && character == configuration.tape.middle
    }

    func follow(configuration: Configuration<T>) -> Configuration<T> {
        return Configuration(state: next, tape: nextTape(configuration))
    }

    func nextTape(configuration: Configuration<T>) -> Tape {
        var tape = configuration.tape
        tape.write(toWrite)
        tape.moveHead(direction)
        return tape
    }
}
