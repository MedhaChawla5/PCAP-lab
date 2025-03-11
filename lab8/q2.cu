#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda_runtime.h>


__global__ void add(int *a ,int *b , int *t , int ha , int wa){
    int rid = threadIdx.x;
    for(int i=0;i<wa;i++){
    t[rid*wa + i] = a[rid*wa + i] + b[rid*wa + i];
    }
}

__global__ void addcol(int*a , int *b , int*t , int ha , int wa){
    int col = threadIdx.x;
    for(int i=0;i<ha;i++){
    t[i*wa + col ] = a[i*wa + col] + b[i*wa + col];
    }
}

__global__ void addele(int*a , int *b , int*t , int ha , int wa){
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    t[row*wa+col] = a[row*wa + col] + b[row*wa + col];
}

int main(void){
    int *a , *b , *t , ha , wa , hb , wb;
    int *d_a , *d_b , *d_t;
    printf("Enter ha: \n");
    scanf("%d",&ha);
    printf("Enter wa: \n");
    scanf("%d",&wa);
    printf("Enter hb: \n");
    scanf("%d",&hb);
    printf("Enter wb: \n");
    scanf("%d",&wb);
    int sizeT = sizeof(int)*ha*wb;
    int sizeA = sizeof(int)*ha*wa;
    int sizeB = sizeof(int)*hb*wb;
    a = (int*)malloc(ha*wa*sizeof(int));
    b = (int*)malloc(hb*wb*sizeof(int));
    t = (int*)malloc(ha*wb*sizeof(int));

    printf("Enter input matrix A: \n");
    for(int i=0;i<ha*wa;i++){
    scanf("%d" , &a[i]);
    }

    printf("Enter input matrix B: \n");
    for(int i=0;i<hb*wb;i++){
    scanf("%d" , &b[i]);
    }

    cudaMalloc((void**)&d_a , sizeA);
    cudaMalloc((void**)&d_b , sizeB);
    cudaMalloc((void**)&d_t , sizeT);

    cudaMemcpy(d_a , a , sizeA , cudaMemcpyHostToDevice);
    cudaMemcpy(d_b , b , sizeB , cudaMemcpyHostToDevice);
    add<<<1,ha>>>(d_a ,d_b , d_t ,ha ,wa);
    addcol<<<1,wa>>>(d_a ,d_b , d_t ,ha ,wa);
    addele<<<ha,wa>>>(d_a ,d_b , d_t ,ha ,wa);
    cudaMemcpy(t,d_t , sizeT , cudaMemcpyDeviceToHost);
    printf("Resultant vector is : \n");
    for(int i=0;i<ha;i++){
    for(int j=0;j<wb;j++){
    printf("%d\t" , t[i*wb+j]);
    }
    printf("\n");
    }
    getchar();
    cudaFree(d_a);
    cudaFree(d_t);
    return 0;
}