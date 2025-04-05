#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__constant__ float d_B[1024];  
__global__ void matrixMultiply(float *A, float *C, int A_rows, int A_cols, int B_cols) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < A_rows && col < B_cols) {
        float value = 0;
        for (int k = 0; k < A_cols; ++k) {
            value += A[row * A_cols + k] * d_B[k * B_cols + col];  
        }
        C[row * B_cols + col] = value;
    }
}

int main() {
    int A_rows, A_cols, B_cols;

    printf("Enter row A , col A: ");
    scanf("%d %d", &A_rows, &A_cols);

    printf("Enter col B: ");
    scanf("%d", &B_cols);

    float *h_A = (float *)malloc(A_rows * A_cols * sizeof(float));
    float *h_B = (float *)malloc(A_cols * B_cols * sizeof(float));
    float *h_C = (float *)malloc(A_rows * B_cols * sizeof(float));

    printf("Enter elements of Matrix A:\n");
    for (int i = 0; i < A_rows; ++i) {
        for (int j = 0; j < A_cols; ++j) {
            scanf("%f", &h_A[i * A_cols + j]);
        }
    }

    printf("Enter elements of Matrix B:\n");
    for (int i = 0; i < A_cols; ++i) {
        for (int j = 0; j < B_cols; ++j) {
            scanf("%f", &h_B[i * B_cols + j]);
        }
    }

    float *d_A, *d_C;
    cudaMalloc((void **)&d_A, A_rows * A_cols * sizeof(float));
    cudaMalloc((void **)&d_C, A_rows * B_cols * sizeof(float));

    cudaMemcpy(d_A, h_A, A_rows * A_cols * sizeof(float), cudaMemcpyHostToDevice);

    cudaMemcpyToSymbol(d_B, h_B, A_cols * B_cols * sizeof(float));

    dim3 blockDim(16, 16); 
    dim3 gridDim(ceil((float)B_cols / 16), ceil((float)A_rows / 16)); 

    matrixMultiply<<<gridDim, blockDim>>>(d_A, d_C, A_rows, A_cols, B_cols);

    cudaMemcpy(h_C, d_C, A_rows * B_cols * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i = 0; i < A_rows; ++i) {
        for (int j = 0; j < B_cols; ++j) {
            printf("%.2f ", h_C[i * B_cols + j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_C);
    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}


// Enter row A , col A: 4 4
// Enter col B: 4
// Enter elements of Matrix A:
// 1 2 3 4
// 2 3 4 5
// 3 4 5 6
// 4 5 6 7
// Enter elements of Matrix B:
// 9 8 7 6
// 8 7 6 5
// 7 6 5 4
// 5 4 3 2
// Result:
// 66.00 56.00 46.00 36.00 
// 95.00 81.00 67.00 53.00 
// 124.00 106.00 88.00 70.00 
// 153.00 131.00 109.00 87.00