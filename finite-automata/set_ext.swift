import Set

extension Set {
  func filter(pred: Element -> Bool) -> Set {
    return Set(Swift.filter(self, pred))
  }
}
