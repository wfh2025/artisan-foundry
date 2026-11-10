#include <vector>

#include "leetcode/core/leetcode_structs.hpp"

namespace td
{
    ListNode* createList(const std::vector<int>& arr)
    {
        ListNode dummy(0, nullptr);
        ListNode* cur = &dummy;
        for (const auto& elem : arr)
        {
            cur->next = new ListNode(elem, nullptr);
            cur = cur->next;
        }
        return dummy.next;
    }

    std::vector<int> listToVec(ListNode* head)
    {
        std::vector<int> arr;

        ListNode* cur = head;
        while (cur != nullptr)
        {
            arr.push_back(cur->val);
            cur = cur->next;
        }

        return arr;
    }

    void deleteList(ListNode* head)
    {
        ListNode* cur = head;
        while (cur != nullptr)
        {
            ListNode* tmp = cur;
            cur = cur->next;
            delete tmp;
        }
    }
} // namespace td