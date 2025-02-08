#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include<math.h>

__global__ void findsin(double *a , double* c , int n){
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if(tid<n){
    c[tid] = sin(a[tid]);
    }
}

int main(void){
    double *a,*c;
    double *d_a , *d_c;
    int n;
    printf("Enter length of vector\n");
    scanf("%d",&n);
    double size = n* sizeof(double);

    a = (double*)malloc(size);
    c = (double*)malloc(size);

    cudaMalloc((void**)&d_a , size);
    cudaMalloc((void**)&d_c , size);

    printf("Enter vector containing angles in radians: \n");
    for(int i=0;i<n;i++){
    scanf("%lf",&a[i]);
    }

    cudaMemcpy(d_a , a ,size, cudaMemcpyHostToDevice);

    dim3 dimGrid(ceil(n/256.0) , 1 ,1);
    dim3 dimBlock(256,1,1);
    //256 threads per block , varying no of blocks 
    printf("256 threads per block , varying no of blocks\n");
    findsin<<<dimGrid , dimBlock>>>(d_a ,d_c , n);
    cudaMemcpy(c , d_c , size ,cudaMemcpyDeviceToHost);
    printf("Result: \n");
    for(int i=0;i<n;i++){
    printf("%.4f\t",c[i]);
    }
    printf("\n");

    free(a);
    free(c);
    
    cudaFree(d_a);
    cudaFree(d_c);
    return 0;
}