#include<stdio.h>
#include "mpi.h"
#include<math.h>
int main(int argc , char* argv[]){
	int rank , size ;
	int a[100];
	int len;
	int res;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter the length of the array:\n");
		scanf("%d" , &len);
		printf("Enter elements of the array:\n");
		for(int i=0;i<len;i++){
			scanf("%d",&a[i]);
		}
		for(int i=1;i<len;i++){
			MPI_Send(&a[i] , 1 , MPI_INT , i , i , MPI_COMM_WORLD);
		}
		res = pow(a[rank] ,2);
		fprintf(stdout , "Process rank : %d , Read value : %d , Result : %d\n" , rank , a[rank] , res);
		fflush(stdout);
	}
	if(rank%2==0 && rank!=0){
		MPI_Recv(&a[rank] , 1 , MPI_INT , 0 , rank , MPI_COMM_WORLD , &status);
		res = pow(a[rank] ,2);
		fprintf(stdout , "Process rank : %d , Read value : %d , Result : %d\n" , rank , a[rank] , res);
		fflush(stdout);
	}
	if(rank%2!=0){
		MPI_Recv(&a[rank] , 1 , MPI_INT , 0 , rank , MPI_COMM_WORLD , &status);
		res = pow(a[rank] ,3);
		fprintf(stdout , "Process rank : %d , Read value : %d , Result : %d\n" , rank , a[rank] , res);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}