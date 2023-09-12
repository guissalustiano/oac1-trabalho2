FROM ubuntu:latest

RUN apt update

RUN apt install -y gcc
RUN apt install -y python3 python3-pip python-is-python3
RUN apt install -y pypy
RUN pip install cython

