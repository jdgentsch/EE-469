//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: C Program
//EE 469 with James Peckol 4/8/16

#include <stdio.h>

#define S2L 4791 // air miles from Seattle to London
#define HEAD_WIND 89.6 // head wind speed in mph

//  function prototypes

float getDuration(void);

float computeVel(float duration);

float computeTime(float velocity);

int printFlightTime(float time);

// the main program
int main(void)
{
	float duration = getDuration();

	while (duration <= 0)
	{
		printf("Invalid flight duration. Please try again!\n");
		duration = getDuration();
	}

	float velocity = computeVel(duration);
	float flightTime = computeTime(velocity);
	printFlightTime(flightTime);

	return 0;
}

// prompts user for the duration of a nonstop flight to London from Seattle
// in hours as a floating point number
float getDuration(void)
{
	float duration = 0;

	printf("What is the duration (hours) of flight to London from Seattle?\n");
	scanf("%f", &duration);
	getchar();

	return duration;
}

// computes and prints the estimated velocity of the aircraft in mph as a
// floating point number
float computeVel(float duration)
{
	float velocity = S2L / duration;

	printf("The estimated velocity of the aircraft is %.2f MPH\n", velocity);

	return velocity;
}

// computes the estimated duration of flight in mph as a floating number
// and takes head wind into account for the calculation
float computeTime(float velocity)
{
	float flightTime = S2L / (velocity - HEAD_WIND);

	return flightTime;
}

// prints the estimated duration of flight in mph
int printFlightTime(float time)
{
	printf("With a head wind of %.2f MPH, the estimated flight duration is "
           "%.2f hour(s).", HEAD_WIND, time);

	return 0;
}
