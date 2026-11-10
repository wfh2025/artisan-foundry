#include "leetcode/leetcode.hpp"

TEST(remove_nth_node_from_end_of_list_19, 001)
{
    class Solution
    {
    public:
        ListNode* removeNthFromEnd(ListNode* head, int n)
        {
            ListNode dummy(0, head);
            ListNode* cur = &dummy;
            for (int i = 0; i < n; i++)
            {
                cur = cur->next;
            }
            ListNode* fast = cur;
            ListNode* slowPrev = &dummy;
            ListNode* slow = &dummy;

            while (fast != nullptr)
            {
                slowPrev = slow;
                slow = slow->next;
                fast = fast->next;
            }
            slowPrev->next = slow->next;
            delete slow;
            return dummy.next;
        }
    };
    Solution sln;
    {
        ListNode* li = td::createList(std::vector<int>{1, 2, 3, 4, 5});
        li = sln.removeNthFromEnd(li, 2);
        EXPECT_THAT(td::listToVec(li), testing::ContainerEq(std::vector<int>{1, 2, 3, 5}));
        td::deleteList(li);
    }
    {
        ListNode* li = td::createList(std::vector<int>{1});
        li = sln.removeNthFromEnd(li, 1);
        EXPECT_THAT(td::listToVec(li), testing::ContainerEq(std::vector<int>{}));
        td::deleteList(li);
    }
    {
        ListNode* li = td::createList(std::vector<int>{1, 2});
        li = sln.removeNthFromEnd(li, 1);
        EXPECT_THAT(td::listToVec(li), testing::ContainerEq(std::vector<int>{1}));
        td::deleteList(li);
    }
}