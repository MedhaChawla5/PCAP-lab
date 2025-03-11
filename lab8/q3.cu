#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda_runtime.h>


__global__ void mul(int *a ,int *b , int *t , int wb , int wa){
    int rid = threadIdx.x;
    int sum;
    for(int cid=0;cid<wb;cid++){
    sum = 0;
    for(int k=0;k<wa ;k++){
    sum += a[rid*wa + k]*b[k*wb+cid];
    }
    t[rid*wb+cid] = sum;
    }
}

__global__ void mulcol(int*a , int *b , int*t , int ha , int wa  , int wb){
    int col = threadIdx.x;
    int sum;
    for(int row = 0;row<ha;row++){
    sum = 0;
    for(int k = 0;k<wa;k++){
    sum += a[row*wa+k]*b[k*wb+col];
    }
    t[row*wb+col] = sum;
    }
}

__global__ void mulele(int*a , int *b , int*t , int wb , int wa){
    int col = threadIdx.x;
    int row = threadIdx.y;
    int sum = 0;
    for(int k=0;k<wa;k++){
    sum += a[row*wa+k]*b[k*wb+col];
    }
    t[row*wb+col] = sum;
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
    mul<<<1,ha>>>(d_a ,d_b , d_t ,wb ,wa);
    cudaMemcpy(t,d_t , sizeT , cudaMemcpyDeviceToHost);
    printf("Resultant vector is : \n");
    for(int i=0;i<ha;i++){
    for(int j=0;j<wb;j++){
    printf("%d\t" , t[i*wb+j]);
    }
    printf("\n");
    }
    mulcol<<<1,wa>>>(d_a ,d_b , d_t ,ha ,wa , wb);
    cudaMemcpy(t,d_t , sizeT , cudaMemcpyDeviceToHost);
    printf("Resultant vector is : \n");
    for(int i=0;i<ha;i++){
    for(int j=0;j<wb;j++){
    printf("%d\t" , t[i*wb+j]);
    }
    printf("\n");
    }
    mulele<<<ha,wa>>>(d_a ,d_b , d_t ,wb ,wa);
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