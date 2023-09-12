# Install dependencies
## C
```bash
sudo apt install gcc
```

## Java
```bash
```

## CPython
```bash
sudo apt install python3
```

## Pypy
```bash
sudo apt install Pypy
```

## Cython
```bash
pip install Cython
```

# Run
## C
```bash
gcc -o mandelbrot -std=c11 -O2 mandelbrot.c -lm
./mandelbrot -2.5 1.5 -2.0 2.0 2048 11500
```

## Java
```bash
```

## CPython
```bash
python mandelbrot.py -2.5 1.5 -2.0 2.0 11500
```

## Cython
```bash
cython mandelbrot.py -o mandelbrot_py.c
gcc -o mandelbrot_py -std=c11 -O2 mandelbrot_py.c -lm
gcc -shared -pthread -fPIC -fwrapv -O2 -Wall -fno-strict-aliasing -I/usr/include/python3.10 -o mandelbrot_py mandelbrot_py.c

./mandelbrot_py -2.5 1.5 -2.0 2.0 2048 11500
```

