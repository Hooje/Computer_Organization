#include <iostream>
#include <stdio.h>
#include <math.h>
#include <cstring>

using namespace std;

int A[1024][1024]={0};
int B[1024][1024]={0};
int C[1024][1024]={0};
long long a[1024][1024];
long long b[1024][1024];
unsigned int c[1024][1024];

const int K = 1024;
int m, n, p;
long long address_A, address_B, address_C;

void print(){
	int i, j;
	printf("(%lld,%lld,%lld)\n",address_A,address_B,address_C);
	printf("(%d,%d,%d)\n", m, n, p);
	printf("\narray A:\n");
	for(i=0; i<m; i++){
		for(j=0; j<n; j++){
			printf(" %lld", a[i][j]);
		}
		printf("\n");
	}
	printf("\narray B:\n");
	for(i=0; i<n; i++){
		for(j=0; j<p; j++){
			printf(" %lld", b[i][j]);
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


struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

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

// LRU  true for hit, false for miss 
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


long long oneWordWideSimulation()
{
	long long stall;
	int hit = 1 + 2 + 1;
	int miss = 1 + 2 + 1 + 1 + 100 + 1;
	int cache_size = 512;
	int block_size = 32;	// 8 words
	int way = 8; // 8-way set-associative caches
	int i, j, k;

	unsigned int tag, index, x;
	
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);	
	int line = cache_size >> (offset_bit);							//line is number of blocks
	
	int set_num = line / way;
	int set_bit = log2(set_num);
	bool judge;

	cache_content **cache = new cache_content*[set_num];

	/*cout << "cache line: " << line << endl;
	printf("cache_size: %d | set_num: %d | way: %d\n",cache_size,set_num,way);
	printf("offet_bit: %d | index_bit: %d\n",offset_bit,index_bit);*/

	for(int i=0;i<set_num;i++)
	{
		cache[i]=new cache_content[way];
		for(int j=0;j<way;j++)
		{
			cache[i][j].v=0;
		}
	}

	//multiplication simulation
	for (i = 0; i < m; ++i)
	{
		for (j = 0; j < p; ++j)
		{
			for (k = 0; k < n; ++k)
			{	
				index = (c[i][j] >> offset_bit) & (set_num - 1); //lw
				judge = insert_cache(cache[index],c[i][j],way);
				stall += judge ? hit : miss;

				index = (a[i][k] >> offset_bit) & (set_num - 1); //lw
				judge = insert_cache(cache[index],a[i][k],way);
				stall += judge ? hit : miss;

				index = (b[k][j] >> offset_bit) & (set_num - 1); //lw
				judge = insert_cache(cache[index],b[k][j],way);
				stall += judge ? hit : miss;

				index = (c[i][j] >> offset_bit) & (set_num - 1); //sw
				judge = insert_cache(cache[index],c[i][j],way);
				stall += judge ? hit : miss;

				//C[i][j]+=(A[i][k]*B[k][j]);
			}
		}
	}

		//cout << hex << x << " ";
		//index = (x >> offset_bit) & (set_num - 1);
		//tag = x >> (set_bit + offset_bit);
		//judge = insert_cache(cache[index], tag, way);

	for(int i=0;i<set_num;i++)
		delete [] cache[i];
	delete [] cache;

	return stall;
}




int main(int argc, char *argv[])
{
	char *input;
	char *output;
	input = argv[1];
	output = argv[2];

	int i, j, k;
	long long programCycles, oneWordWideCycles,
						widerMemoryCycles, twoLevelMemoryCycles;

	FILE *fp = fopen(input, "r");		// read file
	fscanf(fp, "%llx %llx %llx", &address_A, &address_B, &address_C);
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

	programCycles = 2 + 2*(m+1) + m + 2*m*(p+1) + m*p
									+ 2*(n+1)*m*p + 20*m*n*p + 2*m*p + 2*m;  // add 1 ??

	oneWordWideCycles = oneWordWideSimulation();
	
	printf("%lld %lld\n", programCycles, oneWordWideCycles);
		
	return 0;
}
