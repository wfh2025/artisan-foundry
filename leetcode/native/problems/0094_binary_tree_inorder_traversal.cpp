#include "leetcode/leetcode.hpp"

TEST(binary_tree_inorder_traversal_94, recursive)
{
    class Solution
    {
    public:
        vector<int> inorderTraversal(TreeNode* root)
        {
            std::vector<int> arr;
            inorder(root, arr);
            return arr;
        }

        void inorder(TreeNode* root, std::vector<int>& res)
        {
            if (nullptr == root)
            {
                return;
            }
            inorder(root->left, res);
            res.push_back(root->val);
            inorder(root->right, res);
        }
    };

    Solution sln;
    {
        TreeNode* input = td::createTree({1, INT_MIN, 2, 3});
        std::vector<int> expect = {1, 3, 2};
        EXPECT_EQ(sln.inorderTraversal(input), expect);
        td::deleteTree(input);
    }
    {
        TreeNode* input = td::createTree({1, 2, 3, 4, 5, INT_MIN, 8, INT_MIN, INT_MIN, 6, 7, 9});
        std::vector<int> expect = {4, 2, 6, 5, 7, 1, 3, 9, 8};
        EXPECT_EQ(sln.inorderTraversal(input), expect);
        td::deleteTree(input);
    }
}

TEST(binary_tree_inorder_traversal_94, stack)
{
    class Solution
    {
    public:
        vector<int> inorderTraversal(TreeNode* root)
        {
            TreeNode* cur = root;
            std::vector<int> arr;
            std::stack<TreeNode*> stk;
            while (true)
            {
                if ((cur == nullptr) && stk.empty())
                {
                    break;
                }

                while (cur != nullptr)
                {
                    stk.push(cur);
                    cur = cur->left;
                }
                cur = stk.top();
                stk.pop();

                arr.push_back(cur->val);
                cur = cur->right;
            }

            return arr;
        }
    };

    Solution sln;
    {
        TreeNode* input = td::createTree({1, INT_MIN, 2, 3});
        std::vector<int> expect = {1, 3, 2};
        EXPECT_EQ(sln.inorderTraversal(input), expect);
        td::deleteTree(input);
    }
    {
        TreeNode* input = td::createTree({1, 2, 3, 4, 5, INT_MIN, 8, INT_MIN, INT_MIN, 6, 7, 9});
        std::vector<int> expect = {4, 2, 6, 5, 7, 1, 3, 9, 8};
        EXPECT_EQ(sln.inorderTraversal(input), expect);
        td::deleteTree(input);
    }
}