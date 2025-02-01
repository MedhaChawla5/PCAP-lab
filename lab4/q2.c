#include<stdio.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int rank,size , a[3][3],x ,par=0 , res=0;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	if(rank==0){
		printf("Enter 3*3 matrix:\n");
		for(int i=0;i<3;i++){
			for(int j=0;j<3;j++){
				scanf("%d",&a[i][j]);
			}
		}
		fprintf(stdout,"Enter an element to search for: \n");
		fflush(stdout);
		scanf("%d",&x);
	}
	MPI_Bcast(&x,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Bcast(&a, 9 , MPI_INT , 0 , MPI_COMM_WORLD);
	for(int i = 0 ;i<=2;i++){
		if(a[rank][i]==x){
			par++;
		}
	}
	MPI_Reduce(&par,&res,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	if(rank==0){
		fprintf(stdout,"Total number of occurrence of %d in the matrix is  %d\n",x,res);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}