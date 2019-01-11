/********************************
 *	ASSIGNMENT 4 PROGRAM	*
 * Program randomly generates an*
 *array of length 7, and	*
 *performs a bubble sort on the *
 *result, printing out each pass*
 *through to stdout.		*
 * Bennet Montgomery		*
 * Student ID: 20074049		*
 * 2018-11-12			*
 ********************************/
#include <stdio.h>
#include <stdlib.h>

//defining boolean type for later use, with boolean equivalent to integer with
//possible values 'true' (1) and 'false' (0)
typedef int bool;
#define true 1
#define false 0
//defining a constant number of elements to generate
#define NUMELEMENTS 7

//passing forward functions to allow referencing of not yet declared functions
void generateArray(int* array);
void swap(int* a, int* b);
bool compare(int* a, int* b);
bool sorted(int* array);
void printArrayContents(int* array);

/*PROGRAM ENTRY POINT*/
int main() {
	//DECLARATIONS
	// iterations: number of pass throughs on the array thus far
	int iterations = 0;
	// array: array to be sorted
	int array[NUMELEMENTS];

	//filling array with random integers
	generateArray(&array);
	
	//outputting random array
	printArrayContents(&array);
	printf("Randomly generated Array\n\n");

	//sorting with the following (bubble sort) algorithm:
	//until the array is sorted:
	while(!sorted(&array)) {	
		//iterate through the unsorted elements of the array
		//	NOTE: last n elements are in a sorted position where n
		//		is the number of pass throughs
		for(int i = 1; i < (NUMELEMENTS - iterations); ++i) {
			//if an element is greater than the element after:
			if(compare(&array[i - 1], &array[i])) {
				//swap the elements
				swap(&array[i - 1], &array[i]);
			}
		}

		//increase the number of iterations, sorted elements
		iterations++;
		//print the array contents
		printArrayContents(&array);	
		printf("Iteration No. %d\n", iterations);
	}

	//printing contents of sorted array
	printf("\n");
	printArrayContents(&array);
	printf("Sorted Final Array\n");
}

/**
 * generateArray takes an integer array and fills it with NUMELEMENTS random
 * elements with a minimum value of 1 and a maximum value of 99
 */
void generateArray(int* array) {	
	//seeding random number generator
	srand((unsigned) time(NULL));

	//filling array with NUMELEMENTS random elements
	for(int i = 0; i < NUMELEMENTS; ++i) {
	       array[i] = (rand() % 99) + 1;
	}
}

/**
 * swap takes two integer pointers and swaps the values at their stored
 * addresses
 */
void swap(int* a, int* b) {
	int c = *a;
	*a = *b;
	*b = c;
}

/**
 * compare takes two integers a and b and returns true if a is greater than b
 * and false otherwise
 */
bool compare(int* a, int* b) {
	if(*a > *b) {
		return true;
	} else {
		return false;
	}
}

/**
 * sorted takes an array and returns false if any two neighbouring elements are
 * out of order, otherwise it returns true 
 */
bool sorted(int* array) {
	for(int i = 1; i < NUMELEMENTS; ++i) {
		if(compare(&array[i - 1], &array[i])) {
			return false;
		}
	}

	return true;
}

/**
 * printArrayContents prints the values in an array to stdout with a tab
 * seperator between elements
 */
void printArrayContents(int* array) {
	for(int i = 0; i < NUMELEMENTS; ++i) {
		printf("%d\t", array[i]);
	}
}
