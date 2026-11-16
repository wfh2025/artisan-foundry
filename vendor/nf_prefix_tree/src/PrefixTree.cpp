#include "PrefixTree.hpp"
    
PrefixTree::PrefixTree(){
    this->root = new TreeNode();
}

PrefixTree::~PrefixTree(){
    delete this->root;
}

/**
 * Add a sequence with a key to the tree
 * 
 * @param   sequence    std::string the sequence to add
 * @param   key         std::string the key for the sequence
*/
void PrefixTree::addSequence(std::string sequence, std::string key){

    // start off at the root. For each node we visit, we want to see
    // if they have the next child in the sequence. If not, we will
    // create a new child and add it
    TreeNode * currentNode = this->root;

    for (char c: sequence){

        // if the current one has a child with value, add the 
        // key to the child and make current node the child
        if (currentNode->hasChildWithValue(c)){
            currentNode = currentNode->getChildWithValue(c);
            currentNode->addKey(key);
        }

        // otherwise create a node with key and value
        else{
            currentNode = currentNode->addChild(c, key);
        }
    }
}

/**
 * Check if a string exists in the prefix tree
 * 
 * @param   sequence    std::string the sequence to search for
 * 
 * @return bool         true if the sequence is found, false otherwise
*/
bool PrefixTree::hasPrefix(std::string sequence){

    // look for the sequence. If we can't find the value at all, return false
    TreeNode * currentNode = this->root;

    for (char c: sequence){
        if (! currentNode->hasChildWithValue(c)) return false;
        else currentNode = currentNode->getChildWithValue(c);
    }
    return true;
}

/**
 * Get all keys associated with a prefix
 * 
 * @param   sequence    std::string the sequence to search for
 * 
 * @return std::vector  a vector containing all keys associated with a sequence. An
 *          empty vector is returned if the sequence can't be found
*/
std::vector<std::string> PrefixTree::getKeysWithPrefix(std::string sequence){

    std::vector<std::string> result;

    // look for the sequence. If we can't find the value at all, return empty vector
    TreeNode * currentNode = this->root;

    for (char c: sequence){
        if (! currentNode->hasChildWithValue(c)) return result;
        else currentNode = currentNode->getChildWithValue(c);
    }

    // copy it over so that we don't return the actual value
    for (std::string k: currentNode->getKeys()) result.push_back(k);
    return result;    
}

/**
 * Show the tree in an easy to see way
 * 
 * @param level     int (optional) the level down to which we print the tree. If left empty, entire tree
*/
void PrefixTree::show(int level){
    std::cout << "root\n";
    for (TreeNode * c: this->root->getChildren()){
        c->show("", level);
    }
}
