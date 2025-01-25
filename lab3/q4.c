#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "mpi.h"
int main(int argc , char* argv[]){
    int M,N,len,ans[100],sum=0;
    int count = 0;
    char str1[100];
    char str2[100];
    char *c;
    char*d;
    char res[100];
    int rank ,size ;
    MPI_Init(&argc , &argv);
    MPI_Comm_rank(MPI_COMM_WORLD , & rank);
    MPI_Comm_size(MPI_COMM_WORLD , &size);
    MPI_Status status;

    if(rank==0){
        printf("Enter string1 in master process:\n");
        scanf("%s" , str1);
        len = strlen(str1);
        printf("Enter string1 in master process:\n");
        scanf("%s" , str2);
        printf("Enter number of process: \n");
        scanf("%d",&N);
        str1[len] = '\0';
        str2[len] = '\0';
    }
    MPI_Bcast(&len , 1 , MPI_INT,0,MPI_COMM_WORLD);
    MPI_Bcast(&N , 1 , MPI_INT,0,MPI_COMM_WORLD);
    c = (char*)malloc(len/N*(sizeof(char)));
    d = (char*)malloc(len/N*(sizeof(char)));
    MPI_Scatter(str1,len/N,MPI_CHAR,c,len/N,MPI_CHAR,0,MPI_COMM_WORLD);
    MPI_Scatter(str2,len/N,MPI_CHAR,d,len/N,MPI_CHAR,0,MPI_COMM_WORLD);
    fprintf(stdout,"process rank:%d\n",rank);
    for(int i=0;i<2*len/N;i=i+2){
        res[i]=c[i/2];
        res[i+1]=d[i/2];
    }
    for(int i=0;i<2*len/N ;i++){
        printf("%c",res[i]);
    }
    
    MPI_Finalize();
    return 0;
} 