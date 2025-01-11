#include<stdio.h>
#include "mpi.h"
#include<string.h>

int main(int argc , char* argv[]){
	int rank , size ;
	char str[100];
	char new[100];
	int len;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter the string in master process:\n");
		scanf("%s" , str);
		len = strlen(str);
		MPI_Ssend(&len , 1 , MPI_INT , 1 , 1 , MPI_COMM_WORLD);
		MPI_Ssend(&str , len , MPI_CHAR , 1 , 2 , MPI_COMM_WORLD);
		fprintf(stdout , "Master process sent %s \n" , str);
		fflush(stdout);
		MPI_Recv(&new , len , MPI_CHAR , 1 , 3 , MPI_COMM_WORLD , &status);
		fprintf(stdout , "Toggled string received at main process : %s\n",new);
		fflush(stdout);
	}
	else{
		MPI_Recv(&len , 1 , MPI_INT , 0 , 1 , MPI_COMM_WORLD , &status);
		MPI_Recv(&str , len , MPI_CHAR , 0 , 2 , MPI_COMM_WORLD , &status);
		for(int i=0;i<len;i++){
			if(str[i]<97){
				new[i] = str[i]+32;
			}
			else{
				new[i] = str[i]-32;
			}
		}
		fprintf( stdout , "I (process rank %d ) received string %s from master process\n " , rank , str );
		fflush(stdout);
		MPI_Ssend(&new , len , MPI_CHAR , 0 , 3 , MPI_COMM_WORLD);
	}
	MPI_Finalize();
	return 0;
}