typealias State = protocol<Equatable, Printable>

func flip<A, B>(a: A, b: B) -> (B, A) {
  return (b, a)
}

struct FARule<S: State>: DebugPrintable {
  typealias Transition = (char: Character, dest: S)

  let state: S
  let transition: Transition

  init(_ state: S, transition: Transition) {
    self.state = state
    self.transition = transition
  }

  func appliesTo(state: S, _ character: Character) -> Bool {
    return self.state == state && self.transition.char == character
  }

  func follow() -> S {
    return transition.dest
  }

  var debugDescription: String {
    return "<FARule \(state) --\(transition.char)--> \(transition.dest)>"
  }
}

extension Array {
  func detect(pred: T -> Bool) -> T? {
    for i in self {
      if pred(i) {
        return i
      }
    }
    return nil
  }
}

struct DFARulebook<S: State>: DebugPrintable {
  typealias Rules = [FARule<S>]

  let rules: Rules

  init(_ rules: Rules) {
    self.rules = rules
  }

  func next(state: S, _ character: Character) -> S? {
    return ruleFor(state, character)?.follow()
  }

  func ruleFor(state: S, _ character: Character) -> FARule<S>? {
    return rules.detect { rule in
      rule.appliesTo(state, character)
    }
  }

  var debugDescription: String {
    let ruleDescription = ",\n  ".join(rules.map { r in r.debugDescription })
    return "<DFARuleBook rules:(\n  \(ruleDescription)\n)>"
  }
}

extension Optional {
  func flatmap <U> (f: T -> U?) -> U? {
    switch self {
      case .Some(let s): return f(s)
      case .None:        return nil
    }
  }
}

struct DFA<S: State> {
  var current: S?
  let accept: [S]
  let rulebook: DFARulebook<S>

  mutating func read(#character: Character) {
    current = current.flatmap { current in
      self.rulebook.next(current, character)
    }
  }

  mutating func read(#string: String) {
    for char in string {
      read(character: char)
    }
  }

  var accepting: Bool? {
    return current.map { current in contains(self.accept, current) }
  }
}

struct DFADesign<S: State> {
  let start: S
  let accept: [S]
  let rulebook: DFARulebook<S>

  func accepts(string: String) -> Bool? {
    var dfa = DFA(current: start, accept: accept, rulebook: rulebook)
    dfa.read(string: string)
    return dfa.accepting
  }

  func test(string: String) -> String {
    if let result = accepts(string) {
      return "Accepts \"\(string)\"? \(result)"
    }
    else {
      return "Failed when testing \"\(string)\""
    }
  }

  func test(strings: String...) -> [String] {
    return strings.map { string in self.test(string) }
  }
}

let rulebook = DFARulebook([
  FARule(1, transition: ("a", 2)), FARule(1, transition: ("b", 1)),
  FARule(2, transition: ("a", 2)), FARule(2, transition: ("b", 3)),
  FARule(3, transition: ("a", 3)), FARule(3, transition: ("b", 3))
])

let design = DFADesign(start: 1, accept: [3], rulebook: rulebook)

debugPrintln(rulebook)
for result in design.test("a", "baa", "baba", "c") {
  println(result)
}
