// EE 371
// Coders: Jack Gentsch, Jacky Wang
// Autumn 2015
// Lab 1
#include <stdio.h>

int main(void)
{
	float carCost = 0.0;

	float markup   = 0.0;
	float markupVal = 0.0;

	float salesTax = 0.0;
	float salesTaxVal = 0.0;

	float discount = 0.0;
    float discountVal = 0.0;

	float listPrice = 0.0;

	// ask the user for car price
	printf("Please tell us the manufacturer's cost for the car.\n");

	// get the data from the user
	// the data will be a floating point number: %f
	// stored in the variable 'carCost'
	scanf("%f", &carCost);

    while (carCost <= 0){
        printf("You ain't getting this car for free! \n");
        printf("\nPlease tell us the manufacturer's cost.\n");
        scanf("%f", &carCost);
    }

	// ask the user for dealer's markup rate
	printf("\nWhat is an estimated dealer's markup rate? (0 to 100 percent) \n");
	scanf("%f", &markup);

	while (markup < 0 || markup > 100){
        printf("Invalid markup rate range! \n");
        printf("\nWhat is an estimated dealer's markup rate? (0 to 100 percent) \n");
        scanf("%f", &markup);
	}

	markupVal = carCost * (markup / 100);

	// ask the user for sales tax rate
	printf("\nWhat is the sales tax rate? (0 to 100 percent) \n");
	scanf("%f", &salesTax);

	while (salesTax < 0 || salesTax > 100){
        printf("Invalid sales tax rate range! \n");
        printf("\nWhat is the sales tax rate? (0 to 100 percent) \n");
        scanf("%f", &salesTax);
	}

	salesTaxVal = (carCost + markupVal) * (salesTax / 100);

	// ask the user for pre tax discount rate
	printf("\nWhat is the pre tax discount? (0 to 100 percent) \n");
	scanf("%f", &discount);

	while (discount < 0 || discount > 100){
        printf("Invalid discount rate range! \n");
    	printf("\nWhat is the pre tax discount? (0 to 100 percent) \n");
        scanf("%f", &discount);
	}

	discountVal = (carCost + markupVal) * (discount / 100);

	// Final Calculation
	listPrice = carCost + markupVal + salesTaxVal - discountVal;

	// print the list price for car
	// with the format of xx.yy
	// displays error message if listPrice is a negative value

    printf("\nYour estimated car list price is $%.2f \n", listPrice);

	return 0;
}
