#include "leetcode/leetcode.hpp"

TEST(longest_substring_without_repeating_characters_3, 001)
{
    class Solution
    {
    public:
        int lengthOfLongestSubstring(string s)
        {
            std::unordered_set<char> cache;
            int maxLen = 0;
            int l = 0;
            for (int r = 0; r < s.size(); r++)
            {
                // 1. 扩大win

                // 2. 观察是否满足条件，不满足条件重复处理到满足条件位置
                while (cache.count(s[r]))
                {
                    cache.erase(s[l]);
                    l++;
                }

                // 3. 处理
                cache.insert(s[r]);
                maxLen = std::max(maxLen, (r - l + 1));
            }
            return maxLen;
        }
    };

    Solution sln;
    {
        std::string input = "abcabcbb";
        int expect = 3;
        EXPECT_EQ(sln.lengthOfLongestSubstring(input), expect);
    }

    {
        std::string input = "bbbbb";
        int expect = 1;
        EXPECT_EQ(sln.lengthOfLongestSubstring(input), expect);
    }

    {
        std::string input = "pwwkew";
        int expect = 3;
        EXPECT_EQ(sln.lengthOfLongestSubstring(input), expect);
    }

    {
        std::string input = "abcdefgdh";
        int expect = 7;
        EXPECT_EQ(sln.lengthOfLongestSubstring(input), expect);
    }
}
