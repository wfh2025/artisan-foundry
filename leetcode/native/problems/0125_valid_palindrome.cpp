#include "leetcode/leetcode.hpp"
TEST(valid_palindrome_125, 001)
{
#include <cctype>
    class Solution
    {
    public:
        bool isPalindrome(string s)
        {
            int l = 0;
            int r = s.size() - 1;
            while (l < r)
            {
                while ((l < r) && !isalnum(s[l]))
                {
                    l++;
                }
                while ((l < r) && !isalnum(s[r]))
                {
                    r--;
                }
                if (std::tolower(s[l]) != std::tolower(s[r]))
                {
                    return false;
                }
                l++;
                r--;
            }
            return true;
        }
    };
    Solution sln;
    {
        std::string input = "A man, a plan, a canal: Panama";
        EXPECT_EQ(sln.isPalindrome(input), true);
    }
    {
        std::string input = "race a car";
        EXPECT_EQ(sln.isPalindrome(input), false);
    }
    {
        std::string input = " ";
        EXPECT_EQ(sln.isPalindrome(input), true);
    }
}

TEST(valid_palindrome_125, 002)
{
    class Solution
    {
    public:
        bool isPalindrome(string s)
        {
            int l = 0;
            int r = s.size() - 1;
            while (l < r)
            {
                if (!isalnum(s[l]))
                {
                    l++;
                    continue;
                }
                if (!isalnum(s[r]))
                {
                    r--;
                    continue;
                }

                auto lVal = std::tolower(s[l]);
                auto rVal = std::tolower(s[r]);
                if (lVal != rVal)
                {
                    return false;
                }
                l++;
                r--;
            }
            return true;
        }
    };
    Solution sln;
    {
        std::string input = "A man, a plan, a canal: Panama";
        EXPECT_EQ(sln.isPalindrome(input), true);
    }
    {
        std::string input = "race a car";
        EXPECT_EQ(sln.isPalindrome(input), false);
    }
    {
        std::string input = " ";
        EXPECT_EQ(sln.isPalindrome(input), true);
    }
}