let rulebook = DFARulebook([
  FARule(1, transition: ("a", 2)), FARule(1, transition: ("b", 1)),
  FARule(2, transition: ("a", 2)), FARule(2, transition: ("b", 3)),
  FARule(3, transition: ("a", 3)), FARule(3, transition: ("b", 3))
])
println(rulebook)

let design = DFADesign(start: 1, accept: [3], rulebook: rulebook)
for result in design.test("a", "baa", "baba", "c") {
  println(result)
}

let rulebook2 = NFARulebook([
  FARule(1, transition: ("a", 1)), FARule(1, transition: ("b", 1)), FARule(1, transition: ("b", 2)),
  FARule(2, transition: ("a", 3)), FARule(2, transition: ("b", 3)),
  FARule(3, transition: ("a", 4)), FARule(3, transition: ("b", 4))
])
println(rulebook2)

let design2 = NFADesign(start: 1, accept: [4], rulebook: rulebook2)
for result in design2.test("bab", "bbbbb", "bbabb", "c") {
  println(result)
}

let rulebook3 = NFARulebook([
  FARule(1, transition: (nil, 2)), FARule(1, transition: (nil, 4)),
  FARule(2, transition: ("a", 3)),
  FARule(3, transition: ("a", 2)),
  FARule(4, transition: ("a", 5)),
  FARule(5, transition: ("a", 6)),
  FARule(6, transition: ("a", 4)),
])
println(rulebook3)

let design3 = NFADesign(start: 1, accept: [2, 4], rulebook: rulebook3)
for result in design3.test("aa", "aaa", "aaaaa", "aaaaaa") {
  println(result)
}
