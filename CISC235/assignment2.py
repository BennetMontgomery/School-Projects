#########################################
#   ASSIGNMENT 2: BINARY SEARCH TREE    #
# Contains a binary search tree data    #
#structure supported by a node class.   #
#binary search tree can be read from an #
#accompanying text file (test.txt). Also#
#contains a stack data structure, used  #
#by binary search tree for construction #
#from file input.                       #
#   Bennet Montgomery                   #
#   Student ID: 20074049                #
#   2019-02-25                          #
#########################################

#stack class, used by bst during construction
class Stack:
    #stack initializes empty
    def __init__(self):
        self.container = []

    #isEmpty returns True if no elements are on the stack, False otherwise
    def isEmpty(self):
        if self.size() == 0:
            return True
        else:
            return False

    #push adds item to stack
    def push(self, item):
        self.container.append(item)

    #pop pops item from top of stack
    def pop(self):
        val = self.container[-1]
        self.container = self.container[:-1]
        return val

    #top peeks at item on top of stack
    def top(self):
        return self.container[-1]

    #size returns current height of stack
    def size(self):
        return len(self.container)

#node class represents each individual node on the bst
class Node:
    #node initializes with a set value and depth and no children
    def __init__(self, value, depth):
        self.value = value
        self.leftChild = None
        self.rightChild = None
        self.depth = depth

    #setter for left child
    def setLeftChild(self, node):
        self.leftChild = node

    #setter for right child
    def setRightChild(self, node):
        self.rightChild = node

    #setter for node value
    def setValue(self, val):
        self.value = val
    
    #setter for node depth
    def setDepth(self, dpth):
        self.depth = dpth

    #getter for node value
    def getValue(self):
        return self.value

    #getter for left child
    def getLeftChild(self):
        return self.leftChild

    #getter for right child
    def getRightChild(self):
        return self.rightChild

    #getter for node depth
    def getDepth(self):
        return self.depth

    #updateDepths increases the depth of the current node and all nodes in
    #child trees by 1. Used during tree construction
    def updateDepths(self):
        self.setDepth(self.getDepth() + 1)
        if self.getLeftChild() != None:
            self.getLeftChild().updateDepths()
        if self.getRightChild() != None:
            self.getRightChild().updateDepths()

#binary search tree class, abstract representation of data structure
class BinarySearchTree:
    #bst initializes with no nodes
    def __init__(self):
        self.rootNode = None

    #insert adds a node with value val to bst
    def insert(self, val): 
        #if no nodes already exist
        if self.rootNode == None:
            #creating new bst root
            self.rootNode = Node(val, 0)
        #otherwise
        else:
            #starting from the root node, checking if value belongs to the left
            #or right of each node in the tree, settling if there is a free
            #spot available at that node
            parentNode = self.rootNode
            depth = 1
            created = False
            while not created:
                if val < parentNode.getValue():
                    if parentNode.getLeftChild() == None:
                        parentNode.setLeftChild(Node(val, depth))
                        created = True
                    else:
                        parentNode = parentNode.getLeftChild()
                else:
                    if parentNode.getRightChild() == None:
                        parentNode.setRightChild(Node (val, depth))
                        created = True
                    else:
                        parentNode = parentNode.getRightChild()

                depth += 1 

    #searchPath searches the tree for a specific value and returns the path
    #taken during the search
    def searchPath(self, target):
        #starting with an empty search list
        searchList = []
        #starting at the root, going to the right node if greater than the current
        #node and going to the left node if less than the current node
        currNode = self.rootNode
        while currNode.getValue() != target:
            searchList.append(currNode.getValue())
            if target < currNode.getValue():
                currNode = currNode.getLeftChild()
            elif target > currNode.getValue():
                currNode = currNode.getRightChild()
            #if we target is missing from tree
            elif currNode == None:
                #throw valueerror: invalid target
                raise ValueError("Invalid target value")

        #adding target to end of list to complete path
        searchList.append(target)
        
        return searchList
    
    #get total depth recursively finds the total depth of a given node,
    #starting at the root node
    def getTotalDepth(self, node=0):
        if node == 0:
            node = self.rootNode
        
        if node == None:
            return 0
        else:
            return node.getDepth() + self.getTotalDepth(node.getRightChild()) + self.getTotalDepth(node.getLeftChild())

    #numNodes acts as a helper function for getWeightBalanceFactor. Returns
    #the number of nodes in all child trees of the current node including the
    #current node
    def numNodes(self, node):
        if node == None:
            return 0
        else:
            return 1 + self.numNodes(node.getRightChild()) + self.numNodes(node.getLeftChild())

    #getWeightBalanceFactor returns the weight balance factor of the bst.
    #Function finds the balance at the current node and the maximum balance of
    #the two child nodes (if they exist), and returns the largest one.
    def getWeightBalanceFactor(self, node=0):
        #starting at root
        if node == 0:
            node = self.rootNode

        #if node doesn't exist 
        if node == None:
            #wbf at non-existant node is 0
            return 0
        #otherwise
        else:
            #finding wbf of current node and both child nodes
            maxfactor = abs(self.numNodes(node.getLeftChild()) - self.numNodes(node.getRightChild()))
            leftfactor = self.getWeightBalanceFactor(node.getLeftChild())
            rightfactor = self.getWeightBalanceFactor(node.getRightChild())
            
            #finding maximum wbf of the three
            if maxfactor < leftfactor:
                maxfactor = leftfactor

            if maxfactor < rightfactor:
                maxfactor = rightfactor

            return maxfactor

    #loadTreeFromFile opens a file and parses the lines into a bst
    def loadTreeFromFile(self, filepath):
        #opening file stream
        fil = open(filepath, "r")
        #splitting file by lines
        linereader = fil.readlines()

        #implementation of algorithm from assignment page 3:
        treestack = Stack()
        for line in linereader:
            tags = line.split()
            for i in range(0, len(tags)):
                tags[i] = int(tags[i])

            lefttree = None
            righttree = None
            if(tags[2] == 1):
                righttree = treestack.pop()
                righttree.updateDepths()
                
            if(tags[1] == 1):
                lefttree = treestack.pop()
                lefttree.updateDepths()

            newtree = Node(tags[0], 0)
            newtree.setLeftChild(lefttree)
            newtree.setRightChild(righttree)
            treestack.push(newtree)

        #loading resulting tree into bst
        self.rootNode = treestack.pop()
        #closing file stream
        fil.close()

#test code for bst implementation
def main():
    #initializing bst
    bst = BinarySearchTree()

    #loading bst from test.txt
    print("loading tree from test file (test.txt)")
    bst.loadTreeFromFile("test.txt")

    #printing current depth and wbf
    #expected output:
    #"depth: 8 \n
    #weight balance factor: 1"
    print("depth:", bst.getTotalDepth())
    print("weight balance factor:", bst.getWeightBalanceFactor())
    
    #inserting new value into bst 
    bst.insert(5)
    #searching bst for inserted value
    try:
        #expected output:
        #"search path for 5: [8, 4, 7, 5]
        print("search path for 5:", bst.searchPath(5))
    except ValueError as err:
        print(err.args)

    #printing new depth and wbf after insertion
    #expected output:
    #"depth: 11 \n
    #weight balance factor: 2"
    print("depth:", bst.getTotalDepth())
    print("weight balance factor:", bst.getWeightBalanceFactor())

if __name__ == '__main__':
    main()
