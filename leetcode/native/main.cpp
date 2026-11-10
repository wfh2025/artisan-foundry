#include <string>
#include <vector>

#include "gmock/gmock.h"
#include "gtest/gtest.h"
#include "spdlog/spdlog.h"

struct TestCaseId
{
    std::string testSuiteName;
    std::string testName;
    TestCaseId(std::string suit, std::string name) : testSuiteName(suit), testName(name) {}
};

static std::vector<TestCaseId> g_runCases = {
    {"*", "*"},
};

static void runCases()
{
    if (g_runCases.empty())
    {
        return;
    }
    std::string rule = "";
    for (const TestCaseId& caseId : g_runCases)
    {
        std::string item = caseId.testSuiteName + "." + caseId.testName;
        if (!rule.empty())
        {
            rule.append(":");
        }
        rule.append(item);
    }
    ::testing::GTEST_FLAG(filter) = rule;
}

static void initLog()
{
    spdlog::set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%P] [%t] [%s:%#] [%^%l%$] %v");
    spdlog::set_level(spdlog::level::debug);
}

int main(int argc, char** argv)
{
    initLog();
    ::testing::InitGoogleTest(&argc, argv);
    runCases();
    return RUN_ALL_TESTS();
}