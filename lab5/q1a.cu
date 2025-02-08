#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

__global__ void vectadd(int *a , int*b , int* c , int n){
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	if(tid<n){
	c[tid] = a[tid] + b[tid];
	}
}

int main(void){
	int *a,*b,*c ,*d , *e;
	int *d_a , *d_b , *d_c , *d_d , *d_e;
	int n;
	printf("Enter length of vector\n");
	scanf("%d",&n);
	int size = n* sizeof(int);

	a = (int*)malloc(size);
    b = (int*)malloc(size);
    c = (int*)malloc(size);
    d = (int*)malloc(size);
    e = (int*)malloc(size);

	cudaMalloc((void**)&d_a , size);
	cudaMalloc((void**)&d_b , size);
	cudaMalloc((void**)&d_c , size);
	cudaMalloc((void**)&d_d , size);
	cudaMalloc((void**)&d_e , size);

	printf("Enter first vector : \n");
	for(int i=0;i<n;i++){
	scanf("%d",&a[i]);
	}
	printf("Enter second vector : \n");
	for(int i=0;i<n;i++){
	scanf("%d",&b[i]);
	}

	cudaMemcpy(d_a , a ,size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b , b ,size, cudaMemcpyHostToDevice);

	//n threads (n threads in one block)
	printf("n threads (n threads in one block)\n");
	vectadd<<<1 , n>>>(d_a , d_b , d_c , n);
	cudaMemcpy(c , d_c , size ,cudaMemcpyDeviceToHost);
	printf("Result: \n");
	for(int i=0;i<n;i++){
	printf("%d\t",c[i]);
	}
	printf("\n");

	//n blocks(1 thread per block )
	printf("n blocks(1 thread per block )\n");
	vectadd<<<n , 1>>>(d_a , d_b , d_d , n);
	cudaMemcpy(d , d_d , size ,cudaMemcpyDeviceToHost);
	printf("Result: \n");
	for(int i=0;i<n;i++){
	printf("%d\t",d[i]);
	}

	printf("\n");

	dim3 dimGrid(ceil(n/256.0) , 1 ,1);
	dim3 dimBlock(256,1,1);
	//256 threads per block , varying no of blocks 
	printf("256 threads per block , varying no of blocks\n");
	vectadd<<<dimGrid , dimBlock>>>(d_a , d_b , d_e , n);
	cudaMemcpy(e , d_e , size ,cudaMemcpyDeviceToHost);
	printf("Result: \n");
	for(int i=0;i<n;i++){
	printf("%d\t",e[i]);
	}
	printf("\n");

    free(a);
    free(b);
    free(c);
    free(d);
    free(e);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	cudaFree(d_d);
	cudaFree(d_e);
	return 0;
}