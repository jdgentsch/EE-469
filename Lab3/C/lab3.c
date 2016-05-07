//Jack Gentsch Jacky Wang Chinh Bui
//EE 469 Peckol 4/28/16
//A simple program to manage pointers and operate on the data
#include <stdio.h>
#include <stdlib.h>

int main()
{
    int A = 25;
    int B = 16;
    int C = 7;
    int D = 4;
    int E = 9;
    int result;
    // assign address of variables to pointers
    int* A_Ptr = &A;
    int* B_Ptr = &B;
    int* C_Ptr = &C;
    int* D_Ptr = &D;
    int* E_Ptr = &E;
    // calculate result using dereference
    result = ((*A_Ptr - *B_Ptr)*(*C_Ptr + *D_Ptr))/ *E_Ptr;
    printf("The result is %i\n", result);
    return 0;
}
