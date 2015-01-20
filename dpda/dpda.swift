struct DPDA<StateT: Hashable, StackT: Equatable> {
    typealias ConfigT = Configuration<StateT, StackT>
    typealias RulebookT = Rulebook<StateT, StackT>

    var config: ConfigT?
    let accept: [StateT]
    let rulebook: RulebookT

    init(start: StateT, stack: Stack<StackT>, accept: [StateT], rulebook: RulebookT) {
        self.config = Configuration(state: start, stack: stack)
        self.accept = accept
        self.rulebook = rulebook
    }

    var accepting: Bool {
        return (config?.state).map { contains(self.accept, $0) } ?? false
    }

    private mutating func read(#character: Character) {
        let next = config.flatMap { config in
            self.rulebook.nextConfiguration(config, character)
        }
        config = next.flatMap {
            self.rulebook.followFreeMoves($0)
        }
    }

    mutating func read(string: String) {
        for (_, char) in enumerate(string) {
            read(character: char)
        }
    }
}

struct DPDADesign<StateT: Hashable, StackT: Equatable> {
    let start: StateT
    let bottom: StackT
    let accept: [StateT]
    let rulebook: Rulebook<StateT, StackT>

    func accepts(string: String) -> Bool {
        var dpda = DPDA(start: start, stack: Stack([bottom]), accept: accept, rulebook: rulebook)
        dpda.read(string)
        return dpda.accepting
    }
}
