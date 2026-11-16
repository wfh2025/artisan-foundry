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