/************************************************
 *		OPERATOR PROGRAM		*
 * Program for assignment 3 that collects two	*
 *integers from the user and applies the user's *
 *chosen operator to the two.			*
 * Bennet Montgomery				*
 * Student ID 20074049				*
 * 2018-10-23					*
 ************************************************/
#include <stdio.h>

/*CONSTANT DEFINITIONS*/
//defining the boolean type for this program to make flow management easier
typedef int bool;
#define false 0
#define true 1
//defining the logical operators as equivalent to potential valid integer input
#define AND 1
#define OR 2
#define XOR 3

int clearInputBuffer();

/*PROGRAM ENTRY POINT*/
int main() {
	/*DECLARATIONS*/ 
	//flag to determine if the user has exited the program
	bool cont = true;
	//a & b store integer input to operate on
	int a;
	int b;
	//operator stores user selected operator
	int operator;
	//result stores the result of applying the binary operator 
	int result;
	//input code stores the exit code of scanf
	int inputCode;

	//looping until exit code passed by user
	while(cont) {
		//acol - short for 'A collected' switches to true when 'A'
		//is collected with valid input
		bool acol = false;	
		//until 'A' is collected:
		while(!acol) {
			//printing user prompt for A 
			printf("Enter variable 'A': ");
			//scanning for first integer from user 
			inputCode = scanf("%d", &a);
			//clearing input buffer to prevent scanf panic
			clearInputBuffer();
			//if no integers successfully read:
			if(inputCode != 1) {
				//printing to error stream that input must be an integer 
				fprintf(stderr, "error: 'A' must be an integer\n"); 
			//if A does not fall in the input range
			} else if((a < 5 || a > 50) && a != -1) {
				//printing to error stream that A is out of input range
				fprintf(stderr, "error: 'A' must be between 5 and 50 (inclusive)\n");
			} else {
				//if nothing is wrong, flag that A is properly collected 
				acol = true;
			}
		}
		//if user sends termination code:
		if(a == -1) {
			//exit program
			return 0;
		}

		//bcol does for 'B' what acol does for 'A' 
		bool bcol = false;
		//until 'B' is properly collected
		while(!bcol) {
			//prompting the user for the second integer operand 
			printf("Enter variable 'B': ");
			//scanning for second integer from user
			inputCode = scanf("%d", &b);
			//clearing input buffer to prevent scanf panic
			clearInputBuffer();
			//if no integers successfully read:
			if(inputCode != 1) {
				//printing to error stream that 'B' must be an integer
				fprintf(stderr, "error: 'B' must be an integer\n");
			//if 'B' is outside of input range
			} else if((b < 5 || b > 50) && b != -1) {
				//printing to error stream that 'B' is outside of input range
				fprintf(stderr, "error: 'B' must be between 5 and 50 (inclusive)\n");
			//otherwise:
			} else {
				//if nothing is wrong, flag that A is properly collected 
				bcol = true;
			}
		}
		//if user enters termination code: 
		if(b == -1) {
			//exit program
			return 0;
		}

		//opcol does for 'operator' what acol does for 'A' or bcol does for 'B'
		bool opcol = false;	
		//until a valid operator is found:
		while(!opcol) {
			//printing operator table 
			printf("Select operator: \n");
			printf("Enter 1 for A AND B\n");
			printf("Enter 2 for A OR B\n");
			printf("Enter 3 for A XOR B\n");
			//printing operator prompt
			printf(">");
			//scanning for integer input from user
			inputCode = scanf("%d", &operator);
			//clearing input buffer to prevent scanf panic
			clearInputBuffer();
			//if user failed to input an integer
			if(inputCode != 1) {
				//printing to error stream that the opcode must be an integer
				fprintf(stderr, "error: op code must be an integer\n");
			//if user failed to input an integer that's in the opcode range 
			} else if((operator < 1 || operator > 3) && operator != -1) {
				//printing to error stream that the opcode must match a table value
				fprintf(stderr, "error: op code must be between 1 and 3 (inclusive)\n");
			//otherwise
			} else {
				//flag that a valid operation has been passed
				opcol = true;
			}
		}
		//checking which operator has been chosen and outputting the result:
		if(operator == AND) {
			result = a & b;
			printf("%d AND %d = %d\n", a, b, result);
		} else if(operator == OR) {
			result = a | b;
			printf("%d OR %d = %d\n", a, b, result);
		} else if(operator == XOR) {
			result = a ^ b;
			printf("%d XOR %d = %d\n", a, b, result);
		//if the user has chosen the exit code
		} else if(operator == -1) {
			//set continue flag to false
			cont = false;
		}
	}
}

/*CLEAR INPUT BUFFER FUNCTION
 * Prevents scanf panic by flushing the input stream
 */
int clearInputBuffer() {
	int bufferFlush;
	while((bufferFlush = getchar()) != '\n' && bufferFlush != EOF); 
}
