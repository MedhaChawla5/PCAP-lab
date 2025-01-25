#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "mpi.h"
int main(int argc , char* argv[]){
	int M,N,len,ans[100],sum=0;
	int count = 0;
	char str[100];
	char *c;
	int rank ,size ;
	MPI_Init(&argc , &argv);
	MPI_Comm_rank(MPI_COMM_WORLD , & rank);
	MPI_Comm_size(MPI_COMM_WORLD , &size);
	MPI_Status status;

	if(rank==0){
		printf("Enter the string in master process:\n");
		scanf("%s" , str);
		len = strlen(str);
		printf("Enter number of process: \n");
		scanf("%d",&N);
		str[len] = '\0';
	}
	MPI_Bcast(&len , 1 , MPI_INT,0,MPI_COMM_WORLD);
	MPI_Bcast(&N , 1 , MPI_INT,0,MPI_COMM_WORLD);
	c = (char*)malloc(len/N*(sizeof(char)));
	MPI_Scatter(str,len/N,MPI_CHAR,c,len/N,MPI_CHAR,0,MPI_COMM_WORLD);
	fprintf(stdout,"process rank:%d\n",rank);
	for(int i=0;i<len/N;i++){
		printf("%c\t",c[i]);
	}
	for(int i=0;i<len/N ;i++){
		if(c[i]!='a' && c[i]!='e'&&c[i]!='i' && c[i]!='o'&&c[i]!='u' ){
			count = count+1;
		}
	}
	fprintf(stdout,"process rank %d non-vowels:%d\n",rank,count);
	fflush(stdout);
	MPI_Gather(&count , 1 , MPI_INT , &ans,1,MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0){
		for(int i=0;i<N;i++){
			sum = sum+ans[i];
		}
		fprintf(stdout,"Total non-vowels:%d\n",sum);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}