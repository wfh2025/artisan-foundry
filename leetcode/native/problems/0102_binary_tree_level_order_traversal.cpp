#include "leetcode/leetcode.hpp"

TEST(binary_tree_level_order_traversal_102, queue)
{
    class Solution
    {
    public:
        vector<vector<int>> levelOrder(TreeNode* root)
        {
            std::vector<std::vector<int>> res;
            if (nullptr == root)
            {
                return res;
            }
            std::queue<TreeNode*> q;
            q.push(root);
            while (!q.empty())
            {
                int levelSize = q.size();
                std::vector<int> curVec;
                for (int i = 0; i < levelSize; i++)
                {
                    TreeNode* cur = q.front();
                    q.pop();
                    curVec.push_back(cur->val);
                    if (cur->left != nullptr)
                    {
                        q.push(cur->left);
                    }
                    if (cur->right != nullptr)
                    {
                        q.push(cur->right);
                    }
                }
                res.push_back(curVec);
            }

            return res;
        }
    };

    Solution sln;

    {
        TreeNode* input = td::createTree({3, 9, 20, INT_MIN, INT_MIN, 15, 7});
        std::vector<std::vector<int>> expect = {{3}, {9, 20}, {15, 7}};
        EXPECT_EQ(sln.levelOrder(input), expect);
        td::deleteTree(input);
    }
    {
        TreeNode* input = td::createTree({1});
        std::vector<std::vector<int>> expect = {{1}};
        EXPECT_EQ(sln.levelOrder(input), expect);
        td::deleteTree(input);
    }
}
