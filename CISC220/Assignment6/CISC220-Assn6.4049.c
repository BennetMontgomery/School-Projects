/****************************************
 *	CISC220 Assignment 6 - BONUS	*
 * Program takes line from file and 	*
 *prints it out word by word, with no	*
 *line exceeding a constant number of 	*
 *characters.				*
 * Bennet Montgomery			*
 * Student ID: 20074049			*
 * 2018-11-26				*
 ****************************************/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

//max length of each line
#define STRING_LENGTH 20

/*PROGRAM ENTRY POINT*/
int main(int argc, char *argv[]) {
	//if wrong number of arguments:
	if(argc != 2) {
		//notifying user of incorrect usage and exiting program
		printf("incorrect number of arguments\n");
		exit(1);
	}
	
	//opening file for reading, using second argument of command as filename 
	char *filename = argv[1];
	FILE *inFile = fopen(filename, "r");
	//if file fails to open:
	if (inFile == NULL) {
		//notifying user that file failed to open and exiting program
		perror("Error while opening file for input\n");
		exit(1);
	}

	//move filestream pointer to EOF
	fseek(inFile, 0, SEEK_END);
	//store position of filestream pointer
	int filelength = ftell(inFile);
	//reset filestream pointer to beginning of file
       	rewind(inFile);

	//inputLine -> entire first line
	//tokens -> list of tokens in first line delimited by spaces
	//readResult -> status of fgets
	char inputLine[filelength];
	char *tokens[filelength];
	char *readResult = fgets(inputLine, filelength, inFile);

	//if reading line was successful: 
	if(readResult != NULL) {
		//tokenizing first line and storing it in tokens array
		tokens[0] = strtok(inputLine, " ");
		for(int i = 1; i < filelength; ++i) {
			tokens[i] = strtok(NULL, " ");
			if(tokens[i] == NULL) {
				break;
			}
		}

		//printing first token
		printf("Input line: %s", tokens[0]);
		int lineused = strlen(tokens[0]);

		//iterating through remaining tokens
		for(int i = 1; i < filelength; ++i) {
			//if no more tokens available:
			if(tokens[i] == NULL) {
				break;
			}
			//if adding token to line will cause line to exceed length:
			if((lineused + strlen(tokens[i]) + 1) <= STRING_LENGTH) {
				//appending token to current line
				printf(" %s", tokens[i]);
				lineused += strlen(tokens[i]) + 1;
			//otherwise:
			} else {
				//start new line
				printf("\nInput line: %s", tokens[i]);
				lineused = strlen(tokens[i]);
			}
		}

		//stating EOF
		printf("\nNo more input\n"); 
	//if file not read successfully:
	} else {
		//if file was empty:
		if(errno == 0) {
			//stating EOF
			printf("No more input\n");
		//otherwise:
		} else {
			//notifying that file was not read successfully and exiting
			perror("error while reading input file\n");
			exit(1);
		}
	}

	return 0;
}
