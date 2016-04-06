// Net Income Calculator
// netIncome.c

#include <stdio.h>

int main(void)
{
    float gincome = -1;
    float taxperc = 110;
    float netincome, ssecurity, fedtax, statax;
    float statax_check = 2;

    while (gincome < 0)
    {
        printf("Please enter a positive gross income: ");
        scanf("%f", &gincome);
        getchar();
    }

    while (statax_check != 0 && statax_check != 1)
    {
        printf("Does your state has an income tax rate? (Y=1, N=0) ");
        scanf("%f", &statax_check);
    }

    if (statax_check == 1)
    {
        while (taxperc > 100 || taxperc < 0)
            {
                printf("Please enter state tax percentage [0-100]: ");
                scanf("%f", &taxperc);
            }
    } else if (statax_check == 0)
        {
            taxperc = 0;
        }

    if (gincome >= 65000)
    {
        ssecurity = 65000*10.3/100;
    } else ssecurity = gincome*10.3/100;


    if (gincome >= 30000)
    {
        fedtax = 3500 + (gincome-ssecurity-30000)*28/100;
    } else fedtax = 3500;

    statax = (gincome-ssecurity)*taxperc/100;
    netincome = gincome - ssecurity - fedtax - statax;

    printf("Your social security due is: %2.2f\n", ssecurity);
    printf("Your federal income tax is: %2.2f\n", fedtax);
    printf("Your state tax is: %2.2f\n", statax);
    printf("Your net income is: %2.2f\n", netincome);

    return 0;
}
