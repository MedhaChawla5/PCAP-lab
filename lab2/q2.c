#include<stdio.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int rank , size , x;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter the number in master process:\n");
		scanf("%d" , &x);
		for(int i=1;i<4;i++){
			MPI_Send(&x , 1 , MPI_INT , i , i , MPI_COMM_WORLD);
			printf("Process %d sent %d to process rank %d\n" , rank , x , i);
		}
	}
	else{
		MPI_Recv(&x , 1 , MPI_INT , 0 , rank , MPI_COMM_WORLD , &status);
		fprintf(stdout , "I (process %d) received %d from master process\n" , rank , x );
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}