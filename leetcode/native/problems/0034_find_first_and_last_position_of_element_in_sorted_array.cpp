#include "leetcode/leetcode.hpp"

TEST(find_first_and_last_position_of_element_in_sorted_array_34, 001)
{
    class Solution
    {
    public:
        vector<int> searchRange(vector<int>& nums, int target)
        {
            int left = lower_bound(nums, target);
            if (left == nums.size() || nums[left] != target)
            {
                return {-1, -1};
            }
            int right = upper_bound(nums, target) - 1;
            return {left, right};
        }

    private:
        int lower_bound(const vector<int>& arr, int tgt)
        {
            int l = 0, r = arr.size();
            while (l < r)
            {
                int mid = l + (r - l) / 2;
                if (arr[mid] < tgt)
                {
                    l = mid + 1;
                }
                else
                {
                    r = mid;
                }
            }
            return l;
        }

        int upper_bound(const vector<int>& arr, int tgt)
        {
            int l = 0, r = arr.size();
            while (l < r)
            {
                int mid = l + (r - l) / 2;
                if (arr[mid] <= tgt)
                {
                    l = mid + 1;
                }
                else
                {
                    r = mid;
                }
            }
            return l;
        }
    };

    Solution sln;
    {
        std::vector<int> input = {5, 7, 7, 8, 8, 10};
        int tgt = 8;
        std::vector<int> expect = {3, 4};
        EXPECT_EQ(sln.searchRange(input, tgt), expect);
    }
    {
        std::vector<int> input = {1, 2, 2, 2, 3};
        int tgt = 2;
        std::vector<int> expect = {1, 3};
        EXPECT_EQ(sln.searchRange(input, tgt), expect);
    }
    {
        std::vector<int> input = {1, 2, 2, 2, 3, 3, 3, 4, 5};
        int tgt = 3;
        std::vector<int> expect = {4, 6};
        EXPECT_EQ(sln.searchRange(input, tgt), expect);
    }
}