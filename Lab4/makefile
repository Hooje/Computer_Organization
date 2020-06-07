.PHONY: clean all

all: build clean

build: direct_mapped_cache_lru.o direct_mapped_cache.o
	g++ -o direct_mapped_cache direct_mapped_cache.o
	g++ -o direct_mapped_cache_lru direct_mapped_cache_lru.o


direct_mapped_cache.o: direct_mapped_cache.cpp
	g++ -c direct_mapped_cache.cpp


direct_mapped_cache_lru.o: direct_mapped_cache_lru.cpp
	g++ -c direct_mapped_cache_lru.cpp

clean:
	rm *.o
