#include "leetcode/leetcode.hpp"

TEST(middle_of_the_linked_list_876, 001)
{
    class Solution
    {
    public:
        ListNode* middleNode(ListNode* head)
        {
            ListNode* fast = head;
            ListNode* slow = head;
            while (true)
            {
                if ((fast == nullptr) || (fast->next == nullptr))
                {
                    break;
                }
                slow = slow->next;
                fast = fast->next->next;
            }
            return slow;
        }
    };

    Solution sln;
    {
        ListNode* li = td::createList(std::vector<int>{1, 2, 3, 4, 5});
        EXPECT_EQ((sln.middleNode(li)->val), 3);
        td::deleteList(li);
    }
    {
        ListNode* li = td::createList(std::vector<int>{1, 2, 3, 4});
        EXPECT_EQ((sln.middleNode(li)->val), 3);
        td::deleteList(li);
    }
}