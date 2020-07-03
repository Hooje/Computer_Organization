.PHONY: clean all

all: build clean

build: cache.o
	g++ -o cache cache.o


cache.o: cache.cpp
	g++ -c cache.cpp



clean:
	rm *.o
