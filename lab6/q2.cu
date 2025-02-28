//CUDA selection sort 
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>


__global__ void parallelSelectionSort(int *A , int *O , int n){
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	if(tid<n){
		int data = A[tid];
		int pos = 0;

		for(int i=0;i<n;i++){
		if((A[i]<data) ||(A[i]==data && i<tid)){
			pos = pos+1;
		}
	}
	O[pos] = data;
	}
}

int main(void){
	int n;
	int *A , *O;
	int *d_A , *d_O;
	printf("Enter array size: \n");
	scanf("%d" , &n);
	
	A = (int*)malloc(n*sizeof(int));
	O = (int*)malloc(n*sizeof(int));

	cudaMalloc((void**)&d_A , n*sizeof(int));
	cudaMalloc((void**)&d_O , n*sizeof(int));

	printf("Enter array:\n");
	for(int i=0;i<n ;i++){
		scanf("%d" , &A[i]);
	}


	cudaMemcpy(d_A , A ,n*(sizeof(int)), cudaMemcpyHostToDevice);

	dim3 dimGrid(ceil(n/256.0) , 1 ,1);
	dim3 dimBlock(256,1,1);
	parallelSelectionSort<<<dimGrid , dimBlock>>>(d_A , d_O , n);
	cudaMemcpy(O , d_O , n*sizeof(int) ,cudaMemcpyDeviceToHost);
	printf("Result: \n");
	for(int i=0;i<n;i++){
	printf("%d \t",O[i]);
	}
	printf("\n");

}