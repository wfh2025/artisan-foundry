#include "leetcode/leetcode.hpp"

TEST(reverse_linked_list_206, 001)
{
    class Solution
    {
    public:
        ListNode* reverseList(ListNode* head)
        {
            ListNode* prev = nullptr;
            ListNode* cur = head;
            while (cur != nullptr)
            {
                ListNode* tmp = cur->next;
                cur->next = prev;
                prev = cur;
                cur = tmp;
            }
            return prev;
        }
    };

    Solution sln;
    {
        ListNode* li = td::createList(std::vector<int>{1, 2, 3, 4, 5});
        ListNode* rev = sln.reverseList(li);
        auto revVec = td::listToVec(rev);
        EXPECT_THAT(revVec, testing::ContainerEq(std::vector<int>{5, 4, 3, 2, 1}));
    }
}