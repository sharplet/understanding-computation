let rulebook = Rulebook(rules: [
    Rule(state: 1, character: "(", next: 2, toPop: "$", toPush: ["b", "$"]),
    Rule(state: 2, character: "(", next: 2, toPop: "b", toPush: ["b", "b"]),
    Rule(state: 2, character: ")", next: 2, toPop: "b", toPush: []),
    Rule(state: 2, character: nil, next: 1, toPop: "$", toPush: ["$"]),
])

let design = DPDADesign(start: 1, bottom: "$", accept: [1], rulebook: rulebook)

println(design.accepts("(()"))
println(design.accepts("))()"))
println(design.accepts("(((((((((())))))))))"))
println(design.accepts("()(())((()))(()(()))"))

var dpda = DPDA(start: 1, stack: Stack(["$"]), accept: [1], rulebook: rulebook)
dpda.read("(()(")
println(dpda.accepting)
dpda.read("))()")
println(dpda.accepting)
