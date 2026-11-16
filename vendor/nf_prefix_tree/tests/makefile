CC = g++
CFLAGS = -Wall -g -std=c++11

testmain: tests-main.o tests-PrefixTree.o tests-TreeNode.o ../src/PrefixTree.o ../src/TreeNode.o 
	${CC} ${CFLAGS} -o testmain tests-main.o tests-PrefixTree.o  tests-TreeNode.o ../src/PrefixTree.o ../src/TreeNode.o 

tests-main.o: tests-main.cpp catch.hpp
	${CC} ${CFLAGS} -c tests-main.cpp 

tests-PrefixTree.o: tests-PrefixTree.cpp tests-main.cpp
	${CC} ${CFLAGS} -c tests-PrefixTree.cpp 

tests-TreeNode.o: tests-TreeNode.cpp tests-main.cpp 
	${CC} ${CFLAGS} -c tests-TreeNode.cpp 


clean:
	rm testmain *.o