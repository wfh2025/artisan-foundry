#include <climits>
#include <queue>
#include <stack>
#include <vector>

#include "leetcode/core/leetcode_structs.hpp"

namespace td
{
    /* INT_MIN 为null */
    TreeNode* createTree(const std::vector<int>& vals)
    {
        if (vals.empty())
        {
            return nullptr;
        }

        TreeNode* root = new TreeNode(vals[0]);
        std::queue<TreeNode*> q;
        q.push(root);

        int i = 1;
        while (!q.empty() && i < vals.size())
        {
            TreeNode* cur = q.front();
            q.pop();

            // 左节点
            if (i < vals.size() && vals[i] != INT_MIN)
            {
                cur->left = new TreeNode(vals[i]);
                q.push(cur->left);
            }
            i++;

            // 右节点
            if (i < vals.size() && vals[i] != INT_MIN)
            {
                cur->right = new TreeNode(vals[i]);
                q.push(cur->right);
            }
            i++;
        }
        return root;
    }

    void deleteTree(TreeNode* root)
    {
        if (nullptr == root)
        {
            return;
        }
        deleteTree(root->left);
        deleteTree(root->right);
        delete root;
    }

} // namespace td