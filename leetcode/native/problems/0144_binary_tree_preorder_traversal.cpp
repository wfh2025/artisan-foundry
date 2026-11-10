#include "leetcode/leetcode.hpp"

TEST(binary_tree_preorder_traversal, stack)
{
    class Solution
    {
    public:
        vector<int> preorderTraversal(TreeNode* root)
        {
            std::vector<int> arr;
            if (root == nullptr)
            {
                return arr;
            }
            std::stack<TreeNode*> stk;
            stk.push(root);
            while (!stk.empty())
            {
                TreeNode* cur = stk.top();
                stk.pop();

                arr.push_back(cur->val);
                if (cur->right != nullptr)
                {
                    stk.push(cur->right);
                }
                if (cur->left != nullptr)
                {
                    stk.push(cur->left);
                }
            }
            return arr;
        }
    };

    Solution sln;
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, 2, 3, 4, 5, INT_MIN, 8, INT_MIN, INT_MIN, 6, 7, 9});
        EXPECT_THAT(sln.preorderTraversal(tree), testing::ContainerEq(std::vector<int>{1, 2, 4, 5, 6, 7, 3, 8, 9}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, INT_MIN, 2, 3});
        EXPECT_THAT(sln.preorderTraversal(tree), testing::ContainerEq(std::vector<int>{1, 2, 3}));
        td::deleteTree(tree);
    }
}

TEST(binary_tree_preorder_traversal, dfs)
{
    class Solution
    {
    public:
        vector<int> preorderTraversal(TreeNode* root)
        {
            std::vector<int> arr;
            dfs(root, arr);
            return arr;
        }

        void dfs(TreeNode* node, std::vector<int>& res)
        {
            if (node == nullptr)
            {
                return;
            }
            res.push_back(node->val);
            dfs(node->left, res);
            dfs(node->right, res);
        }
    };
    Solution sln;
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, 2, 3, 4, 5, INT_MIN, 8, INT_MIN, INT_MIN, 6, 7, 9});
        EXPECT_THAT(sln.preorderTraversal(tree), testing::ContainerEq(std::vector<int>{1, 2, 4, 5, 6, 7, 3, 8, 9}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, INT_MIN, 2, 3});
        EXPECT_THAT(sln.preorderTraversal(tree), testing::ContainerEq(std::vector<int>{1, 2, 3}));
        td::deleteTree(tree);
    }
}