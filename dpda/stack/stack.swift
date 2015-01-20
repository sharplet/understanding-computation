/// An immutable stack with operations in the State monad.
public struct Stack<T>: Printable, ArrayLiteralConvertible {
    // MARK: Initialisers

    public init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
        self.values = Array(sequence)
    }

    public init() {
        self.init([])
    }


    // MARK: ArrayLiteralConvertible

    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }


    // MARK: Operations

    mutating func push(x: T) {
        values.append(x)
    }

    mutating func pop() -> T? {
        if let top = self.top {
            return values.removeLast()
        }
        else {
            return nil
        }
    }


    // MARK: Properties

    public var top: T? {
        return values.last
    }

    public var count: Int {
        return values.count
    }


    // MARK: Printable

    public var description: String {
        let front = top.map { ["(\($0))"] }
        let back = tail.map(toString)
        let full = front.map { front in "".join(front + back) }
        let contents = full ?? "empty"
        return "<Stack:\(contents)>"
    }


    // MARK: Private

    private var values: [T]

    private var tail: Slice<T> {
        let start = min(1, count)
        let end = max(start, count)
        return values[start..<end]
    }
}
