docker build -t oac1-t2 .
docker run -it --rm -v $PWD/src:/app -w /app oac1-t2
