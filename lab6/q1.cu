#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>


__global__ void maskit(float*N , float*M , int mask_width , int width , float*P){
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	float pval = 0;
	int sp = tid - (mask_width/2);
	for(int i=0;i<mask_width ;i++){
	if(sp + i >=0 && sp + i < width){
	pval += N[sp+i]*M[i];
	}
	}
	P[tid] = pval;
}

int main(void){
	int width , mask_width;
	float *N , *M, *P;
	float *d_N , *d_M ,*d_P;
	printf("Enter array size: \n");
	scanf("%d" , &width);
	printf("Enter mask size: \n");
	scanf("%d" ,&mask_width);

	N = (float*)malloc(width*sizeof(float));
	M = (float*)malloc(mask_width*sizeof(float));
	P = (float*)malloc(width*sizeof(float));

	cudaMalloc((void**)&d_N , width*sizeof(float));
	cudaMalloc((void**)&d_M , mask_width*sizeof(float));
	cudaMalloc((void**)&d_P , width*sizeof(float));

	printf("Enter array:\n");
	for(int i=0;i<width ;i++){
		scanf("%f" , &N[i]);
	}

	printf("Enter Mask array: \n");
	for(int i=0;i<mask_width;i++){
		scanf("%f" , &M[i]);
	}

	cudaMemcpy(d_N , N ,width*(sizeof(float)), cudaMemcpyHostToDevice);
	cudaMemcpy(d_M , M ,mask_width*(sizeof(float)), cudaMemcpyHostToDevice);

	dim3 dimGrid(ceil(width/256.0) , 1 ,1);
	dim3 dimBlock(256,1,1);
	maskit<<<dimGrid , dimBlock>>>(d_N , d_M , mask_width , width, d_P);
	cudaMemcpy(P , d_P , width*sizeof(float) ,cudaMemcpyDeviceToHost);
	printf("Result: \n");
	for(int i=0;i<width;i++){
	printf("%.2f \t",P[i]);
	}
	printf("\n");

}