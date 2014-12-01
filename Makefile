default: run

run: 1
	@exec ./$<

1:
	xcrun -sdk macosx swiftc $@-*/*.swift -o $@

clean:
	@rm 1
