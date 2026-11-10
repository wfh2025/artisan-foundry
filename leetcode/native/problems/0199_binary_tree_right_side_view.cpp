#include "leetcode/leetcode.hpp"

TEST(binary_tree_right_side_view_199, 001)
{
    class Solution
    {
    public:
        vector<int> rightSideView(TreeNode* root)
        {
            if (root == nullptr)
            {
                return {};
            }
            std::queue<TreeNode*> q;
            std::vector<int> arr;
            q.push(root);
            while (!q.empty())
            {
                int levelSize = q.size();
                TreeNode* cur = nullptr;
                for (int i = 0; i < levelSize; i++)
                {
                    cur = q.front();
                    q.pop();

                    if (cur->left != nullptr)
                    {
                        q.push(cur->left);
                    }
                    if (cur->right != nullptr)
                    {
                        q.push(cur->right);
                    }
                }
                if (cur != nullptr)
                {
                    arr.push_back(cur->val);
                }
            }
            return arr;
        }
    };
    Solution sln;
    {
        TreeNode* input = td::createTree({1, 2, 3, INT_MIN, 5, INT_MIN, 4});
        std::vector<int> expect = {1, 3, 4};
        EXPECT_EQ(sln.rightSideView(input), expect);
        td::deleteTree(input);
    }
    {
        TreeNode* input = td::createTree({1, 2, 3, 4, INT_MIN, INT_MIN, INT_MIN, 5});
        std::vector<int> expect = {1, 3, 4, 5};
        EXPECT_EQ(sln.rightSideView(input), expect);
        td::deleteTree(input);
    }

    {
        TreeNode* input = td::createTree({1, INT_MIN, 3});
        std::vector<int> expect = {1, 3};
        EXPECT_EQ(sln.rightSideView(input), expect);
        td::deleteTree(input);
    }
}