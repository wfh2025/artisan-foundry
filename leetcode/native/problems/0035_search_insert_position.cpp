#include "leetcode/leetcode.hpp"

TEST(search_insert_position_35, binarySearch)
{
    class Solution
    {
    public:
        int searchInsert(vector<int>& nums, int target)
        {
            int l = 0;
            int r = nums.size() - 1;
            while (l <= r)
            {
                int mid = l + (r - l) / 2;
                if (nums[mid] < target)
                {
                    l = mid + 1;
                }
                else if (nums[mid] == target)
                {
                    return mid;
                }
                else
                {
                    r = mid - 1;
                }
            }

            return l;
        }
    };
    Solution s;
    {
        auto v = std::vector<int>({1, 3, 5, 6});
        int target = 5;
        int expectVal = 2;
        EXPECT_EQ(s.searchInsert(v, target), expectVal);
    }
    {
        auto v = std::vector<int>({1, 3, 5, 6});
        int target = 2;
        int expectVal = 1;
        EXPECT_EQ(s.searchInsert(v, target), expectVal);
    }
    {
        auto v = std::vector<int>({1, 3, 5, 6});
        int target = 7;
        int expectVal = 4;
        EXPECT_EQ(s.searchInsert(v, target), expectVal);
    }
}