/*
println(Stack<Int>())
println(Stack([1]))
println(Stack([1,2,3,4]))
println(Stack(1...10))

let stack = Stack().push(3).1.push(2).1.push(1).1
println(stack.pop(1))
println(stack.pop(2))
println(stack.pop(3))
*/

typealias Stack = [Int]

func push(a: Int) -> State<Stack, ()> {
    return State { xs in ((),[a]+xs) }
}

func pop() -> State<Stack, Int?> {
    return State { xs in
        if let a = xs.first {
            return (a, Array(dropFirst(xs)))
        }
        else {
            return (nil, [])
        }
    }
}

let start = [Int]()
let push1 = push(1)
let push123 = push(1) >>> push(2) >>> push(3)
println(push123.exec(start))
