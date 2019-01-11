/****************************************
 *	CISC220 ASSIGNMENT 5 PROGRAM	*
 * Program creates a Stack struct built	*
 *upon a custom linked list type, which *
 *is in turn based upon a custom node	*
 *type. The stack can have a maximum of *
 *three strings pushed to or popped from*
 *it.					*
 * Bennet Montgomery			*
 * Student ID: 20074049			*
 * 2018-11-19				*
 ****************************************/
#include <stdio.h>
#include <stdlib.h>

/**
 * listnode struct:
 * Used by the LinkedList type to represent elements of the linked list
 */
typedef struct node {
	//value string stores element ID
	char *value;
	//next pointer points to next node in the linked list
	struct node *next;
} listnode;

/**
 * LinkedList custom type:
 * Used by Stack struct to store the elements of the stack
 */
typedef struct node *LinkedList;

/**
 * Stack Struct:
 * Custom Stack struct that values are pushed to or popped from
 */
typedef struct {
	//current number of elements on the stack (stack height)
	int height;
	//linked list pointing to the elements currently on the stack
	LinkedList contents; 
} Stack; 

//passing forward functions for predeclaration reference
void push(Stack *stack, char *val);
void pop(Stack *stack);
void printStatus(Stack *stack);

/*PROGRAM ENTRY POINT*/
int main() {
	//instantiating stack
	Stack stack;
	//creating pointer to stack
	Stack *stackptr = &stack;
	
	//setting initial stack height (no elements)
	stack.height = 0;
	printf("Creating a stack that can take only 3 string elements\n");	
	//instantiating string to push to stack
	char *value = "First Element";
	printf("Pushing\n");
	//pushing first element to the stack
	push(&stack, value);
	//printing stack contents
	printStatus(&stack);
	//setting second string to push to stack
	value = "Second Element";
	printf("Pushing\n");
	//pushing second element to the stack
	push(&stack, value);
	//printing stack contents
	printStatus(&stack);
	//setting third string to push to stack
	value = "Third Element";
	printf("Pushing\n");
	//pushing third element to the stack
	push(&stack, value);
	//printing stack contents
	printStatus(&stack);
	//setting fourth string to push to stack
	value = "Fourth Element";
	printf("Pushing\n");
	//pushing fourth element to the stack (unsuccessfully)
	push(&stack, value);
	
	//iterating through stack and popping all elements
	for(int i = 0; i < 3; ++i) {
		printf("Popping\n");
		pop(&stack);
		printStatus(&stack);
	}
	
	printf("Popping\n");
	//popping fourth element from stack (unsuccessfully)
	pop(&stack);

	printf("End of program\n");
}

/**
 * push takes a stack and a string, and pushes the string to the stack
 */
void push(Stack *stack, char *val) {
	//if stack is empty:
	if(stack->height == 0) {
		//setting up stack list	
		stack->contents = NULL;
		//allocating memory for bottom element of stack
		stack->contents = malloc(sizeof(listnode));
		//setting value of bottom element
		stack->contents->value = val;
		//setting up next element in stack
		stack->contents->next = NULL;
		//increasing stack height to 1
		stack->height++;
	//if stack has an element:
	} else if(stack->height == 1) {
		//allocating memory for second element of stack
		stack->contents->next = malloc(sizeof(listnode));
		//setting value of second element
		stack->contents->next->value = val;
		//setting up next element in stack
		stack->contents->next->next = NULL;
		//increasing stack height to 2
		stack->height++;
	//if stack has two elements:
	} else if(stack->height == 2) {
		//allocating memory for third element of stack
		stack->contents->next->next = malloc(sizeof(listnode));
		//setting value of third element
		stack->contents->next->next->value = val;
		//setting up next element in stack
		stack->contents->next->next->next = NULL;
		//increasing stack height to 3
		stack->height++;
	//if stack has three elements
	} else if(stack->height == 3) {
		//printing notification that stack is full
		printf("The stack is full and cannot take any more elements.\n");
	}
}
 
/**
 * pop takes a stack, and pops the top element off it
 */
void pop(Stack *stack) {
	//if stack has no elements:
	if(stack->height == 0) {
		//printing notfication that stack is empty
		printf("Cannot pop an empty stack\n");
	//if stack has one element:
	} else if(stack->height == 1) {
		//free memory reserved for stack 
		free(stack->contents);
		//reset stack
		stack->contents = NULL;
		//setting stack height to 0
		stack->height--;
	//if stack has two elements:
	} else if(stack->height == 2) {
		//freeing second element space
		free(stack->contents->next);
		//resetting second element
		stack->contents->next = NULL;
		//setting stack height to 1
		stack->height--;
	//if stack has three elements:
	} else if(stack->height == 3) {
		//freeing third element space
		free(stack->contents->next->next);
		//resetting third element
		stack->contents->next->next = NULL;
		//setting stack height to 2
		stack->height--;
	}
}

/**
 * printStatus takes a stack and prints the contents of the stack, with the
 * bottom element on the left, top element on the right
 */
void printStatus(Stack *stack) {
	//if stack is not empty:
	if(stack->height > 0) {
		//printing stack status prefix + first element
		printf("The stack status: { \"%s\"", stack->contents->value);
		//iterating through stack from bottom to top
		listnode *currnode = stack->contents->next;
		while(currnode != NULL) {
			//printing current node value
			printf(", \"%s\"", currnode->value);
			currnode = currnode->next;
		}
		//printing stack status suffix
		printf(" }\n");
	//if stack is empty:
	} else {
		//printf notification that stack is empty
		printf("The stack is empty\n");
	}
}
