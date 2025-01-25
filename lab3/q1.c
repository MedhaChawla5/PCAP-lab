#include<stdio.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int rank , a[5] , c ,size , sum[5] , fact = 1 , s=0;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter 5 values:\n");
		for(int i=0;i<5;i++){
			scanf("%d",&a[i]);
		}
	}
	MPI_Scatter(a,1,MPI_INT,&c,1,MPI_INT,0,MPI_COMM_WORLD);
	for(int i=c ; i>=1 ;i--){
		fact = fact*i;
	}
	fprintf(stdout , "(process rank %d) received %d from process 0 and factorial: %d\n" , rank , c ,fact);
	fflush(stdout);
	MPI_Gather(&fact , 1 , MPI_INT , sum , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
	if(rank==0){
		for(int i=0;i<5;i++){
			s = s+sum[i];
		}
		fprintf(stdout , "The Result gathered in the root process :%d\n",s);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}