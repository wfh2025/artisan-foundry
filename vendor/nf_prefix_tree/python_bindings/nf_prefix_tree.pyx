# distutils: language = c++
# distutils: sources = ../src/PrefixTree.cpp ../src/TreeNode.cpp

from libcpp.string cimport string 
from libcpp.vector cimport vector
from libcpp cimport bool

from PrefixTree cimport PrefixTree

# Create a Cython extension type which holds a C++ instance
# as an attribute and create a bunch of forwarding methods
# Python extension type.
cdef class PyPrefixTree:
    cdef PrefixTree * t    # holds the c++ instance that is wrapped

    def __cinit__(self):
        self.t = new PrefixTree()

    def __dealloc__(self):
        del self.t

    def addSequence(self, sequence: str, key: str) -> None:
        '''
        Add a sequence with a key to the tree

        Inputs:
            sequence:   (str) the sequence to add to the tree
            key:        (str) the key associated with the sequence
        Outputs:
            None
        ''' 
        cdef string seq = str.encode(sequence)
        cdef string k = str.encode(key)

        try:
            self.t.addSequence(seq, k)
        except Exception as e:
            raise 'Error: could not add sequence. Error: ' + e

    def hasPrefix(self, prefix: str) -> bool:
        '''
        Check if the input prefix exists in the tree

        Inputs:
            prefix:     (str) the sequence to look for
        Outputs:
            (bool) True if found, false otherwise
        '''
        cdef string p = str.encode(prefix)

        try:
            return self.t.hasPrefix(p)
        except Exception as e:
            raise 'Error: could not look for sequence. Error: ' + e

    def getKeysWithPrefix(self, sequence: str) -> list:
        '''
        Get all keys associated with a prefix. If not found, and empty list is returned

        Inputs:
            sequence:   (str) the sequnce to look for
        Outputs:
            (list) all keys associated with the sequence
        '''
        cdef string seq = str.encode(sequence)
        cdef vector[string] results = self.t.getKeysWithPrefix(seq)

        try:
            return list(set(
                [result.decode() for result in results]
            ))
        except Exception as e:
            raise 'Error: could not look for sequence. Error: ' + e

    def show(self, level=-1) -> None:
        '''
        Print the tree to console

        Inputs:
            level:  (int) the level down to which in the tree to print. Default is all of the tree
        Outputs:
            None
        '''
        try:    
            self.t.show(level)
        except Exception as e:
            raise 'Error: could not print tree. Error: ' + e 
