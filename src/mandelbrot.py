from dataclasses import dataclass
import sys

# Tradução do mandelbrot.c para python

MAX_ITERATIONS = 200;

@dataclass
class Pixel:
    red: int
    green: int
    blue: int

class Image:
    pixels #: list[list[Pixel]] # Not work in pypy 3.8

    @property
    def width(self) -> int:
        return len(self.pixels[0])

    @property
    def height(self) -> int:
        return len(self.pixels)

    def __init__(self, width: int, height: int):
        self.pixels = [[Pixel(0, 0, 0) for _ in range(width)] for _ in range(height)]

@dataclass
class Frame:
    real_min: float
    real_max: float
    imag_min: float
    imag_max: float

pallet = [
    Pixel(66,  30,  15),
    Pixel(25,  7,   26),
    Pixel(9,   1,   47),
    Pixel(4,   4,   73),
    Pixel(0,   7,   100),
    Pixel(12,  44,  138),
    Pixel(24,  82,  177),
    Pixel(57,  125, 209),
    Pixel(134, 181, 229),
    Pixel(211, 236, 248),
    Pixel(241, 233, 191),
    Pixel(248, 201, 95),
    Pixel(255, 170, 0),
    Pixel(204, 128, 0),
    Pixel(153, 87,  0),
    Pixel(106, 52,  3),
    Pixel(16,  16,  16),
]

def fc(z: complex, c: complex) -> complex:
    return z * z + c

def iterate_point(z0: complex) -> int:
    z = z0
    for i in range(MAX_ITERATIONS):
        if abs(z) > 2.0:
            return i

        z = fc(z, z0)
    return MAX_ITERATIONS

def iteration2pixel(iteration: int) -> Pixel:
    if iteration >= MAX_ITERATIONS:
        return pallet[-1]

    return pallet[iteration % len(pallet)]

def create_mandelbrot(frame: Frame, image: Image):
    real_step = (frame.real_max - frame.real_min) / image.width
    imag_step = (frame.imag_max - frame.imag_min) / image.height

    for y in range(image.height):
        imag = frame.imag_min + y * imag_step

        if abs(imag) < imag_step / 2:
            imag = 0.0

        for x in range(image.width):
            real = frame.real_min + x * real_step
            iteration = iterate_point(complex(real, imag))
            image.pixels[y][x] = iteration2pixel(iteration)

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

    frame = Frame(
        real_min=float(argv[1]),
        real_max=float(argv[2]),
        imag_min=float(argv[3]),
        imag_max=float(argv[4]),
    )

    width = int(argv[5])
    height = int(width * (frame.imag_max - frame.imag_min) / (frame.real_max - frame.real_min))
    image = Image(width, height)

    create_mandelbrot(frame, image)
    write_image(image, "mandelbrot.ppm")

if __name__ == '__main__':
    main()



