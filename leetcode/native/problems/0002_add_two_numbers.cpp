#include "leetcode/leetcode.hpp"
TEST(add_two_numbers_3, 001)
{
    class Solution
    {
    public:
        ListNode* addTwoNumbers(ListNode* l1, ListNode* l2)
        {
            ListNode dummy(0, nullptr);
            ListNode* prev = &dummy;
            int carry = 0;

            while (true)
            {
                if (l1 == nullptr && l2 == nullptr && carry == 0)
                {
                    break;
                }
                int lVal = (l1 == nullptr) ? 0 : l1->val;
                int rVal = (l2 == nullptr) ? 0 : l2->val;
                int sum = lVal + rVal + carry;
                ListNode* tmp = new ListNode(sum % 10);
                prev->next = tmp;
                prev = tmp;

                carry = sum / 10;

                if (l1 != nullptr)
                {
                    l1 = l1->next;
                }
                if (l2 != nullptr)
                {
                    l2 = l2->next;
                }
            }

            return dummy.next;
        }
    };
    Solution sln;

    {
        ListNode* l1 = td::createList({2, 4, 3});
        ListNode* l2 = td::createList({5, 6, 4});

        ListNode* result = sln.addTwoNumbers(l1, l2);
        std::vector<int> output = td::listToVec(result);

        EXPECT_EQ(output, std::vector<int>({7, 0, 8}));

        td::deleteList(l1);
        td::deleteList(l2);
        td::deleteList(result);
    }
}