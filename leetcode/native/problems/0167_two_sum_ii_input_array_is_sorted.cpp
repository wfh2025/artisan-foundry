#include "leetcode/leetcode.hpp"

TEST(two_sum_ii_input_array_is_sorted_167, 001)
{
    class Solution
    {
    public:
        vector<int> twoSum(vector<int>& numbers, int target)
        {
            int l = 0;
            int r = numbers.size() - 1;
            while (l < r)
            {
                int sum = numbers[l] + numbers[r];
                if (sum == target)
                {
                    return {l + 1, r + 1};
                }
                else if (sum < target)
                {
                    l++;
                }
                else
                {
                    r--;
                }
            }
            return {};
        }
    };

    Solution sln;
    {
        std::vector<int> input = {2, 7, 11, 15};
        int tgt = 9;
        std::vector<int> expect{1, 2};
        EXPECT_THAT(sln.twoSum(input, tgt), testing::ContainerEq(expect));
    }
    {
        std::vector<int> input = {2, 3, 4};
        int tgt = 6;
        std::vector<int> expect{1, 3};
        EXPECT_THAT(sln.twoSum(input, tgt), testing::ContainerEq(expect));
    }
    {
        std::vector<int> input = {-1, 0};
        int tgt = -1;
        std::vector<int> expect{1, 2};
        EXPECT_THAT(sln.twoSum(input, tgt), testing::ContainerEq(expect));
    }
}