#include<stdio.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int rank , size , x;
	int res;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter the number in master process:\n");
		scanf("%d" , &x);
		MPI_Ssend(&x , 1 , MPI_INT , 1 , 1 , MPI_COMM_WORLD);
		fprintf(stdout , "Master process sent %d \n" , x);
		fflush(stdout);
	}
	else{
		MPI_Recv(&x , 1 , MPI_INT , rank-1 , rank , MPI_COMM_WORLD , &status);
		fprintf(stdout , "I (process %d) received %d from master process , Result : %d\n" , rank , x , x+1);
		fflush(stdout);
		x = x+1;
		if(rank==4){
			MPI_Ssend(&x , 1 , MPI_INT , 0 , 0 , MPI_COMM_WORLD);
		}
		else{
		MPI_Ssend(&x , 1 , MPI_INT , rank+1 , rank+1 , MPI_COMM_WORLD);}
	}
	if(rank==0){
		MPI_Recv(&x , 1 , MPI_INT , 4 , 0 , MPI_COMM_WORLD , &status);
		fprintf(stdout , "Final process sent %d to root process\n",x);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}