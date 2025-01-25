#include<stdio.h>
#include<stdlib.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int M,N,avgf;
	int B[100];
	int rank ,size ,*a ,avg ,sum=0 ;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter M values:\n");
		scanf("%d",&M);
		printf("Enter number of process: \n");
		scanf("%d",&N);
		a = (int*)malloc(M*N*(sizeof(int)));
		printf("Enter %d elements in the array:\n",M*N);
		for(int i = 0;i<M*N;i++){
			scanf("%d",&a[i]);
		}
	}
	MPI_Bcast(&M , 1 , MPI_INT,0,MPI_COMM_WORLD);
	int c[M];
	MPI_Scatter(a,M,MPI_INT,&c,M,MPI_INT,0,MPI_COMM_WORLD);
	for(int i=0;i<M;i++){
		sum = sum+c[i];
	}
	avg = sum/M;
	fprintf(stdout , "(process rank %d) resultant avg : %d\n" , rank , avg);
	fflush(stdout);
	MPI_Gather(&sum , 1,MPI_INT,&B , 1 , MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0){
		sum = 0;
		for(int i=0;i<N;i++){
			sum = sum+B[i];
		}
		avgf = sum/(M*N);
		fprintf(stdout , "Final avg at process 0 : %d\n" , avgf);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}