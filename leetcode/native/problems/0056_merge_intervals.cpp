#include "leetcode/leetcode.hpp"

TEST(merge_intervals_56, 001)
{
    class Solution
    {
    public:
        vector<vector<int>> merge(vector<vector<int>>& intervals)
        {
            if (intervals.empty())
            {
                return {};
            }

            std::sort(intervals.begin(), intervals.end(), [](const std::vector<int>& lhs, const std::vector<int>& rhs) { return lhs[0] < rhs[0]; });

            std::vector<std::vector<int>> res;
            res.push_back(intervals[0]);

            for (int i = 1; i < intervals.size(); i++)
            {
                std::vector<int>& last = res.back(); // 注意: 返回引用
                std::vector<int>& cur = intervals[i];
                if (cur[0] <= last[1])
                {
                    last[1] = std::max(last[1], cur[1]);
                }
                else
                {
                    res.push_back(cur);
                }
            }
            return res;
        }
    };

    Solution solution;
    {
        std::vector<std::vector<int>> intervals = {
            {1, 3},
            {2, 6},
            {8, 10},
            {15, 18},
        };
        std::vector<std::vector<int>> expected = {
            {1, 6},
            {8, 10},
            {15, 18},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {
            {1, 4},
            {4, 5},
        };
        std::vector<std::vector<int>> expected = {
            {1, 5},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {
            {4, 7},
            {1, 4},
        };
        std::vector<std::vector<int>> expected = {
            {1, 7},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {
            {1, 10},
            {2, 6},
            {3, 8},
        };
        std::vector<std::vector<int>> expected = {
            {1, 10},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {
            {1, 2},
            {3, 4},
            {5, 6},
        };
        std::vector<std::vector<int>> expected = {
            {1, 2},
            {3, 4},
            {5, 6},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {
            {1, 5},
        };
        std::vector<std::vector<int>> expected = {
            {1, 5},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {};
        std::vector<std::vector<int>> expected = {};
        EXPECT_EQ(solution.merge(intervals), expected);
    }
    {
        std::vector<std::vector<int>> intervals = {
            {1, 4},
            {1, 4},
        };
        std::vector<std::vector<int>> expected = {
            {1, 4},
        };
        EXPECT_EQ(solution.merge(intervals), expected);
    }
}