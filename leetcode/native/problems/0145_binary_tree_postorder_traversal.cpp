#include "leetcode/leetcode.hpp"

TEST(binary_tree_postorder_traversal_145, dfs)
{
    class Solution
    {
    public:
        vector<int> postorderTraversal(TreeNode* root)
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
            dfs(node->left, res);
            dfs(node->right, res);
            res.push_back(node->val);
        }
    };

    Solution sln;
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, 2, 3, 4, 5, INT_MIN, 8, INT_MIN, INT_MIN, 6, 7, 9});
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{4, 6, 7, 5, 2, 9, 8, 3, 1}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, INT_MIN, 2, 3});
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{3, 2, 1}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = td::createTree(std::vector<int>{1});
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{1}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = nullptr;
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{}));
    }
}

TEST(binary_tree_postorder_traversal_145, stack)
{
    class Solution
    {
    public:
        vector<int> postorderTraversal(TreeNode* root)
        {
            if (root == nullptr)
            {
                return {};
            }

            std::vector<int> arr;
            std::stack<TreeNode*> stk;
            stk.push(root);
            while (!stk.empty())
            {
                TreeNode* cur = stk.top();
                stk.pop();
                arr.push_back(cur->val);
                if (cur->left != nullptr)
                {
                    stk.push(cur->left);
                }
                if (cur->right != nullptr)
                {
                    stk.push(cur->right);
                }
            }
            std::reverse(arr.begin(), arr.end());
            return arr;
        }
    };
    Solution sln;
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, 2, 3, 4, 5, INT_MIN, 8, INT_MIN, INT_MIN, 6, 7, 9});
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{4, 6, 7, 5, 2, 9, 8, 3, 1}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = td::createTree(std::vector<int>{1, INT_MIN, 2, 3});
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{3, 2, 1}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = td::createTree(std::vector<int>{1});
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{1}));
        td::deleteTree(tree);
    }
    {
        TreeNode* tree = nullptr;
        EXPECT_THAT(sln.postorderTraversal(tree), testing::ContainerEq(std::vector<int>{}));
    }
}
