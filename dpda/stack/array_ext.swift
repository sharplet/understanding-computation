/// Array utilities.
extension Array {
    /// Create an array from an optional: .Some(t) = [t], .None = []
    static func fromOptional(t: T?) -> Array {
        return t.map { [$0] } ?? []
    }
}
