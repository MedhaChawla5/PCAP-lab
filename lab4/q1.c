#include<stdio.h>
#include "mpi.h"
int main(int argc , char* argv[]){
    int rank,size,fact=1,factsum,i;

    MPI_Init(&argc, &argv);
    MPI_Errhandler_set(MPI_COMM_WORLD,MPI_ERRORS_RETURN);
    MPI_Comm_rank(MPI_COMM_WORLD , &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    for(int i=1;i<=rank+1;i++){
        fact = fact*i;
    }
    fprintf(stdout,"Process %d factorial = %d\n",rank+1,fact);
    fflush(stdout);

    MPI_Scan(&fact,&factsum,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
    fprintf(stdout,"Sum of all the factorial = %d\n",factsum);
    fflush(stdout);
    MPI_Finalize();
    return 0;
} 