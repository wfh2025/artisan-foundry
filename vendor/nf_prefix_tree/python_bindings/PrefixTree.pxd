from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

cdef extern from "../src/PrefixTree.hpp":
    cdef cppclass PrefixTree: 
        PrefixTree() except +
        void addSequence(string, string)
        bool hasPrefix(string)
        vector[string] getKeysWithPrefix(string)
        void show(int)
