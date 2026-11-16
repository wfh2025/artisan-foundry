#include <string>
#include <vector>

#include "catch.hpp"
#include "../src/PrefixTree.hpp"

bool hasString(std::vector<std::string> listOfString, std::string searching){
    for (std::string s: listOfString){
        if (s == searching) return true;
    }
    return false;
}


TEST_CASE("PrefixTree Initializations"){
    SECTION("Initialization throws no error"){
        PrefixTree * t;
        REQUIRE_NOTHROW(t = new PrefixTree());
    }

    SECTION("Initializing a tree and searching it returns empty"){
        PrefixTree * t = new PrefixTree();

        REQUIRE(t->getKeysWithPrefix("ABC").size() == 0);
    }
}

TEST_CASE("Building a tree and searching for existing strings"){
    PrefixTree * t = new PrefixTree();

    SECTION("Adding a sequence to the tree doesn't throw an error"){
        REQUIRE_NOTHROW(t->addSequence("ABC", "Key1"));
    }

    SECTION("Adding a sequence and searching it allows me to find all prefixes"){
        t->addSequence("ABC", "Key1");
        REQUIRE(t->hasPrefix("ABC"));
        REQUIRE(t->hasPrefix("AB"));
        REQUIRE(t->hasPrefix("A"));
    }

    SECTION("Adding a sequence allows me to find the right key for all prefixes"){
        t->addSequence("ABC", "Key1");
        REQUIRE(t->getKeysWithPrefix("ABC").front() == "Key1");
        REQUIRE(t->getKeysWithPrefix("AB").front() == "Key1");
        REQUIRE(t->getKeysWithPrefix("A").front() == "Key1");
    }
}

TEST_CASE("Building a tree and searching for non-existing strings gives me nothing"){
    PrefixTree * t = new PrefixTree();

    SECTION("Adding a sequene and looking for another returns false"){
        t->addSequence("XYZ", "Key1");
        REQUIRE_FALSE(t->hasPrefix("ABC"));
    }

    SECTION("Adding a sequene and looking for another returns no keys"){
        t->addSequence("XYZ", "Key1");
        REQUIRE(t->getKeysWithPrefix("ABC").size() == 0);
    }
}

TEST_CASE("Adding multiple prefixes"){
    PrefixTree * t = new PrefixTree();

    std::string prefix1 = "ABCDE";
    std::string key1 = "Key1";

    std::string prefix2 = "ABCYZ";
    std::string key2 = "Key2";

    SECTION("Adding two prefixes that overlap does not throw an error"){
        REQUIRE_NOTHROW(t->addSequence(prefix1, key1));
        REQUIRE_NOTHROW(t->addSequence(prefix2, key2));
    }

    SECTION("Adding two prefixes and searching for common prefixes gives both keys"){
        t->addSequence(prefix1, key1);
        t->addSequence(prefix2, key2);

        std::vector<std::string> substringSearch1 = t->getKeysWithPrefix("ABC");
        REQUIRE(hasString(substringSearch1, key1));
        REQUIRE(hasString(substringSearch1, key2));

        std::vector<std::string> substringSearch2 = t->getKeysWithPrefix("AB");
        REQUIRE(hasString(substringSearch2, key1));
        REQUIRE(hasString(substringSearch2, key2));

        std::vector<std::string> substringSearch3 = t->getKeysWithPrefix("A");
        REQUIRE(hasString(substringSearch3, key1));
        REQUIRE(hasString(substringSearch3, key2));
    }

    SECTION("Adding two prefixes and searching for different prefixes gives only correct keys"){
        t->addSequence(prefix1, key1);
        t->addSequence(prefix2, key2);

        std::vector<std::string> substringSearch1 = t->getKeysWithPrefix("ABCD");
        REQUIRE(hasString(substringSearch1, key1));
        REQUIRE_FALSE(hasString(substringSearch1, key2));

        std::vector<std::string> substringSearch2 = t->getKeysWithPrefix("ABCDE");
        REQUIRE(hasString(substringSearch2, key1));
        REQUIRE_FALSE(hasString(substringSearch2, key2));

        std::vector<std::string> substringSearch3 = t->getKeysWithPrefix("ABCY");
        REQUIRE_FALSE(hasString(substringSearch3, key1));
        REQUIRE(hasString(substringSearch3, key2));

        std::vector<std::string> substringSearch4 = t->getKeysWithPrefix("ABCYZ");
        REQUIRE_FALSE(hasString(substringSearch4, key1));
        REQUIRE(hasString(substringSearch4, key2));
    }
}