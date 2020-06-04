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

int usable_cache(cache_content *cache, int way)
{
	for(int i=0; i<way; i++)
	{
		if(cache[i].v==0)
		{
			return i
		}
	}
	return i;
}

void insert_cache(cache_content *cache, unsigned int tag, int start, int end)
{
	for(int i=start; i <= end; i++)
	{
		cache[i-1].tag=cache[i].tag;
		cache[i-1].v=true;
	}
	cache[t].tag=tag;
	cache[t].v=true;
	return;
}

void simulate(char *file,int cache_size, int block_size,int way)
{
	unsigned int tag, index, x;
	int total_num=0;
	int miss_num=0;
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);
	int set=line/way;
	int hit_or_not=0;

	cache_content **cache = new cache_content*[set];
	cout << "cache line: " << line << endl;
// from here
	for(int i=0;i<set;i++)
	{
		cache[i]=new cache_content[way];

		for(int j=0;j<way;j++)
		{
			cache[i][j].v=0;
		}
	}
// to here
    FILE *fp = fopen(file, "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		total_num++;
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		hit_or_not=0;
		for(int i=0;i<way;i++)
		{
			if(cache[index][i].v && cache[index][i].tag==tag)
			{
				// hit
				hit_or_not=true;
				//********************************

				break;
			}
		}
		if(hit_or_not==0)
        {
        	miss++;	// miss
        	//************************
        	
		}
	}
	cout<<"clock_size  way "<<cache_size<<"  "<<way<<endl;
	cout<<"miss ratio: "<<(float)miss_num/(float)total_num<<endl<<endl;
	fclose(fp);

	for(int i=0;i<set;i++)
		delete [] cache[i];
	delete [] cache;
}


	
int main()
{
	// Let us simulate 4KB cache with 16B blocks
	//simulate(4 * K, 16);
	int cache_size, block_size;
	char file[2][30];
	strcpy(file[0],"LU.txt");
	strcpy(file[1],"RADIX.txt");

	////////////這裡之後可改呈現方式
	for(int i=0;i<2;i++)
	{
		cout<<file[i]<<endl<<endl;
		for(int cache=4; cache<=256; cache*=4)
		{
			for(int way=1; way<=8; way*2)
			{
				simulate(file[i],cache * K, way);
			}
			cout<<endl<<"---------------------------"<<endl<<endl;
		}
		cout<<endl;
	}

	
}