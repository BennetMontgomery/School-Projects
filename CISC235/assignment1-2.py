#################################
#   CISC-235 Assignment 1.2     #
# Program tests relative        #
#runtimes of binary and linear  #
#searches.                      #
# Bennet Montgomery             #
# Student#: 20074049            #
# Due Date  2019-01-27          #
#################################

import random
import time

#merge method merges two portions of an array, with elements arrayed in ascending order
def merge(arr, start, mid, end):
    len1 = mid - start + 1
    len2 = end - mid

    left = [0] * (len1)
    right = [0] * (len2)

    for i in range(0, len1):
        left[i] = arr[start + i]

    for j in range(0, len2):
        right[j] = arr[mid + 1 + j]

    i = 0
    j = 0
    k = start
    while i < len1 and j < len2:
        if left[i] <= right[j]:
            arr[k] = left[i]
            i += 1
        else:
            arr[k] = right[j]
            j += 1

        k += 1

    while i < len1:
        arr[k] = left[i]
        i += 1
        k += 1

    while j < len2:
        arr[k] = right[j]
        j += 1
        k += 1

#sort method sorts a target array via mergesort
def sort(arr, start, end):
    if start < end:
        mid = (start + (end - 1))//2

        sort(arr, start, mid)
        sort(arr, mid + 1, end)
        merge(arr, start, mid, end)

#linsearch method performs a linear search on the target array, returning
#True if the target value was found, false otherwise
def linsearch(arr, target):
    for i in arr:
        if i == target:
            return True

    return False

#binserach method performs a binary search on an array presuned sorted, 
#returning True if the target value was found, false otherwise
def binsearch(arr, target, n):
    start = 0
    end = len(arr) - 1

    while start <= end:
        mid = (start + end)//2
        if arr[mid] == target:
            return True
        else:
            if target < arr[mid]:
                end = mid - 1
            else:
                start = mid + 1

    return False


#test array tests binsearch and linsearch on a list to search of size n and a
#target set of size k
def test(n, k):
    #creating test array of random even numbers
    testarr = []
    for i in range(0, n):
        testarr.append(random.randint(1, n)*2)

    #creating a target array, half numbers in test array, half odd numbers
    targetarr = []
    for i in range(0, k//2):
        targetarr.append(testarr[random.randint(1, n - 1)])

    for i in range(k//2, k):
        oddchosen = False
        while not oddchosen:
            oddnum = random.randint(1, n*2)
            if oddnum % 2 == 1:
                targetarr.append(oddnum)
                oddchosen = True

    #recording time to run linear search on test array for all targets
    starttime = time.time()
    for i in targetarr:
        linsearch(testarr, i)
    atime = time.time()
    atime = atime - starttime

    #recording time to run binary search on test array for all targets
    newtime = time.time() 
    sort(testarr, 0, n - 1)
    for i in targetarr:
        binsearch(testarr, i, n)
    btime = time.time()
    btime = btime - newtime
    
    #rerunning test and iterating k if linear search was faster, otherwise
    #returning threshold k
    if atime < btime:
        return test(n, k + 1)
    else:
        return k



def main():
    total = 0
    testnum = 1000
    for i in range(0, testnum):
        total += test(1000, 1)
        
    print("k =", total/testnum "on average for list of size 1000")

    total = 0
    testnum = 1000
    for i in range(0, testnum):
        total += test(2000, 1)
        
    print("k =", total/testnum "on average for list of size 2000")

    total = 0
    testnum = 1000
    for i in range(0, testnum):
        total += test(5000, 1)
        
    print("k =", total/testnum "on average for list of size 5000")

    total = 0
    testnum = 1000
    for i in range(0, testnum):
        total += test(10000, 1)
        
    print("k =", total/testnum "on average for list of size 10000")

if __name__ == "__main__":
    main()
