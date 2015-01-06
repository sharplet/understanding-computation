println(Stack<Int>())
println(Stack([1]))
println(Stack([1,2,3,4]))
println(Stack(1...10))

let (_, result1) = push(3) >>> push(2) >>> push(1) <| Stack()
println(result1)
let (top, result2) = Stack() |> push(1) >>> push(2) >>> pop()
println("top = \(top), stack = \(result2)")

let (top2, _) = Stack(1...10) |> pop(3)
println(top2)

let (top3, _) = Stack(1...10) |> pop(0)
println(top3)

let (top4, _) = Stack(1...10) |> pop(15)
println(top4)
