// MARK: Pattern protocol

protocol NFAConvertible {
  func toNFADesign() -> NFADesign<NFAState>
}

protocol PatternType: Printable, NFAConvertible {
  var precedence: Int { get }
  func bracket<Outer: PatternType>(outer: Outer) -> String
}

func bracket<Inner: PatternType, Outer: PatternType>(inner: Inner, outer: Outer) -> String {
  if inner.precedence < outer.precedence {
    return "(\(inner))"
  }
  else {
    return inner.description
  }
}


// MARK: Patterns

struct Empty: PatternType {
  let precedence = 3
  let description = ""

  init() {}

  func bracket<Outer: PatternType>(outer: Outer) -> String {
    return main.bracket(self, outer)
  }

  func toNFADesign() -> NFADesign<NFAState> {
    let start = NFAState()
    let accept = start
    let rulebook = NFARulebook(Set<FARule<NFAState>>())
    return NFADesign(start: start, accept: [accept], rulebook: rulebook)
  }
}

struct Literal: PatternType {
  let character: Character
  let precedence = 3

  init(_ character: Character) {
    self.character = character
  }

  var description: String {
    return String(character)
  }

  func bracket<Outer: PatternType>(outer: Outer) -> String {
    return main.bracket(self, outer)
  }

  func toNFADesign() -> NFADesign<NFAState> {
    let start = NFAState()
    let accept = NFAState()
    let rule = FARule(start, transition: (EventSource.Char(character), accept))
    let rulebook = NFARulebook([rule])
    return NFADesign(start: start, accept: [accept], rulebook: rulebook)
  }
}

struct Concatenate<Left: PatternType, Right: PatternType>: PatternType {
  let left: Left
  let right: Right
  let precedence = 1

  init(_ left: Left, _ right: Right) {
    self.left = left
    self.right = right
  }

  var description: String {
    let descriptions = patterns.map { pattern in pattern.bracket(self) }
    return "".join(descriptions)
  }

  func bracket<Outer: PatternType>(outer: Outer) -> String {
    return main.bracket(self, outer)
  }

  func toNFADesign() -> NFADesign<NFAState> {
    let leftDesign = left.toNFADesign()
    let rightDesign = right.toNFADesign()

    let start = leftDesign.start
    let accept = rightDesign.accept
    let rules = leftDesign.rulebook.rules.union(rightDesign.rulebook.rules)
    let joiningRules = leftDesign.accept.map { acceptState in
      FARule(acceptState, transition: (nil, rightDesign.start))
    }
    let rulebook = NFARulebook(rules.union(joiningRules))

    return NFADesign(start: start, accept: accept, rulebook: rulebook)
  }

  // MARK: Private

  private var patterns: [PatternType] {
    return [left, right]
  }
}

struct Choose<Left: PatternType, Right: PatternType>: PatternType {
  let left: Left
  let right: Right
  let precedence = 0

  init(_ left: Left, _ right: Right) {
    self.left = left
    self.right = right
  }

  var description: String {
    let descriptions = patterns.map { pattern in pattern.bracket(self) }
    return "|".join(descriptions)
  }

  func bracket<Outer: PatternType>(outer: Outer) -> String {
    return main.bracket(self, outer)
  }

  func toNFADesign() -> NFADesign<NFAState> {
    let leftDesign = left.toNFADesign()
    let rightDesign = right.toNFADesign()

    let start = NFAState()
    let accept = leftDesign.accept + rightDesign.accept
    let rules = leftDesign.rulebook.rules.union(rightDesign.rulebook.rules)
    let joiningRules = [leftDesign, rightDesign].map { design in
      FARule(start, transition: (nil, design.start))
    }
    let rulebook = NFARulebook(rules.union(joiningRules))

    return NFADesign(start: start, accept: accept, rulebook: rulebook)
  }

  // MARK: Private

  private var patterns: [PatternType] {
    return [left, right]
  }
}

struct Repeat<Repeated: PatternType>: PatternType {
  let pattern: Repeated
  let precedence = 2

  init(_ pattern: Repeated) {
    self.pattern = pattern
  }

  var description: String {
    return "\(pattern.bracket(self))*"
  }

  func bracket<Outer: PatternType>(outer: Outer) -> String {
    return main.bracket(self, outer)
  }

  func toNFADesign() -> NFADesign<NFAState> {
    let design = pattern.toNFADesign()

    let start = NFAState()
    let accept = design.accept + [start]
    let joiningRules = accept.map { accept in
      FARule(accept, transition: (nil, design.start))
    }
    let rulebook = NFARulebook(design.rulebook.rules.union(joiningRules))

    return NFADesign(start: start, accept: accept, rulebook: rulebook)
  }
}
