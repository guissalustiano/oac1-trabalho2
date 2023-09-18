// Translation of mandelbrot.c in Java

import java.io.FileOutputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;

// https://introcs.cs.princeton.edu/java/32class/Complex.java.html
record Complex(double re, double im) {
    // return abs/modulus/magnitude
    public double abs() {
        return Math.hypot(re, im);
    }

    // return a new Complex object whose value is (this + b)
    public Complex plus(Complex b) {
        Complex a = this;             // invoking object
        double real = a.re + b.re;
        double imag = a.im + b.im;
        return new Complex(real, imag);
    }

    // return a new Complex object whose value is (this * b)
    public Complex times(Complex b) {
        Complex a = this;
        double real = a.re * b.re - a.im * b.im;
        double imag = a.re * b.im + a.im * b.re;
        return new Complex(real, imag);
    }
}

record Pixel(int red, int green, int blue) {}
record Image(int width, int height, Pixel[][] pixels) {}
record Frame(double realMin, double realMax, double imagMin, double imagMax) {}

class Mandelbrot {
    private static final int MAX_ITERATIONS = 200;
    private static final Pixel pallet[] = {
        new Pixel(66,  30,  15),
        new Pixel(25,  7,   26),
        new Pixel(9,   1,   47),
        new Pixel(4,   4,   73),
        new Pixel(0,   7,   100),
        new Pixel(12,  44,  138),
        new Pixel(24,  82,  177),
        new Pixel(57,  125, 209),
        new Pixel(134, 181, 229),
        new Pixel(211, 236, 248),
        new Pixel(241, 233, 191),
        new Pixel(248, 201, 95),
        new Pixel(255, 170, 0),
        new Pixel(204, 128, 0),
        new Pixel(153, 87,  0),
        new Pixel(106, 52,  3),
        new Pixel(16, 16, 16),
    };

    private static Complex fc(Complex z, Complex c) {
        return z.times(z).plus(c);
    }

    private static int iteratePoint(Complex z0) {
        Complex z = z0;
        for (int t = 0; t < MAX_ITERATIONS; t++) {
            z = fc(z, z0);

            if (z.abs() > 2.0) {
                return t;
            }
        }
        return MAX_ITERATIONS;
    }

    private static Pixel iteration2pixel(int iteration) {
        if (iteration == MAX_ITERATIONS) {
            return pallet[pallet.length - 1];
        } else {
            return pallet[iteration % pallet.length];
        }
    }

    private static void createMandelbrot(Frame frame, Image image) {
        double realStep = (frame.realMax() - frame.realMin()) / image.width();
        double imagStep = (frame.imagMax() - frame.imagMin()) / image.height();

        for (int y = 0; y < image.height(); y++) {
            double imag = frame.imagMin() + y * imagStep;

            if (Math.abs(imag) < imagStep / 2) {
                imag = 0.0;
            }

            for (int x = 0; x < image.width(); x++) {
                double real = frame.realMin() + x * realStep;

                int iteration = iteratePoint(new Complex(real, imag));

                Pixel pixel = iteration2pixel(iteration);

                image.pixels()[y][x] = pixel;
            }
        }
    }

    private static void writeImage(Image image, String filename) {
        try {
            FileOutputStream file = new FileOutputStream(filename);
            BufferedOutputStream writer = new BufferedOutputStream(file);
            writer.write(("P6\n" + image.width() + "\n" + image.height() + "\n255\n").getBytes());
            for(int y = 0; y < image.height(); y++) {
                for(int x = 0; x < image.width(); x++) {
                    Pixel pixel = image.pixels()[y][x];
                    writer.write(pixel.red());
                    writer.write(pixel.green());
                    writer.write(pixel.blue());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        if (args.length < 5) {
            System.out.println("Usage: java Mandelbrot <realMin> <realMax> <imagMin> <imagMax>");
            System.out.println("examples with image_width = 11500:\n");
            System.out.println("    Full Picture:         ./mandelbrot -2.5 1.5 -2.0 2.0 11500\n");
            System.out.println("    Seahorse Valley:      ./mandelbrot -0.75 -0.737 -0.132 -0.121 11500\n");
            System.out.println("    Elephant Valley:      ./mandelbrot 0.175 0.375 -0.1 0.1 11500\n");
            System.out.println("    Triple Spiral Valley: ./mandelbrot -0.188 -0.012 0.554 0.754 11500\n");
            System.exit(1);
        }

        Frame frame = new Frame(
                Double.parseDouble(args[0]),
                Double.parseDouble(args[1]),
                Double.parseDouble(args[2]),
                Double.parseDouble(args[3])
        );

        int imageWidth = Integer.parseInt(args[4]);
        int imageHeight = (int) (imageWidth * (frame.imagMax() - frame.imagMin()) / (frame.realMax() - frame.realMin()));
        Image image = new Image(imageWidth, imageHeight, new Pixel[imageHeight][imageWidth]);

        createMandelbrot(frame, image);
        writeImage(image, "mandelbrot.ppm");
    }
}
