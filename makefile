main: main.vala
	valac --pkg gtk+-3.0 main.vala
clean:
	rm main
run:
	./main

