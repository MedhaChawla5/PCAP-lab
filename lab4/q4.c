#include<stdio.h>
#include "mpi.h"
#include<string.h>
#include<stdlib.h>
int main(int argc , char* argv[]){
    int rank,size,n,len;
    char str[100];
    char c;
    char *par;
    char res[100];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD , &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(rank==0){
        printf("Enter the length of word:\n");
        scanf("%d",&n);
        printf("Enter the word:\n");
        scanf("%s",str);
        len = strlen(str);
        str[len] = '\0';
    }
    MPI_Scatter(str , 1 , MPI_CHAR , &c ,1,MPI_CHAR , 0 ,MPI_COMM_WORLD);
    par = (char*)malloc((rank+1)*(sizeof(char)));
    for(int i=0;i<(rank+1);i++){
        par[i] = c;
    }
    

    for(int i=0;i<(rank+1);i++){
        fprintf(stdout,"%c",par[i]);
        fflush(stdout);
    }
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Finalize();
    return 0;
}