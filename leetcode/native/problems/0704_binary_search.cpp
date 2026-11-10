#include "leetcode/leetcode.hpp"

TEST(binary_search_704, 001)
{
    class Solution
    {
    public:
        int search(vector<int>& nums, int target)
        {
            int l = 0;
            int r = nums.size() - 1;
            while (l <= r)
            {
                int mid = l + (r - l) / 2;
                if (nums[mid] == target)
                {
                    return mid;
                }
                else if (nums[mid] < target)
                {
                    l = mid + 1;
                }
                else
                {
                    r = mid - 1;
                }
            }

            return -1;
        }
    };

    Solution s;
    {
        auto v = std::vector<int>({-1, 0, 3, 5, 9, 12});
        int target = 9;
        int expectVal = 4;
        EXPECT_EQ(s.search(v, target), expectVal);
    }
}