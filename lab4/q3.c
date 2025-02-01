#include<stdio.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int rank,size , a[4][4] , b[4] , par[4];

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	if(rank==0){
		for(int i=0;i<4;i++){
			par[i]=0;
		}
		printf("Enter 4*4 matrix:\n");
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				scanf("%d",&a[i][j]);
			}
		}
	}
	MPI_Scatter(&a , 4 , MPI_INT , &b , 4 , MPI_INT , 0 , MPI_COMM_WORLD);
	MPI_Scan(&b, &par , 4 ,MPI_INT ,MPI_SUM ,MPI_COMM_WORLD);
	fprintf(stdout,"process %d :\n",rank);
	fflush(stdout);
	for(int i=0;i<4;i++){
		fprintf(stdout , "%d\t",par[i]);
		fflush(stdout);
	}
	printf("\n");
	if(rank==0){
		fprintf(stdout,"In 0 ");
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}