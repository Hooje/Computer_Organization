#include <iostream>
#include <stdio.h>
#include <math.h>
#include <cstring>

using namespace std;

int A[1024][1024]={0};
int B[1024][1024]={0};
int C[1024][1024]={0};
unsigned int a[1024][1024];
unsigned int b[1024][1024];
unsigned int c[1024][1024];

int m, n, p;
unsigned int address_A, address_B, address_C;

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


int usable_cache(cache_content *set, int way)
{
	int i;
	for(i = 0; i < way; i++)
	{
		if(set[i].v==0)
		{
			return i;
		}
	}
	return i;
}

// true for hit, false for miss
bool insert_cache(cache_content *set, unsigned int tag, int way)
{	
	int valid, i, j;
	cache_content temp;

	valid = usable_cache(set, way);	// find the position

	for(i=0; i<valid; i++)
	{
		if(set[i].tag == tag)
		{
			temp = set[i];
			for(j=i; j>=1; j--){
				set[j].tag = set[j-1].tag;
				set[j].v = set[j-1].v;
			}
			set[0] = temp;
			return true;
		}
	}
	
	if(valid == way){	//condition of full
	
		for(j = way - 1; j >= 1; j--){
			set[j].tag = set[j-1].tag;
			set[j].v = set[j-1].v;
		}

		set[0].tag = tag;
		set[0].v = true;

		return false;
		
	}else{	//condition of not full
		
		for(j = valid; j >= 1; j--){
			set[j].tag = set[j-1].tag;
			set[j].v = set[j-1].v;
		}

		set[0].tag = tag;
		set[0].v = true;

		return false;
	}

}


void simulate(char *file,int cache_size, int block_size,int way)
{
	unsigned int tag, index, x;

	int total_num=0;
	int miss_num=0;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);	
	int line = cache_size >> (offset_bit);							//line is number of blocks
	
	int set_num = line / way;
	int set_bit = log2(set_num);
	bool judge;

	cache_content **cache = new cache_content*[set_num];
	cout << "cache line: " << line << endl;
	
	//printf("offet_bit: %d | index_bit: %d\n",offset_bit,index_bit); 	
	for(int i=0;i<set_num;i++)
	{
		cache[i]=new cache_content[way];
		for(int j=0;j<way;j++)
		{
			cache[i][j].v=0;
		}
	}
	
  FILE *fp = fopen(file, "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
  {
		total_num++;
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (set_num - 1);
		tag = x >> (set_bit + offset_bit);

		judge = insert_cache(cache[index], tag, way);

		if(judge == false)
			miss_num++;
	}
	
	printf("cache_size: %d | set_num: %d | way: %d\n",cache_size,set_num,way);
	cout<<"miss ratio: "<<(float)miss_num/(float)total_num<<endl<<endl;
	fclose(fp);

	for(int i=0;i<set_num;i++)
		delete [] cache[i];
	delete [] cache;
}

void print(){
	int i, j;
	printf("(%x,%x,%x)\n",address_A,address_B,address_C);
	printf("(%d,%d,%d)\n", m, n, p);
	printf("\narray A:\n");
	for(i=0; i<m; i++){
		for(j=0; j<n; j++){
			printf(" %d", A[i][j]);
		}
		printf("\n");
	}
	printf("\narray B:\n");
	for(i=0; i<n; i++){
		for(j=0; j<p; j++){
			printf(" %d", B[i][j]);
		}
		printf("\n");
	}
	printf("\narray C:\n");
	for(i=0; i<m; i++){
		for(j=0; j<p; j++){
			printf(" %d", C[i][j]);
		}
		printf("\n");
	}

}

void address_init(){
	a[0][0] = address_A;
	b[0][0] = address_B;
	int i, j;
	for(j=1; j<n; j++)
		a[0][j] = a[0][j-1] + 4;
	for(i=1; i<m; i++){
		a[i][0] = a[i-1][n-1] + 4;
		for(j=1; j<n; j++){
			a[i][j] = a[i][j-1] + 4;
		}
	}
	
	for(j=1; j<p; j++)
		b[0][j] = b[0][j-1] + 4;
	for(i=1; i<n; i++){
		b[i][0] = b[i-1][p-1] + 4;
		for(j=1; j<p; j++){
			b[i][j] = b[i][j-1] + 4;
		}
	}
}

int main(int argc, char *argv[])
{
	// Let us simulate 4KB cache with 16B blocks
	//simulate(4 * K, 16);
	char *input;
	char *output;
	input = argv[1];
	output = argv[2];

	int i, j, k;

	FILE *fp = fopen(input, "r");		// read file
	fscanf(fp, "%x %x %x", &address_A, &address_B, &address_C);
	fscanf(fp, "%d %d %d", &m, &n, &p);
	
	for(i = 0; i < m; i++){
		for(j = 0; j < n; j++){
			fscanf(fp, "%d", &A[i][j]);
		}
	}
	
	for(i = 0; i < n; i++){
		for(j = 0; j < p; j++){
			fscanf(fp, "%d", &B[i][j]);
		}
	}
	
	address_init();

	//array multiplication
	for (i = 0; i < m; ++i)
	{
		for (j = 0; j < p; ++j)
		{
			C[i][j]=0;
			for (k = 0; k < n; ++k)
			{
				C[i][j]+=(A[i][k]*B[k][j]);
			}
			
		}
	}

	print();
		
	int cache_size, block_size;

	////////////這裡之後可改呈現方式
	//simulate(file[0], 4 * K, 64, 4);
	
	/*
	for(int i=0;i<2;i++)
	{
		cout<<file[i]<<endl<<endl;
		for(int cache=4; cache<=256; cache *= 4)
		{
			for(int way=1; way<=64; way = way * 2)
			{
				simulate(file[i],cache * K, 64, way);
			}
			cout<<endl<<"---------------------------"<<endl<<endl;
		}
		cout<<endl;
	}*/
	
	return 0;
}
