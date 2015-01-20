struct Tape: Printable {
    var left: [Character]
    var middle: Character
    var right: [Character]
    let blank: Character

    init(_ left: [Character], _ middle: Character, _ right: [Character], _ blank: Character) {
        self.left = left
        self.middle = middle
        self.right = right
        self.blank = blank
    }

    mutating func write(char: Character) {
        middle = char
    }

    mutating func moveLeft() {
        right.append(middle)
        middle = left.last.map { _ in self.left.removeLast() } ?? blank
    }

    mutating func moveRight() {
        left.append(middle)
        middle = right.last.map { _ in self.right.removeLast() } ?? blank
    }

    var description: String {
        let l = "".join(left.map(toString))
        let r = "".join(lazy(right).reverse().map(toString))
        let m = toString(middle)
        return "<Tape \(l)(\(m))\(r)>"
    }
}
