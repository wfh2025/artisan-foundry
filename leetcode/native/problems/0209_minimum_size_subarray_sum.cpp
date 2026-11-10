#include "leetcode/leetcode.hpp"

TEST(minimum_size_subarray_sum_209, 001)
{
    using namespace std;
    class Solution
    {
    public:
        int minSubArrayLen(int target, vector<int>& nums)
        {
            int l = 0;
            int sum = 0;
            int minLen = INT_MAX;
            for (int r = 0; r < nums.size(); r++)
            {
                sum += nums[r];
                while (sum >= target)
                {
                    minLen = std::min(minLen, r - l + 1);
                    sum -= nums[l];
                    l++;
                }
            }
            return minLen == INT_MAX ? 0 : minLen;
        }
    };

    Solution s;
    std::vector<int> nums{2, 3, 1, 2, 4, 3};
    int ret = s.minSubArrayLen(7, nums);
    EXPECT_EQ(ret, 2);
}
