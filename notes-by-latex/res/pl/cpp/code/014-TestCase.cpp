#include <iostream>
#include <random>

#include "gtest/gtest.h"
TEST(TestCaseChore, 001)
{
    auto getRandomValue = []() -> int {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dis(0, 99);
        return dis(gen);
    };
    for (int i = 0; i < 10; i++)
    {
        std::cout << "random value: " << getRandomValue() << std::endl;
    }
}

// 运行结果
// random value: 78
// random value: 81
// random value: 46
// random value: 73
// random value: 22
// random value: 16
// random value: 40
// random value: 6
// random value: 4
// random value: 70
