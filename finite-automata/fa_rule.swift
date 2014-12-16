typealias State = protocol<Hashable, Printable>

struct FARule<S: State>: Printable, Hashable {
  typealias Transition = (char: Character?, dest: S)

  let state: S
  let transition: Transition

  init(_ state: S, transition: Transition) {
    self.state = state
    self.transition = transition
  }

  func appliesTo(state: S, _ character: Character?) -> Bool {
    switch (transition.char, character) {
    case (.Some(let thisChar), .Some(let otherChar)):
      return self.state == state && thisChar == otherChar
    case (.None, .None):
      return self.state == state
    default:
      return false
    }
  }

  func follow() -> S {
    return transition.dest
  }

  var description: String {
    return "<FARule \(state) --\(charDescription)--> \(transition.dest)>"
  }

  var hashValue: Int {
    return state.hashValue ^ charHashValue ^ transition.dest.hashValue
  }

  // MARK: Private

  private var charDescription: Character {
    return transition.char ?? "*"
  }

  private var charHashValue: Int {
    return transition.char?.hashValue ?? 0
  }
}

func == <S: State> (lhs: FARule<S>, rhs: FARule<S>) -> Bool {
  return lhs.state == rhs.state
      && lhs.transition.char == rhs.transition.char
      && lhs.transition.dest == rhs.transition.dest
}
