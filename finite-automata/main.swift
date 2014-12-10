let rulebook = DFARulebook([
  FARule(1, transition: ("a", 2)), FARule(1, transition: ("b", 1)),
  FARule(2, transition: ("a", 2)), FARule(2, transition: ("b", 3)),
  FARule(3, transition: ("a", 3)), FARule(3, transition: ("b", 3))
])

let design = DFADesign(start: 1, accept: [3], rulebook: rulebook)

println(rulebook)
for result in design.test("a", "baa", "baba", "c") {
  println(result)
}

let rulebook2 = NFARulebook([
  FARule(1, transition: ("a", 1)), FARule(1, transition: ("b", 1)), FARule(1, transition: ("b", 2)),
  FARule(2, transition: ("a", 3)), FARule(2, transition: ("b", 3)),
  FARule(3, transition: ("a", 4)), FARule(3, transition: ("b", 4))
])

let design2 = NFADesign(start: 1, accept: [4], rulebook: rulebook2)

println(rulebook2)
for result in design2.test("bab", "bbbbb", "bbabb", "c") {
  println(result)
}
