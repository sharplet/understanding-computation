extension Optional {
    func flatMap<U>(f: T -> U?) -> U? {
        if let u = map(f) {
            return u
        }
        else {
            return nil
        }
    }
}
