#include <iostream>
#include <stdio.h>
#include <math.h>
#include <cstring>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(char* file, int cache_size, int block_size)
{
	unsigned int tag, index, x;
	int total_num=0;
	int miss_num=0;
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];
	
    cout << "cache line: " << line << endl;

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    FILE *fp = fopen(file, "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
    	total_num++;
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		if(cache[index].v && cache[index].tag == tag)
			cache[index].v = true;    // hit
		else
        {
        	miss_num++;
			cache[index].v = true;  // miss
			cache[index].tag = tag;
		}
	}
	cout<<"clock_size  block_size  "<<cache_size<<"  "<<block_size<<endl;
	cout<<"miss ratio: "<<(float)miss_num/(float)total_num<<endl<<endl;
	fclose(fp);

	delete [] cache;
}
	
int main()
{
	// Let us simulate 4KB cache with 16B blocks
	//simulate(4 * K, 16);
	int cache_size, block_size;
	char file[2][30];
	strcpy(file[0], "ICACHE.txt");
	strcpy(file[1], "DCACHE.txt");
	

	////////////這裡之後可改呈現方式
	for(int i=0;i<2;i++)
	{
		cout<<file[i]<<endl<<endl;
		for(int cache=4; cache<=256; cache*=4)
		{
			for(int block=16; block<=256; block*=2)
			{
				simulate(file[i],cache * K, block);
			}
			cout<<endl<<"---------------------------"<<endl<<endl;
		}
		cout<<endl;
	}

	
}
