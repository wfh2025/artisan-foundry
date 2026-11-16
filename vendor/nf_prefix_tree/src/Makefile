# Variables 
CC = g++
CFLAGS = -Wall -g -std=c++11

# Executable
main: main.o PrefixTree.o TreeNode.o 
	$(CC) $(CFLAGS) -o main main.o PrefixTree.o TreeNode.o 

test: test.o PrefixTree.o TreeNode.o 
	$(CC) $(CFLAGS) -o test test.o PrefixTree.o TreeNode.o 

# Object files
main.o: main.cpp PrefixTree.hpp
	$(CC) $(CFLAGS) -c main.cpp

test.o: test.cpp PrefixTree.hpp
	$(CC) $(CFLAGS) -c test.cpp

PrefixTree.o: PrefixTree.hpp TreeNode.hpp
	$(CC) $(CFLAGS) -c PrefixTree.cpp 

TreeNode.o: TreeNode.hpp 
	$(CC) $(CFLAGS) -c TreeNode.cpp

clean:
	rm main test *.o