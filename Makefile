default: run

run: main
	@exec ./$<

main:
	xcrun -sdk macosx swiftc *.swift -o $@

clean:
	@rm main
