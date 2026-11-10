#include "leetcode/leetcode.hpp"

TEST(_3sum_15, 001)
{
    class Solution
    {
    public:
        vector<vector<int>> threeSum(vector<int>& nums)
        {
            auto& arr = nums;
            if (arr.size() < 3)
            {
                return {};
            }
            std::sort(arr.begin(), arr.end());

            int tgt = 0;
            std::vector<std::vector<int>> ans;

            for (int i = 0; i <= (arr.size() - 3); i++)
            {
                if ((i > 0) && (arr[i] == arr[i - 1]))
                {
                    continue;
                }
                int l = i + 1;
                int r = arr.size() - 1;
                while (l < r)
                {
                    int sum = arr[i] + arr[l] + arr[r];
                    if (sum == tgt)
                    {
                        ans.push_back({arr[i], arr[l], arr[r]});
                        while ((l < r) && (arr[l] == arr[l + 1]))
                        {
                            l++;
                        }
                        while ((l < r) && (arr[r] == arr[r - 1]))
                        {
                            r--;
                        }
                        l++;
                        r--;
                    }
                    else if (sum < tgt)
                    {
                        l++;
                    }
                    else
                    {
                        r--;
                    }
                }
            }
            return ans;
        }
    };

    Solution sln;

    {
        std::vector<int> input = {-1, 0, 1, 2, -1, -4};
        std::vector<std::vector<int>> expect = {
            {-1, -1, 2},
            {-1, 0, 1},
        };
        EXPECT_EQ(sln.threeSum(input), expect);
    }

    {
        std::vector<int> input = {
            0,
            1,
            1,
        };
        std::vector<std::vector<int>> expect = {};
        EXPECT_EQ(sln.threeSum(input), expect);
    }
    {
        std::vector<int> input = {0, 0, 0};
        std::vector<std::vector<int>> expect = {
            {0, 0, 0},
        };
        EXPECT_EQ(sln.threeSum(input), expect);
    }
}