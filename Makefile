default: run

run: small-step
	@exec ./$<

small-step:
	xcrun -sdk macosx swiftc $@-*/*.swift -o $@

clean:
	@rm -f small-step
