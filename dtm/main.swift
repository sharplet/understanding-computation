let rulebook = Rulebook([
    Rule(state: 1, character: "0", next: 2, toWrite: "1", direction: .Right),
    Rule(state: 1, character: "1", next: 1, toWrite: "0", direction: .Left),
    Rule(state: 1, character: "_", next: 2, toWrite: "1", direction: .Right),
    Rule(state: 2, character: "0", next: 2, toWrite: "0", direction: .Right),
    Rule(state: 2, character: "1", next: 2, toWrite: "1", direction: .Right),
    Rule(state: 2, character: "_", next: 3, toWrite: "_", direction: .Left),
    Rule(state: 3, character: "0", next: 1, toWrite: "0", direction: .Right),
    Rule(state: 3, character: "1", next: 1, toWrite: "1", direction: .Right),
])

var dtm = DTM(start: 1, tape: Tape([], "0", ["_"], "_"), accept: [3], rulebook: rulebook)

for _ in 1..<16 {
    dtm.restart()
    dtm.run()
    println(dtm.current?.tape)
}
