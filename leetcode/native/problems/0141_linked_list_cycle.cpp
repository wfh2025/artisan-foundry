#include "leetcode/leetcode.hpp"
/**
 * 注意: 创建的链表内存没有释放，存在内存泄漏
 */

TEST(linked_list_cycle_141, 001)
{
    class Solution
    {
    public:
        bool hasCycle(ListNode* head)
        {
            if ((nullptr == head) || (head->next == nullptr))
            {
                return false;
            }

            ListNode* slow = head;
            ListNode* fast = head;
            while (true)
            {
                if ((fast == nullptr) || (fast->next == nullptr))
                {
                    // 走到了尽头, 没有环
                    break;
                }

                slow = slow->next;
                fast = fast->next->next;
                if (slow == fast)
                {
                    return true;
                }
            }

            return false;
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
        EXPECT_EQ(sln.hasCycle(li), true);
    }
    {
        ListNode* li = makeListOfVals(std::vector<int>{1, 2}, 0);
        EXPECT_EQ(sln.hasCycle(li), true);
    }
    {
        ListNode* li = makeListOfVals(std::vector<int>{1}, -1);
        EXPECT_EQ(sln.hasCycle(li), false);
    }
}