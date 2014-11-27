PWD:= $(shell pwd)

all:
	mkdir -p $(PWD)/bin
	clang++ -g -O3 -o bin/cheddarc src/cheddar.cpp
