#include <stdio.h>
#include "mpi.h"

int main(int argc , char* argv[]){
int rank , size;
MPI_Init(&argc , &argv);
MPI_Comm_rank(MPI_COMM_WORLD , &rank);
MPI_Comm_size(MPI_COMM_WORLD , &size);
int x = 5;
int y = 8;
int ans;
switch (rank){
case 0 : 
	ans = x+y;
	printf("process rank %d , Addition : %d\n",rank , ans);
	break;
case 1 :
	ans = x-y;
	printf("process rank %d , Subtraction : %d\n",rank , ans);
	break;
case 2 :
	ans = x*y;
	printf("process rank %d , Multiplication : %d\n",rank , ans);
	break;
case 3 :
	ans = x/y;
	printf("process rank %d , Division : %d\n",rank , ans);
	break;
}
MPI_Finalize();
return 0;
}
