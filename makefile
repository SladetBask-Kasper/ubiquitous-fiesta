main: main.vala
	valac --pkg libsoup-2.4 --thread --pkg gtk+-3.0 main.vala
main: soupTester.vala
	valac --pkg libsoup-2.4 --thread soupTester.vala
clean:
	rm main
run:
	./main

