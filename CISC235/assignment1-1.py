#####################################
#   CISC-235 Assignment 1.1 "Bag"   #
# Program implements a container    #
#using tools provided by standard   #
#python3 libraries.                 #
# Bennet Montgomery                 #
# Student#: 20074049                #
# Due date: 2019-01-16              #
#####################################

#importing random to use for grabbing random container items
import random

#object abstraction of bag
class Bag:
    #bag constructor initializes container for items
    def __init__(self):
        self.container = []

    #adds item to end of container list
    def add(self, item):
        self.container.append(item)

    #removes item from end of container list
    def remove(self, item):
        self.container.remove(item)

    #checks if container contains a given item
    def contains(self, item):
        #iterating through contents of container
        for i in self.container:
        #if item is found in container
            if i == item:
                #notifying user that container contains item
                print("Bag contains", item)
                return
        #if item is not found, notifying user that container doesn't contain item
        print("Bag does not contain", item) 

    #returns current size of container
    def numItems(self):
        return len(self.container)

    #returns random item from container
    def grab(self):
        #seeding random generator with current time
        random.seed()
        #shaking container
        random.shuffle(self.container)
        #returning container's first element
        return random.sample(self.container, 1)

    #ouptuts container contents in formatted list
    def __str__(self):
        print("Bag contains:", end=" ")
        for i in self.container:
            print(i, end=" ")

        print()

#tests
def main():
    #initializing bag
    bag = Bag()

    #adding 3 items to bag of different types
    bag.add(1)
    bag.add('q')
    bag.add([1.0, 3.5, 1.9])
    #printing bag contents (expected output: "Bag contains: 1 q [1.0 3.5 1.9]")
    bag.__str__()
    #printing number of items in bag (expected output: "Bag contains 3 items")
    print("Bag contains", bag.numItems(), "items")
    #adding string "bad" to bag
    bag.add("bad")
    #printing bag contents (expected output: "Bag contains: 1 q [1.0 3.5 1.9] bad")
    bag.__str__()
    #printing number of items in bag (expected output: "Bag contains 4 items")
    print("Bag contains", bag.numItems(), "items")

    #removing string "bad" from bag
    bag.remove("bad")
    #printing bag contents (expected output: "Bag contains: 1 q [1.0 3.5 1.9]")
    bag.__str__()
    #printing number of items in bag (expected output: "Bag contains 3 items")
    print("Bag contains", bag.numItems(), "items")

    #checking if bag contains char 'q' (expected output: "Bag contains q")
    bag.contains('q')
    #checking if bag contains "bad" (expected output: "Bag does not contain bad")
    bag.contains("bad")

    #grabbing random item from the bag
    print(bag.grab()[0])

if __name__ == '__main__':
    main()
