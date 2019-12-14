import heapq
import os

#############################
#       ASSIGNMENT 3        #
#   Bennet Montgomery       #
#   Student #: 20074049     #
#   2019-03-18              #
#############################

#Node class of AVLTree
class Node:
    #constructor for Node, takes node key and value 
    def __init__(self, key, value):
        self.key = key
        self.value = value

        #when instantiated, nodes are leaves (height 1)
        self.height = 1
        self.left = None
        self.right = None

#AVLTree class
class AVLTreeMap:
    #constructor for AVLTree
    def __init__(self):
        #instantiating empty root
        self.root = None

    #searchPath returns a list of nodes passed when searching for a node with
    #a specific key
    def searchPath(self, key):
        #starting with empty path at root
        path = []
        currnode = self.root

        #search for node iteratively, building path until node is found
        while currnode != None:
            if currnode.key > key:
                path.append(currnode.key)
                currnode = currnode.left
            elif currnode.key < key:
                path.append(currnode.key)
                currnode = currnode.right
            else:
                path.append(currnode.key)
                #returning built path
                return path

        #returns None if node is not present in the try
        return None

    #getNodeHeight returns the heigh of a given node without ever querying
    #None for height
    def getNodeHeight(self, node):
        if node == None:
            return 0
        else:
            return node.height

    #get returns the value associated with a given key
    def get(self, key):
        #starting at root
        currnode = self.root

        #searching for node iteratively and returning the value when found
        while currnode != None:
            if currnode.key > key:
                currnode = currnode.left
            elif currnode.key < key:
                currnode = currnode.right
            else:
                return currnode.value

        #returning None if no node has the key
        return None

    #getBalance returns the balance at a given node
    def getBalance(self, node):
        result = abs(self.getNodeHeight(node.right) - self.getNodeHeight(node.left))
        return result

    #leftRotate rotates a node left according to AVLTree balancing algorithm
    def leftRotate(self, node):
        #perform rotation
        result = node.right
        t2 = result.left
        node.right = t2
        result.left = node

        #update node heights
        node.height = 1 + max(self.getNodeHeight(node.left), self.getNodeHeight(node.right))
        result.height = 1 + max(self.getNodeHeight(result.left), self.getNodeHeight(result.right))

        #return post-rotation node
        return result
    
    #rightRotate rotates a node right according to AVLTree balancing algorithm
    def rightRotate(self, node):
        #perform rotation
        result = node.left
        t3 = result.right
        node.left = t3
        result.right = node

        #update node heights
        node.height = 1 + max(self.getNodeHeight(node.left), self.getNodeHeight(node.right))
        result.height = 1 + max(self.getNodeHeight(result.left), self.getNodeHeight(result.right))

        #return post-rotation node
        return result

    #pre-order traversal for verification of AVLTree
    def traversal(self, node):
        if node == None:
            return

        print(node.key)
        self.traversal(node.left)
        self.traversal(node.right)

    #updateVal changes the value at a given key 
    def updateVal(self, key, value):
        #starting at root
        current = self.root

        #search for node iteratively
        while current.key != key:
            if current.key < key:
                current = current.right
            else:
                current = current.left

        #update value at found node
        current.value = value

    #put inserts node with a give key and value
    def put(self, key, value, node=0): 
        #if no node is passed, start at root
        if node == 0:
            node = self.root

        #if node is present, update value and exit
        if self.get(key) != None:
            self.updateVal(key, value)
            return self.root

        #search for an appropriate spot according to BST insertion algorithm
        #and insert at spot
        if node == None:
            return Node(key, value)
        elif key < node.key:
            node.left = self.put(key, value, node.left)
        elif key > node.key:
            node.right = self.put(key, value, node.right)

        #update node heights
        node.height = 1 + max(self.getNodeHeight(node.left), self.getNodeHeight(node.right))

        #check each node up the tree from the inserted node for balance and
        #rebalance as appropriate
        if self.getBalance(node) > 1:
            if key > node.key:
                #right-right case
                if key > node.right.key:
                    return self.leftRotate(node)
                #right-left case
                else:
                    node.right = self.rightRotate(node.right)
                    return self.leftRotate(node)
            else:
                #left-left case
                if key < node.left.key:
                    return self.rightRotate(node)
                #left-right case
                else:
                    node.left = self.leftRotate(node.left)
                    return self.rightRotate(node)

        #return post-balancing root
        return node

#WebPageIndex class for 1.3
class WebPageIndex:
    #WPI constructor takes path to webpage
    def __init__(self, path):
        #instantiating path
        self.path = path
        
        #building a string containing all characters in the passed path
        contents = ''

        f = open(path, 'r')
        if f.mode == 'r':
            contents = f.read()
        f.close()

        #converting all characters to lower case
        contents = contents.lower()
        
        #stripping all non-alphanumeric characters
        for i in range(0, len(contents)):
            if i >= len(contents):
                break

            if (not contents[i].isalpha()) and (not contents[i].isspace()):
                contents = contents[:i] + contents[i+1:]
                i = i - 1

        #creating list of words in file
        contentslist = contents.split()

        #building contents tree
        self.avl = AVLTreeMap()
        self.buildAVL(contentslist)

    #buildAVL builds contents tree
    def buildAVL(self, contents):
        #iterating through list and putting every word in AVLTree
        for i in range(0, len(contents)):
            position = [i]

            #if already in AVLTree:
            if self.avl.get(contents[i]) != None:
                #update occurences lsit
                newval = self.avl.get(contents[i]) + position
                self.avl.root = self.avl.put(contents[i], newval)
            #otherwise:
            else:
                #add word to AVLTree
                self.avl.root = self.avl.put(contents[i], position)

    #getCount returns number of occurences of a word on the page
    def getCount(self, s):
        occurences = self.avl.get(s)

        if occurences == None:
            return 0
        else:
            return len(occurences)

#WebpagePriorityQueue for 1.4
class WebpagePriorityQueue:
    #constructor takes query string and list of webpages
    def __init__(self, query, pages):
        #instantiating max heap, query string, pages list
        self.maxheap = []
        self.currquery = query
        self.pagebasis = pages

        #split query into component words
        querywords = query.split()

        #fill maxheap
        for i in range(0, len(pages)):
            priority = 0
            #generating priority sum
            for j in querywords:
                #-= because heapq.heappush puts the SMALLEST values at the top
                #of the heap instead of the largest
                priority -= pages[i].getCount(j)

            #push page onto heap
            heapq.heappush(self.maxheap, (priority, i))

    #peek returns top value on heap
    def peek(self):
        return self.maxheap[0]

    #poll pops top value on heap
    def poll(self):
        return heapq.heappop(self.maxheap)

    #reheap rebuilds WPQ with new query
    def reheap(self, newquery):
        if newquery == currquery:
            return

        self.maxheap = []

        currquery = newquery
        querywords = newquery.split()

        for i in range(0, len(self.pagebasis)):
            priority = 0
            for j in querywords:
                priority -= pagebasis[i].getCount(j)

            heapq.heappush(self.maxheap, (priority, i))

#ProcessQueries from 1.5
class ProcessQueries:
    #constructor takes folder w/ files, path to query file, user specified limit
    def __init__(self, folder, queriespath, userlimit):
        #instantiating filelist, WPI list, queries
        self.filelist = []
        self.pages = self.readFiles(folder)
        self.queries = []
        
        #building query list line by line
        f = open(queriespath)

        query = f.readline()

        while query:
            self.queries.append(query)
            query = f.readline()

        #iterating through queries and processing with WPQ
        self.wpq = None
        for i in self.queries: 
            self.wpq = WebpagePriorityQueue(i, self.pages)
            
            #printing results
            print("\nResults for", i)
            for j in range(0, userlimit):
                print(self.pages[self.wpq.poll()[1]].path)

    #readFiles reads files in folder parameter to a list of WPI
    def readFiles(self, folder):
        result = []

        for f in os.listdir(folder):
            self.filelist.append(os.path.join(folder, f))

        for i in self.filelist:
            wpi = WebPageIndex(i)
            result.append(wpi)

        return result

def main():
    #testing AVLTree with testing values from assignment
    avl = AVLTreeMap()
    print("adding bob")
    avl.root = avl.put(15, 'bob')
    print("adding anna")
    avl.root = avl.put(20, 'anna')
    print("adding tom")
    avl.root = avl.put(24, 'tom')
    print("adding david")
    avl.root = avl.put(10, 'david')
    print("adding david")
    avl.root = avl.put(13, 'david')
    print("adding ben")
    avl.root = avl.put(7, 'ben')
    print("adding karen")
    avl.root = avl.put(30, 'karen')
    print("adding erin")
    avl.root = avl.put(36, 'erin')
    print("adding david")
    avl.root = avl.put(25, 'david')
    print("adding nancy")
    avl.root = avl.put(13, 'nancy') 
    #expected traversal output: 13\n 10\n 7\n 24\n 20\n 15\n 30\n 25\n 36
    avl.traversal(avl.root)

    #insert testing here: parameter 1 = folder with pages, param 2 = query file
    #param 3 = user limit
    pq = ProcessQueries('test data', 'queries.txt', 3)
    

if __name__ == '__main__':
    main()
