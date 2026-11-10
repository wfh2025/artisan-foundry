#include "leetcode/leetcode.hpp"

TEST(maximum_depth_of_binary_tree_104, recursive)
{
    class Solution
    {
    public:
        int maxDepth(TreeNode* root)
        {
            if (root == nullptr)
            {
                return 0;
            }
            int leftDepth = maxDepth(root->left);
            int rightDepth = maxDepth(root->right);
            return std::max(leftDepth, rightDepth) + 1;
        }
    };
    Solution sln;
    {
        TreeNode* input = td::createTree({3, 9, 20, INT_MIN, INT_MIN, 15, 7});
        int expect = 3;
        EXPECT_EQ(sln.maxDepth(input), expect);
        td::deleteTree(input);
    }
    {
        TreeNode* input = td::createTree({1, INT_MIN, 2});
        int expect = 2;
        EXPECT_EQ(sln.maxDepth(input), expect);
        td::deleteTree(input);
    }
}

TEST(maximum_depth_of_binary_tree_104, queue)
{
    class Solution
    {
    public:
        int maxDepth(TreeNode* root)
        {
            if (nullptr == root)
            {
                return 0;
            }
            std::queue<TreeNode*> q;
            q.push(root);
            int maxVal = 0;
            while (!q.empty())
            {
                int levelSize = q.size();
                for (int i = 0; i < levelSize; i++)
                {
                    TreeNode* cur = q.front();
                    q.pop();
                    if (nullptr != cur->left)
                    {
                        q.push(cur->left);
                    }
                    if (nullptr != cur->right)
                    {
                        q.push(cur->right);
                    }
                }
                maxVal++;
            }
            return maxVal;
        }
    };
    Solution sln;
    {
        TreeNode* input = td::createTree({3, 9, 20, INT_MIN, INT_MIN, 15, 7});
        int expect = 3;
        EXPECT_EQ(sln.maxDepth(input), expect);
        td::deleteTree(input);
    }
    {
        TreeNode* input = td::createTree({1, INT_MIN, 2});
        int expect = 2;
        EXPECT_EQ(sln.maxDepth(input), expect);
        td::deleteTree(input);
    }
}