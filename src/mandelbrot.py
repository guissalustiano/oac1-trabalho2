from dataclasses import dataclass
import sys

def write_image(image: Image, filename):
    with open(filename, 'wb') as f:
        f.write(f'P6\n {image.width}\n {image.height}\n {255}\n'.encode())
        for y in range(image.height):
            for x in range(image.width):
                pixel = image.pixels[y][x]
                f.write(bytes([pixel.red, pixel.green, pixel.blue]))

def main():
    argv = sys.argv
    if len(argv) < 6:
        print(f'Usage: {argv[0]} <real_min> <real_max> <imag_min> <imag_max>')
        print("examples with image_width = 11500:\n");
        print("    Full Picture:         ./mandelbrot -2.5 1.5 -2.0 2.0 11500\n");
        print("    Seahorse Valley:      ./mandelbrot -0.75 -0.737 -0.132 -0.121 11500\n");
        print("    Elephant Valley:      ./mandelbrot 0.175 0.375 -0.1 0.1 11500\n");
        print("    Triple Spiral Valley: ./mandelbrot -0.188 -0.012 0.554 0.754 11500\n");
        exit(1)

    width = int(argv[5])

if __name__ == '__main__':
    main()



