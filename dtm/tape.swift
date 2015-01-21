struct Tape: Printable {
    enum Direction {
        case Left
        case Right
    }

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

    mutating func move(direction: Direction) {
        switch direction {
        case .Left:
            shiftCharacter(from: &left, to: &right)
        case .Right:
            shiftCharacter(from: &right, to: &left)
        }
    }

    private mutating func shiftCharacter(inout #from: [Character], inout to: [Character]) {
        to.append(middle)
        middle = from.last.map { _ in from.removeLast() } ?? blank
    }

    var description: String {
        let l = "".join(left.map(toString))
        let r = "".join(lazy(right).reverse().map(toString))
        let m = toString(middle)
        return "<Tape \(l)(\(m))\(r)>"
    }
}
