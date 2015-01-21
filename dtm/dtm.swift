import Set

extension Optional {
    func flatMap<U>(f: T -> U?) -> U? {
        switch self {
        case let .Some(t):
            return f(t)
        case .None:
            return .None
        }
    }
}

struct DTM<T: Hashable> {
    var current: Configuration<T>? = nil
    let start: Configuration<T>
    let accept: Set<T>
    let rulebook: Rulebook<T>

    init(start: T, tape: Tape, accept: Set<T>, rulebook: Rulebook<T>) {
        self.start = Configuration(state: start, tape: tape)
        self.accept = accept
        self.rulebook = rulebook
        restart()
    }

    var accepting: Bool {
        return (current?.state).map { s in self.accept.contains(s) } ?? false
    }

    mutating func step() {
        current = current.flatMap { c in self.rulebook.nextConfiguration(c) }
    }

    mutating func run() {
        while !accepting {
            step()
        }
    }

    mutating func restart() {
        let configPreservingTape = current.map { c in
            Configuration(state: self.start.state, tape: c.tape)
        } ?? start

        current = configPreservingTape
    }
}
