.PHONY: all
all: mandelbrot

mandelbrot: mandelbrot.c
	gcc -o mandelbrot -std=c11 -O2 mandelbrot.c -lm

.PHONY: clean
clean:
	rm mandelbrot mandelbrot.ppm
