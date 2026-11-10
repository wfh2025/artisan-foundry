#pragma once
#include <vector>

#include "leetcode/core/leetcode_structs.hpp"

namespace td
{
    // vec
    extern std::string formatVecInt(const std::vector<int>& vec, bool printAll, size_t headCount = 3, size_t midCount = 3, size_t tailCount = 3);
    extern const std::vector<int> VEC_INT_LEN4_01;
    extern const std::vector<int> VEC_INT_LEN4_02;
    extern const std::vector<int> VEC_INT_LEN5_01;
    extern const std::vector<int> VEC_INT_LEN6_01;
    extern const std::vector<int> VEC_INT_LEN50000_01;

    // list
    ListNode* createList(const std::vector<int>& arr);
    std::vector<int> listToVec(ListNode* head);
    void deleteList(ListNode* head);

    // tree
    TreeNode* createTree(const std::vector<int>& vals);
    void deleteTree(TreeNode* root);

} // namespace td