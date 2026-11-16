#include <string>
#include <vector>

#include "catch.hpp"
#include "../src/TreeNode.hpp"


TEST_CASE("TreeNode Initializations"){

    SECTION("Intializiation with no arguments gives us no keys and empty value"){
        TreeNode * tn = new TreeNode();

        REQUIRE(tn->getKeys().size() == 0);
        REQUIRE(tn->getValue() == '\0');
    }

    SECTION("Initialization with arguments gives us our input key and value"){
        TreeNode * tn = new TreeNode('A', "Key1");

        REQUIRE(tn->getKeys().size() == 1);
        REQUIRE(tn->getKeys().front() == "Key1");
        REQUIRE(tn->getValue() == 'A');
    }
}

TEST_CASE("Adding children and searching for them"){
    TreeNode * root = new TreeNode();
    
    SECTION("Adding a child to our node returns the child node"){
        TreeNode * child = root->addChild('A', "Key1");

        REQUIRE(child->getKeys().size() == 1);
        REQUIRE(child->getKeys().front() == "Key1");
        REQUIRE(child->getValue() == 'A');
    }

    SECTION("Adding child and searching for the value returns true"){
        TreeNode * child = root->addChild('A', "Key1");

        REQUIRE(root->hasChildWithValue('A'));
    }

    SECTION("Adding child and searching for the wrong value returns false"){
        TreeNode * child = root->addChild('A', "Key1");

        REQUIRE_FALSE(root->hasChildWithValue('B'));
    }

    SECTION("Adding child and retrieving the child with value returns child node"){
        TreeNode * child = root->addChild('A', "Key1");

        REQUIRE(root->getChildWithValue('A') == child);
    }

    SECTION("Adding child and retrieving the child with wrong value returns empty node"){
        TreeNode * child = root->addChild('A', "Key1");

        REQUIRE_FALSE(root->getChildWithValue('B') == child);
    }
}

TEST_CASE("Adding a key to the node"){
    TreeNode * root = new TreeNode();

    SECTION("Adding key to root allows me to get the key"){
        root->addKey("Key1");
        root->addKey("Key2");

        for (std::string key: root->getKeys()) {
            bool foundAKey = key == "Key1" || key == "Key2";
            REQUIRE(foundAKey);
        }
    }
}