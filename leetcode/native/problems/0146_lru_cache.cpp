#include "leetcode/leetcode.hpp"

TEST(lru_cache_146, 001)
{
    class LRUCache
    {
    public:
        LRUCache(int capacity) : _cap(capacity) {}

        int get(int key)
        {
            auto it = _map.find(key);
            if (it == _map.end())
            {
                return -1;
            }
            _cache.splice(_cache.begin(), _cache, it->second);
            return it->second->second;
        }

        void put(int key, int value)
        {
            auto it = _map.find(key);
            if (it != _map.end())
            {
                it->second->second = value;
                _cache.splice(_cache.begin(), _cache, it->second);
                return;
            }
            if (_cap == _cache.size())
            {
                std::pair<int, int> last = _cache.back();
                _cache.pop_back();
                _map.erase(last.first);
            }
            _cache.push_front({key, value});
            _map[key] = _cache.begin();
        }

    private:
        int _cap;
        std::list<std::pair<int, int>> _cache;
        std::unordered_map<int, std::list<std::pair<int, int>>::iterator> _map;
    };

    {
        LRUCache lru(2);
        lru.put(1, 1);
        lru.put(2, 2);

        EXPECT_EQ(lru.get(1), 1);
        EXPECT_EQ(lru.get(3), -1);
    }
    {
        LRUCache lru(2);
        lru.put(1, 1);
        lru.put(1, 100); // 更新 Key 1

        EXPECT_EQ(lru.get(1), 100); // 应该返回更新后的值 100
    }
    {
        LRUCache lru(2);
        lru.put(1, 1); // 缓存是 {1=1}
        lru.put(2, 2); // 缓存是 {1=1, 2=2}

        EXPECT_EQ(lru.get(1), 1); // 返回 1，最近访问顺序变为 {2=2, 1=1}

        lru.put(3, 3);             // 容量已满，淘汰最久未用的 Key 2。缓存变为 {1=1, 3=3}
        EXPECT_EQ(lru.get(2), -1); // 2 已被淘汰，返回 -1

        lru.put(4, 4);             // 容量已满，淘汰最久未用的 Key 1。缓存变为 {3=3, 4=4}
        EXPECT_EQ(lru.get(1), -1); // 1 已被淘汰，返回 -1
        EXPECT_EQ(lru.get(3), 3);  // 返回 3
        EXPECT_EQ(lru.get(4), 4);  // 返回 4
    }

    {
        LRUCache lru(3);
        lru.put(1, 1);
        lru.put(2, 2);
        lru.put(3, 3);

        // 当前最近访问顺序(头->尾)：3, 2, 1

        lru.get(1);    // 访问 1，顺序变为：1, 3, 2
        lru.put(4, 4); // 容量 3 已满，淘汰最久未用的 2。剩余 1, 3, 4

        EXPECT_EQ(lru.get(2), -1); // 2 被淘汰
        EXPECT_EQ(lru.get(1), 1);
        EXPECT_EQ(lru.get(3), 3);
    }

    {
        LRUCache lru(1);
        lru.put(1, 1);
        EXPECT_EQ(lru.get(1), 1);

        lru.put(2, 2); // 容量 1，淘汰 1
        EXPECT_EQ(lru.get(1), -1);
        EXPECT_EQ(lru.get(2), 2);
    }
}