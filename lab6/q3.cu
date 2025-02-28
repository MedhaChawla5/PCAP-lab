//Odd-Even transposition sort 
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>


__global__ void odd_even(int *A ,int n){
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	if(tid%2 !=0 && tid+1 <n){
	if(A[tid] > A[tid+1]){
	int temp = A[tid];
	A[tid] = A[tid+1];
	A[tid+1] = temp;
	}
	}
}

__global__ void even_odd(int *A ,int n){
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	if(tid%2 ==0 && tid+1 <n){
	if(A[tid] > A[tid+1]){
	int temp = A[tid];
	A[tid] = A[tid+1];
	A[tid+1] = temp;
	}
	}
}

int main(void){
	int n;
	int *A;
	int *d_A;
	printf("Enter array size: \n");
	scanf("%d" , &n);
	
	A = (int*)malloc(n*sizeof(int));

	cudaMalloc((void**)&d_A , n*sizeof(int));

	printf("Enter array:\n");
	for(int i=0;i<n ;i++){
		scanf("%d" , &A[i]);
	}


	cudaMemcpy(d_A , A ,n*(sizeof(int)), cudaMemcpyHostToDevice);

	dim3 dimGrid(ceil(n/256.0) , 1 ,1);
	dim3 dimBlock(256,1,1);

	for(int i=0;i<n/2 ;i++){
	odd_even<<<dimGrid , dimBlock>>>(d_A , n);
	even_odd<<<dimGrid , dimBlock>>>(d_A , n);
	}
	cudaMemcpy(A , d_A , n*sizeof(int) ,cudaMemcpyDeviceToHost);
	printf("Result: \n");
	for(int i=0;i<n;i++){
	printf("%d \t",A[i]);
	}
	printf("\n");

}