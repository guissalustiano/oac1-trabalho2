# Install dependencies
## C
```bash
sudo apt install gcc
```

## Java
```bash
apt install -y default-jdk
```

## CPython
```bash
sudo apt install python3
```

## Pypy
```bash
sudo apt install Pypy
```

# Run
## C
```bash
gcc -o mandelbrot -std=c11 -O2 mandelbrot.c -lm
./mandelbrot -2.5 1.5 -2.0 2.0 2048 11500
```

## Java
```bash
javac mandelbrot.java
java Mandelbrot
```

## CPython
```bash
python mandelbrot.py -2.5 1.5 -2.0 2.0 11500
```
