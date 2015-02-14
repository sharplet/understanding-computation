extension Set {
  func filter(pred: Element -> Bool) -> Set {
    return Set(Swift.filter(self, pred))
  }

  func map<U>(f: T -> U) -> Set<U> {
    return flatMap { [f($0)] }
  }

  func flatMap<U>(f: T -> Set<U>) -> Set<U> {
    return reduce(self, Set<U>()) { $0.union(f($1)) }
  }
}
