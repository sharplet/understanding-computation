enum EventSource: NilLiteralConvertible, UnicodeScalarLiteralConvertible, Printable, Hashable {
  case Char(Character)
  case Free

  typealias UnicodeScalarLiteralType = Character

  init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self = .Char(value)
  }

  init(nilLiteral: ()) {
    self = .Free
  }

  var description: String {
    switch self {
    case .Char(let c):
      return String(c)
    case .Free:
      return "*"
    }
  }

  var hashValue: Int {
    switch self {
    case .Char(let c):
      return c.hashValue
    case .Free:
      return 0
    }
  }
}

func ==(lhs: EventSource, rhs: EventSource) -> Bool {
  switch (lhs, rhs) {
  case (.Free, .Free):
    return true
  case (.Char(let a), .Char(let b)):
    return a == b
  default:
    return false
  }
}
