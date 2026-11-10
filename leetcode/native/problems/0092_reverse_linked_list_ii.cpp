#include "leetcode/leetcode.hpp"

TEST(reverse_linked_list_ii_92, segmentation)
{
    class Solution
    {
    public:
        ListNode* reverseBetween(ListNode* head, int left, int right)
        {
            ListNode dummy(0, head);
            ListNode* leftPrevNode = &dummy;

            for (int i = 0; i < left - 1; i++)
            {
                leftPrevNode = leftPrevNode->next;
            }
            ListNode* leftNode = leftPrevNode->next;

            int cnt = 0;

            const int betweenNodes = right - left + 1;
            ListNode* prev = leftPrevNode;
            ListNode* cur = leftNode;
            ListNode* rightNextNode = nullptr;
            while (true)
            {
                if (cnt == betweenNodes)
                {
                    rightNextNode = cur;
                    break;
                }
                ListNode* tmp = cur->next;
                cur->next = prev;
                prev = cur;
                cur = tmp;
                cnt++;
            }
            leftPrevNode->next = prev;
            leftNode->next = rightNextNode;

            return dummy.next;
        }
    };
    Solution sln;

    {
        ListNode* inLi = td::createList(std::vector<int>{1, 2, 3, 4, 5});
        ListNode* outLi = sln.reverseBetween(inLi, 2, 4);
        EXPECT_THAT(td::listToVec(outLi), testing::ContainerEq(std::vector<int>{1, 4, 3, 2, 5}));
    }

    {
        ListNode* inLi = td::createList(std::vector<int>{5});
        ListNode* outLi = sln.reverseBetween(inLi, 1, 1);
        EXPECT_THAT(td::listToVec(outLi), testing::ContainerEq(std::vector<int>{5}));
    }
}

TEST(reverse_linked_list_ii_92, segmentation2)
{
    class Solution
    {
    public:
        ListNode* reverseBetween(ListNode* head, int left, int right)
        {
            ListNode dummy(0, head);
            ListNode* leftPrevNode = &dummy;

            for (int i = 0; i < left - 1; i++)
            {
                leftPrevNode = leftPrevNode->next;
            }
            ListNode* leftNode = leftPrevNode->next;

            ListNode* rightNode = leftNode;
            for (int i = 0; i < (right - left); i++)
            {
                rightNode = rightNode->next;
            }
            ListNode* rightNextNode = rightNode->next;

            rightNode->next = nullptr;

            revList(leftNode);

            leftPrevNode->next = rightNode;
            leftNode->next = rightNextNode;

            return dummy.next;
        }

        ListNode* revList(ListNode* head)
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
        ListNode* inLi = td::createList(std::vector<int>{1, 2, 3, 4, 5});
        ListNode* outLi = sln.reverseBetween(inLi, 2, 4);
        EXPECT_THAT(td::listToVec(outLi), testing::ContainerEq(std::vector<int>{1, 4, 3, 2, 5}));
    }

    {
        ListNode* inLi = td::createList(std::vector<int>{5});
        ListNode* outLi = sln.reverseBetween(inLi, 1, 1);
        EXPECT_THAT(td::listToVec(outLi), testing::ContainerEq(std::vector<int>{5}));
    }
}