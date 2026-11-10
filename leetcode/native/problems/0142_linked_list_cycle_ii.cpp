#include "leetcode/leetcode.hpp"

TEST(linked_list_cycle_ii_142, 001)
{
    class Solution
    {
    public:
        ListNode* detectCycle(ListNode* head)
        {
            if (nullptr == head)
            {
                return nullptr;
            }

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
                if (slow == fast)
                {
                    ListNode* li1 = head;
                    ListNode* li2 = slow;
                    while (true)
                    {
                        if (li1 == li2)
                        {
                            return li1;
                        }
                        li1 = li1->next;
                        li2 = li2->next;
                    }
                }
            }

            return nullptr;
        }
    };
    auto makeListOfVals = [](const std::vector<int>& vals, int cycleIndex) -> ListNode* {
        if (vals.empty())
        {
            return nullptr;
        }
        std::vector<ListNode*> nodes(vals.size());
        for (int i = 0; i < vals.size(); i++)
        {
            nodes[i] = new ListNode(vals[i], nullptr);
        }
        for (int i = 0; i < (nodes.size() - 1); i++)
        {
            nodes[i]->next = nodes[i + 1];
        }

        if ((cycleIndex >= 0) && (cycleIndex < vals.size()))
        {
            nodes[nodes.size() - 1]->next = nodes[cycleIndex];
        }
        return nodes[0];
    };

    Solution sln;
    {
        ListNode* li = makeListOfVals(std::vector<int>{3, 2, 0, -4}, 1);
        EXPECT_EQ(sln.detectCycle(li)->val, 2);
    }
    {
        ListNode* li = makeListOfVals(std::vector<int>{1, 2}, 0);
        EXPECT_EQ(sln.detectCycle(li)->val, 1);
    }
    {
        ListNode* li = makeListOfVals(std::vector<int>{1}, -1);
        EXPECT_EQ(sln.detectCycle(li), nullptr);
    }
}