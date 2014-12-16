// MARK: Pattern protocol

protocol PatternType: Printable {
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
}
