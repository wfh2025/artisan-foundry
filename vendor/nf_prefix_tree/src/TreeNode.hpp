#ifndef TREENODE_H
#define TREENODE_H

#include <vector>
#include <string>
#include <iostream>
class TreeNode{
public:

    /*  Define outward facing functions  */
    TreeNode();
    TreeNode(char value, std::string key);
    ~TreeNode();

    /**
     * Add a key to the current node
     * 
     * @param key   std::string     the key to add to the current node
    */
    void addKey(std::string key);

    /**
     * Add a child node with the new key and value
     * 
     * @param value char        the value to initialize the child with
     * @param key   std::string the key to initialize the child with
     * 
     * @return  TreeNode        the new child node
    */
    TreeNode * addChild(char value, std::string key);

    /**
     * Search through this node's children for the provided value
     * 
     * @param value  char    the value to search for
     * @return bool          true if found, false otherwise
    */
    bool hasChildWithValue(char value);

    /**
     * Search through the node's children and return child if it has a value
     * 
     * @param value   char    the value to search for
     * @return TreeNode       The child with the value if it has one, empty node otherwise
    */
    TreeNode * getChildWithValue(char value);

    /**
     * Get the keys of this node
     * 
     * @return std::vector     vector of the keys
    */
    std::vector<std::string> getKeys();

    /**
     * Get all children of a node
     * 
     * @return std::vector<TreeNode *>
    */
    std::vector<TreeNode *> getChildren();

    /**
     * Get the value of the current node
     * 
     * @return char     the value of the current node
    */
    char getValue();

    /**
     * Show this node and all this node's children
     * 
     * @param prefix    std::string the prefix to add
     * @param level     int     the level at which to stop
    */
    void show(std::string prefix, int level=-1);

private:

    /*  Define Tree Node properties  */
    std::vector<TreeNode *> children;
    std::vector<std::string> keys;
    char value;
};

#endif