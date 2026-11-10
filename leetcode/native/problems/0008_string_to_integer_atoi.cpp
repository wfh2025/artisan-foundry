#include "leetcode/leetcode.hpp"

TEST(string_to_integer_atoi_8, int)
{
    class Solution
    {
    public:
        int myAtoi(string s)
        {
            const std::string& str = s;
            int index = 0;

            // 剔除空格
            while ((index < str.size()) && (str[index] == ' '))
            {
                index++;
            }
            if (index == str.size())
            {
                return 0;
            }

            // 正负号
            bool isPositive = true;
            if ((str[index] == '+') || (str[index] == '-'))
            {
                isPositive = (str[index] == '+') ? true : false;
                index++;
            }

            // 前导0
            while ((index < str.size()) && (str[index] == '0'))
            {
                index++;
            }

            int ans = 0;

            if (isPositive)
            {
                while ((index < str.size()) && std::isdigit(static_cast<int>(str[index])))
                {
                    int digit = str[index] - '0';
                    // ans * 10 + digit <= INT_MAX ==> ans <= (INT_MAX-digit)/10
                    if (ans > ((std::numeric_limits<int>::max() - digit) / 10))
                    {
                        return std::numeric_limits<int>::max();
                    }
                    ans = ans * 10 + digit;
                    index++;
                }
            }
            else
            {
                while ((index < str.size()) && std::isdigit(static_cast<int>(str[index])))
                {
                    int digit = str[index] - '0';

                    // ans *10 - digit >= INT_MIN ==> ans >= (INT_MIN+digit)/10
                    if (ans < ((std::numeric_limits<int>::min() + digit) / 10))
                    {
                        return std::numeric_limits<int>::min();
                    }
                    ans = ans * 10 - digit;
                    index++;
                }
            }

            return ans;
        }
    };

    Solution sln;
    {
        EXPECT_EQ(sln.myAtoi("42"), 42);
    }
    {
        EXPECT_EQ(sln.myAtoi("   -042"), -42);
    }
    {
        EXPECT_EQ(sln.myAtoi("1337c0d3"), 1337);
    }
    {
        EXPECT_EQ(sln.myAtoi("0-1"), 0);
    }
    {
        EXPECT_EQ(sln.myAtoi("words and 987"), 0);
    }
}