# No Frills Prefix Tree (nf_prefix_tree)
This is a prefix tree with no frills. Supports simple insert, search, and basic querying of strings that a (can be) keyed. Written in C++ 11 and has python wrappers. Written because I couldn't find a fast, easy to install and use basic prefix tree in python. 

## Installation
### C++
In order to build the C++, you need to have 
1. C++ 11
2. `g++` compiler

This program uses the `STL` so no other packages are necessary

#### Linux and macOS
1. Change to the `nf_prefix_tree` directory
2. Run `chmod +x buildAndTest.sh`
3. Run `./buildAndTest.sh`

If no errors occur, you should be good to go!

#### Windows
In order to build, ensure you have the `g++` compiler and it is added to path
1. Change to `nf_prefix_tree/src/` directory
2. Run `make`
3. Change to `nf_prefix_tree/tests/` directory if you want to run tests
4. Run `make`
5. Run `./testmain`

### Python
If you are installing on `pip` and use macOS, all you need to run is `pip install nf_prefix_tree`

Otherwise you will need to build from source. First follow the above steps for C++. After doing so, make sure you have the following
1. `Python 3`
2. `Cython` package

Once you have these, change into the `python_bindings` directory. Run `python3 setup.py build_ext --inplace`. You can now do `from nf_prefix_tree import PyPrefixTree` in the same directory!

## Examples
### C++ 
```c++
#include "PrefixTree.hpp"

int main() {

    PrefixTree * t = new PrefixTree();

    t->addSequence("ABCDEFG", "Key1");
    t->addSequence("ABCDEFG", "Key2");
    t->addSequence("ABCXYZ", "Key3");
    t->addSequence("LMNOP", "Key4");

    t->show();
    
    t->show(2);
}
```
Output:
```bash
root
|-> Sequence: A	 keys: Key1, Key2, Key3, 
 |-> Sequence: AB	 keys: Key1, Key2, Key3, 
  |-> Sequence: ABC	 keys: Key1, Key2, Key3, 
   |-> Sequence: ABCD	 keys: Key1, Key2, 
    |-> Sequence: ABCDE	 keys: Key1, Key2, 
     |-> Sequence: ABCDEF	 keys: Key1, Key2, 
      |-> Sequence: ABCDEFG	 keys: Key1, Key2, 
   |-> Sequence: ABCX	 keys: Key3, 
    |-> Sequence: ABCXY	 keys: Key3, 
     |-> Sequence: ABCXYZ	 keys: Key3, 
|-> Sequence: L	 keys: Key4, 
 |-> Sequence: LM	 keys: Key4, 
  |-> Sequence: LMN	 keys: Key4, 
   |-> Sequence: LMNO	 keys: Key4, 
    |-> Sequence: LMNOP	 keys: Key4, 
root
|-> Sequence: A	 keys: Key1, Key2, Key3, 
 |-> Sequence: AB	 keys: Key1, Key2, Key3, 
|-> Sequence: L	 keys: Key4, 
 |-> Sequence: LM	 keys: Key4, 
```

### Python 
```python
from nf_prefix_tree import PyPrefixTree

t = PyPrefixTree()

t.addSequence('ABCDE', 'key1')
t.addSequence('ABCXY', 'key2')
t.addSequence('ZYAPW', 'key3')

t.show()
```
Output:
```bash
root
|-> Sequence: A	 keys: key1, key2, 
 |-> Sequence: AB	 keys: key1, key2, 
  |-> Sequence: ABC	 keys: key1, key2, 
   |-> Sequence: ABCD	 keys: key1, 
    |-> Sequence: ABCDE	 keys: key1, 
   |-> Sequence: ABCX	 keys: key2, 
    |-> Sequence: ABCXY	 keys: key2, 
|-> Sequence: Z	 keys: key3, 
 |-> Sequence: ZY	 keys: key3, 
  |-> Sequence: ZYA	 keys: key3, 
   |-> Sequence: ZYAP	 keys: key3, 
    |-> Sequence: ZYAPW	 keys: key3, 
```

## API
### C++
* `PrefixTree()`
    * Constructor for the prefix tree
* `void addSequence(sequence, key)`
    * Add a sequence with a key to the prefix tree
    * `sequence - std::string` the sequence to compress via tree
    * `key - std::string` the key for this sequence. If not desired, make sequence empty string
* `bool hasPrefix(prefix)`
    * Check to see if the input sequence is in the tree
    * `prefix - std::string` the prefix to look up
* `std::vector<std::string> getKeysWithPrefix(prefix)`
    * Get all keys associated with a prefix. Empty vector returned if the prefix is not in the tree
    * `prefix - std::string` the prefix to look for
* `void show(level=-1)`
    * Show the tree in the console down to the specified level
    * `level -- int` the level down to which to print the tree. Leave as `-1` if you want to print the entire tree
### Python
* `PyPrefixTree()`
    * Constructor for the prefix tree
* `addSequence(sequence, key) -> None` 
    * Add a sequence with a key to the prefix tree
    * `sequence - str` the sequence to compress via tree
    * `key - str` the key for this sequence. If not desired, make 
* `hasPrefix(prefix) -> bool`
    * Check to see if the input sequence is in the tree
    * `prefix - str` the prefix to look up
    * Returns `True` if `prefix` is found, `False` otherwise
* `getKeysWithPrefix(prefix) -> list`
    * Get all keys associated with a prefix
    * `prefix - str` the prefix to look for
    * Returns a `list` of `str` of all keys. `[]` is returned if the prefix is not in the tree
* `show(level=-1)`
    * Show the tree in the console down to the specified level
    * `level -- int` the level down to which to print the tree. Leave as `-1` if you want to print the entire tree