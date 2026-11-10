#include "leetcode/leetcode.hpp"

TEST(palindrome_number_9, 001)
{
    class Solution
    {
    public:
        bool isPalindrome(int x)
        {
            if ((x < 0) || ((x % 10 == 0) && (x != 0)))
            {
                return false;
            }
            int rev = 0;
            int tmp = x;
            while (rev < tmp)
            {
                int cur = tmp % 10;
                rev = rev * 10 + cur;
                tmp /= 10;
            }

            return (tmp == rev) || (rev / 10 == tmp);
        }
    };

    Solution sln;
    {
        EXPECT_EQ(sln.isPalindrome(1235321), true);
        EXPECT_EQ(sln.isPalindrome(123321), true);
        EXPECT_EQ(sln.isPalindrome(-121), false);
        EXPECT_EQ(sln.isPalindrome(121), true);
        EXPECT_EQ(sln.isPalindrome(10), false);
    }
}