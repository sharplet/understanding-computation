struct Configuration<StateT, StackT>: Printable {
    static func describe(config: Configuration?) -> String {
        return config.map { $0.description } ?? "(failed)"
    }

    let state: StateT
    let stack: Stack<StackT>
    var description: String { return "(\(state),\(stack))" }
}

struct Rule<StateT: Equatable, StackT: Equatable>: Printable {
    typealias ConfigT = Configuration<StateT, StackT>

    let state: StateT
    let character: Character?
    let next: StateT
    let toPop: StackT
    let toPush: [StackT]

    func appliesTo(config: ConfigT, _ char: Character?) -> Bool {
        return state == config.state
            && toPop == config.stack.top
            && character == char
    }

    func follow(config: ConfigT) -> ConfigT {
        return Configuration(state: next, stack: nextStack(config.stack))
    }

    private func nextStack(var stack: Stack<StackT>) -> Stack<StackT> {
        stack.pop()
        for char in toPush.reverse() {
            stack.push(char)
        }
        return stack
    }

    var description: String {
        return "(state=\(state), character=\(character), next=\(next), toPop=\(toPop), toPush=\(toPush))"
    }
}

struct Rulebook<StateT: Equatable, StackT: Equatable> {
    typealias ConfigT = Configuration<StateT, StackT>
    typealias RuleT = Rule<StateT, StackT>

    let rules: [RuleT]

    func nextConfiguration(config: ConfigT, _ char: Character?) -> ConfigT? {
        return ruleFor(config, char)?.follow(config)
    }

    func ruleFor(config: ConfigT, _ char: Character?) -> RuleT? {
        return rules.filter { rule in rule.appliesTo(config, char) }.first
    }

    func followFreeMoves(config: ConfigT) -> ConfigT? {
        if appliesTo(config, nil) {
            return nextConfiguration(config, nil).flatMap { self.followFreeMoves($0) }
        }
        else {
            return config
        }
    }

    private func appliesTo(config: ConfigT, _ char: Character?) -> Bool {
        return ruleFor(config, char) != nil
    }
}
