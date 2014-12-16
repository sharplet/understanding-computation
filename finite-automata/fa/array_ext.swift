extension Array {
  func detect(pred: T -> Bool) -> T? {
    for i in self {
      if pred(i) {
        return i
      }
    }
    return nil
  }

  func select(pred: T -> Bool) -> [T] {
    return filter(pred)
  }
}
