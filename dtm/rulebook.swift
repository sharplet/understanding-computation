extension LazySequence {
    var first: S.Generator.Element? {
        for i in self {
            return i
        }
        return nil
    }
}

struct Rulebook<T: Equatable> {
    let rules: [Rule<T>]

    init(_ rules: [Rule<T>]) {
        self.rules = rules
    }

    func nextConfiguration(configuration: Configuration<T>) -> Configuration<T>? {
        return ruleFor(configuration)?.follow(configuration)
    }

    func ruleFor(configuration: Configuration<T>) -> Rule<T>? {
        return lazy(rules).filter { rule in rule.appliesTo(configuration) }.first
    }
}
