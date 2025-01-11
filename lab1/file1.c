#include <stdio.h>
#include "mpi.h"
#include<math.h>

int main(int argc , char* argv[]){
int rank , size;
MPI_Init(&argc , &argv);
MPI_Comm_rank(MPI_COMM_WORLD , &rank);
MPI_Comm_size(MPI_COMM_WORLD , &size);
int x = 2;
int ans = pow(x , rank);
printf("My rank is %d and power of process is %d\n", rank , ans);
MPI_Finalize();
return 0;
}
