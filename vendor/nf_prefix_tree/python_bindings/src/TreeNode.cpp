#include "TreeNode.hpp"

/*  Define outward facing functions  */
TreeNode::TreeNode(){
    this->value = '\0';
}

/**
 * Create a new TreeNode
 * 
 * @param value     char        the value to initialize the node with
 * @param key       std::string the key to initialize the node with
*/
TreeNode::TreeNode(char value, std::string key){
    this->value = value;
    this->keys.push_back(key);
}

TreeNode::~TreeNode(){}

/**
 * Add a key to the current node
 * 
 * @param key   std::string     the key to add to the current node
*/
void TreeNode::addKey(std::string key){
    this->keys.push_back(key);
}

/**
 * Add a child node with the new key and value
 * 
 * @param value char        the value to initialize the child with
 * @param key   std::string the key to initialize the child with
 * 
 * @return  TreeNode        the new child node
*/
TreeNode * TreeNode::addChild(char value, std::string key){
    TreeNode * child = new TreeNode(value, key);
    this->children.push_back(child);
    return child;
}

/**
 * Search through this node's children for the provided value
 * 
 * @param value  char    the value to search for
 * @return bool          true if found, false otherwise
*/
bool TreeNode::hasChildWithValue(char value){
    for (TreeNode * child: this->children){
        if (child->value == value) return true;
    }
    return false;
}

/**
 * Search through the node's children and return child if it has a value
 * 
 * @param value   char    the value to search for
 * @return TreeNode       The child with the value if it has one, empty node otherwise
*/
TreeNode * TreeNode::getChildWithValue(char value){    
    for (TreeNode * child: this->children){
        if (child->value == value) return child;
    }

    return new TreeNode();
}

/**
 * Get the keys of this node
 * 
 * @return std::vector     vector of the keys
*/
std::vector<std::string> TreeNode::getKeys(){
    return this->keys;
}

/**
 * Get all children of a node
 * 
 * @return std::vector<TreeNode *>
*/
std::vector<TreeNode *> TreeNode::getChildren(){
    return this->children;
}

/**
 * Get the value of the current node
 * 
 * @return char     the value of the current node
*/
char TreeNode::getValue(){
    return this->value;
}

 /**
 * Show this node and all this node's children
 * 
 * @param prefix    std::string the prefix to add
 * @param level     int     the level at which to stop
*/
void TreeNode::show(std::string prefix, int level){
    if (prefix.length() == level){
        return;
    }

    std::string nextPrefix = prefix + this->value;

    for (auto i: prefix) std::cout << " ";
    std::cout << "|-> ";
    std::cout << "Sequence: " << nextPrefix << "\t keys: ";
    for (auto k: this->keys) std::cout << k << ", ";
    std::cout << "\n";

    for (TreeNode * c: this->children){
        c->show(nextPrefix, level);
    }
}