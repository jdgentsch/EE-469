#include <stdio.h>

int main(void)
{
    float gincome, netincome, taxperc, ssecurity, fedtax, statax;

    printf("Please enter gross income:\n");
    scanf("%f", &gincome);
    getchar();

    printf("Please enter state tax percentage:\n");
    scanf("%f", &taxperc);
    getchar();

    if (gincome >=0 && taxperc >=0 && taxperc <= 100)
    {
        if(gincome >= 65000) {
            ssecurity = 65000*10.3/100;
        } else {
            ssecurity = gincome*10.3/100;
        }

        if (gincome >= 30000) {
            fedtax = 3500 + (gincome-30000)*28/100;
        } else {
            fedtax = 3500;
        }
    } else
    {
        printf("Ooops, invalid input range detected... please try again");
        return 0;
    }

    statax = (gincome)*taxperc/100;
    netincome = gincome - ssecurity - fedtax - statax;

    printf("Your social security due is: %2.2f\n", ssecurity);
    printf("Your federal income tax is: %2.2f\n", fedtax);
    printf("Your state tax is: %2.2f\n", statax);
    printf("Your net income is: %2.2f\n", netincome);

    return 0;

}
