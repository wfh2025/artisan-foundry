#include <iostream>
#include <random>

#include "gtest/gtest.h"
#include "spdlog/spdlog.h"

TEST(TestCaseChore, 001)
{
    static auto getRandomValue = []() -> int {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dis(0, 1000);
        return dis(gen);
    };

    class Chore
    {
    public:
        Chore() : _id(getRandomValue())
        {
            SPDLOG_INFO("Chore(), id: {}", _id);
        }
        Chore(const Chore& other)
        {
            /**
             * 1. _id赋值并不符合传统拷贝构造函数语义
             * 2. 根本目的在于标明对象，每个对象都有不同的ID，以便于观察对象的创建/析构
             */
            this->_id = getRandomValue();
            SPDLOG_INFO("Chore(const Chore& other), id: {}, other: {}", _id, other._id);
        }
        Chore(Chore&& other) noexcept : _id(other._id)
        {
            other._id = -1;
            SPDLOG_INFO("Chore(Chore&&), new_id: {}, old_id: {}", _id, other._id);
        }
        Chore& operator=(const Chore& other)
        {
            SPDLOG_INFO("Chore& operator=(const Chore& other), curId: {}, inputId: {}", _id, other._id);
            return *this;
        }

        Chore& operator=(Chore&& other) noexcept
        {
            _id = other._id;
            other._id = -1;
            SPDLOG_INFO("Chore& operator=(Chore&& other) noexcept, cur: {}, other: {}", _id, other._id);
            return *this;
        }
        ~Chore()
        {
            SPDLOG_INFO("~Chore(), id: {}", _id);
        }

    private:
        int _id;
    };
    {
        SPDLOG_INFO("{:-^50}", "initializer_list");
        std::vector<Chore> chores = {Chore(), Chore(), Chore()};
    }

    {
        SPDLOG_INFO("{:-^50}", "vector reallocation");
        std::vector<Chore> chores;

        chores.emplace_back(); // 1
        chores.emplace_back(); // 2 - 可能触发重新分配，导致元素移动
        chores.emplace_back(); // 3
        chores.emplace_back(); // 4
        chores.emplace_back(); // 5 - 可能再次触发重新分配
    }
    {
        SPDLOG_INFO("{:-^50}", "chores.emplace_back();");
        std::vector<Chore> chores;
        chores.emplace_back(); // 直接调用Chore构造函数
    }
    {
        SPDLOG_INFO("{:-^50}", "chores.emplace_back(Chore());");
        std::vector<Chore> chores;
        chores.emplace_back(Chore());
    }
    {
        SPDLOG_INFO("{:-^50}", "chores.push_back(Chore());");
        std::vector<Chore> chores;
        chores.push_back(Chore());
    }

    {
        SPDLOG_INFO("{:-^50}", "chores.emplace_back(ch);");
        std::vector<Chore> chores;
        Chore ch;
        chores.emplace_back(ch);
        // chores.emplace_back(std::move(var)); // 是错误行为
    }

    {
        SPDLOG_INFO("{:-^50}", "chores.push_back(ch);");
        std::vector<Chore> chores;
        Chore ch;
        chores.push_back(ch);
    }

    {
        SPDLOG_INFO("{:-^50}", "Chore& operator=(Chore&& other) noexcept");
        Chore a0;
        Chore a1;
        a1 = std::move(a0);
    }
    {
        SPDLOG_INFO("{:-^50}", "Chore& operator=(const Chore& other)");
        Chore ch0;
        Chore ch1;
        ch1 = ch0;
    }

    {
        SPDLOG_INFO("{:-^50}", "Chore(Chore&& other) noexcept");
        Chore origin;
        Chore moved = std::move(origin);
    }

    {
        SPDLOG_INFO("{:-^50}", "Chore fn()");
        auto fn = []() -> Chore {
            Chore ch;
            SPDLOG_INFO("exec fn");
            return ch;
        };
        SPDLOG_INFO("before fn");
        Chore x = fn();
        SPDLOG_INFO("after fn");
    }
    {
        SPDLOG_INFO("{:-^50}", "fn(Chore& ch)");
        auto fn = [](Chore& ch) { SPDLOG_INFO("exec fn"); };
        Chore ch;
        SPDLOG_INFO("before fn");
        fn(ch);
        SPDLOG_INFO("after fn");
    }
    {
        SPDLOG_INFO("{:-^50}", "fn(Chore ch)");
        auto fn = [](Chore ch) { SPDLOG_INFO("exec fn"); };
        Chore ch;
        SPDLOG_INFO("before fn");
        fn(ch);
        SPDLOG_INFO("after fn");
    }

    {
        SPDLOG_INFO("{:-^50}", "Chore a1 = Chore(a0)");
        Chore a0;
        Chore a1 = Chore(a0);
    }
    {
        SPDLOG_INFO("{:-^50}", "Chore a1 = a0");
        Chore a0;
        Chore a1 = a0;
    }
    {
        SPDLOG_INFO("{:-^50}", "Chore a1(a0)");
        Chore a0;
        Chore a1(a0);
    }
    {
        SPDLOG_INFO("{:-^50}", "Chore ch;");
        Chore ch;
    }
    {
        SPDLOG_INFO("{:-^50}", "no process");
        // Empty parentheses interpreted as a function declaration
        // 1. 编译器解析成函数声明，
        // 2. 没有调用构造函数
        // 3. 编译器会告警：Empty parentheses interpreted as a function declaration
        // 4. 效果等于什么都没做
        // Chore ch();
    }
}

// 运行结果
// any_test.cpp:59    -----------------initializer_list-----------------
// any_test.cpp:21    Chore(), id: 698
// any_test.cpp:21    Chore(), id: 38
// any_test.cpp:21    Chore(), id: 994
// any_test.cpp:30    Chore(const Chore& other), id: 43, other: 698
// any_test.cpp:30    Chore(const Chore& other), id: 137, other: 38
// any_test.cpp:30    Chore(const Chore& other), id: 870, other: 994
// any_test.cpp:52    ~Chore(), id: 994
// any_test.cpp:52    ~Chore(), id: 38
// any_test.cpp:52    ~Chore(), id: 698
// any_test.cpp:52    ~Chore(), id: 870
// any_test.cpp:52    ~Chore(), id: 137
// any_test.cpp:52    ~Chore(), id: 43
// any_test.cpp:64    ---------------vector reallocation----------------
// any_test.cpp:21    Chore(), id: 614
// any_test.cpp:21    Chore(), id: 728
// any_test.cpp:35    Chore(Chore&&), new_id: 614, old_id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:21    Chore(), id: 426
// any_test.cpp:35    Chore(Chore&&), new_id: 614, old_id: -1
// any_test.cpp:35    Chore(Chore&&), new_id: 728, old_id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:21    Chore(), id: 584
// any_test.cpp:21    Chore(), id: 537
// any_test.cpp:35    Chore(Chore&&), new_id: 614, old_id: -1
// any_test.cpp:35    Chore(Chore&&), new_id: 728, old_id: -1
// any_test.cpp:35    Chore(Chore&&), new_id: 426, old_id: -1
// any_test.cpp:35    Chore(Chore&&), new_id: 584, old_id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: 537
// any_test.cpp:52    ~Chore(), id: 584
// any_test.cpp:52    ~Chore(), id: 426
// any_test.cpp:52    ~Chore(), id: 728
// any_test.cpp:52    ~Chore(), id: 614
// any_test.cpp:74    --------------chores.emplace_back();--------------
// any_test.cpp:21    Chore(), id: 99
// any_test.cpp:52    ~Chore(), id: 99
// any_test.cpp:79    ----------chores.emplace_back(Chore());-----------
// any_test.cpp:21    Chore(), id: 284
// any_test.cpp:35    Chore(Chore&&), new_id: 284, old_id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: 284
// any_test.cpp:84    ------------chores.push_back(Chore());------------
// any_test.cpp:21    Chore(), id: 559
// any_test.cpp:35    Chore(Chore&&), new_id: 559, old_id: -1
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:52    ~Chore(), id: 559
// any_test.cpp:90    -------------chores.emplace_back(ch);-------------
// any_test.cpp:21    Chore(), id: 251
// any_test.cpp:30    Chore(const Chore& other), id: 936, other: 251
// any_test.cpp:52    ~Chore(), id: 251
// any_test.cpp:52    ~Chore(), id: 936
// any_test.cpp:98    --------------chores.push_back(ch);---------------
// any_test.cpp:21    Chore(), id: 607
// any_test.cpp:30    Chore(const Chore& other), id: 922, other: 607
// any_test.cpp:52    ~Chore(), id: 607
// any_test.cpp:52    ~Chore(), id: 922
// any_test.cpp:105    -----Chore& operator=(Chore&& other) noexcept-----
// any_test.cpp:21    Chore(), id: 258
// any_test.cpp:21    Chore(), id: 328
// any_test.cpp:47    Chore& operator=(Chore&& other) noexcept, cur: 258, other: -1
// any_test.cpp:52    ~Chore(), id: 258
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:111    -------Chore& operator=(const Chore& other)-------
// any_test.cpp:21    Chore(), id: 960
// any_test.cpp:21    Chore(), id: 564
// any_test.cpp:39    Chore& operator=(const Chore& other), curId: 564, inputId: 960
// any_test.cpp:52    ~Chore(), id: 564
// any_test.cpp:52    ~Chore(), id: 960
// any_test.cpp:118    ----------Chore(Chore&& other) noexcept-----------
// any_test.cpp:21    Chore(), id: 178
// any_test.cpp:35    Chore(Chore&&), new_id: 178, old_id: -1
// any_test.cpp:52    ~Chore(), id: 178
// any_test.cpp:52    ~Chore(), id: -1
// any_test.cpp:124    --------------------Chore fn()--------------------
// any_test.cpp:130    before fn
// any_test.cpp:21    Chore(), id: 54
// any_test.cpp:127    exec fn
// any_test.cpp:132    after fn
// any_test.cpp:52    ~Chore(), id: 54
// any_test.cpp:135    ------------------fn(Chore& ch)-------------------
// any_test.cpp:21    Chore(), id: 969
// any_test.cpp:138    before fn
// any_test.cpp:136    exec fn
// any_test.cpp:140    after fn
// any_test.cpp:52    ~Chore(), id: 969
// any_test.cpp:143    -------------------fn(Chore ch)-------------------
// any_test.cpp:21    Chore(), id: 86
// any_test.cpp:146    before fn
// any_test.cpp:30    Chore(const Chore& other), id: 251, other: 86
// any_test.cpp:144    exec fn
// any_test.cpp:52    ~Chore(), id: 251
// any_test.cpp:148    after fn
// any_test.cpp:52    ~Chore(), id: 86
// any_test.cpp:152    ---------------Chore a1 = Chore(a0)---------------
// any_test.cpp:21    Chore(), id: 477
// any_test.cpp:30    Chore(const Chore& other), id: 285, other: 477
// any_test.cpp:52    ~Chore(), id: 285
// any_test.cpp:52    ~Chore(), id: 477
// any_test.cpp:157    ------------------Chore a1 = a0-------------------
// any_test.cpp:21    Chore(), id: 405
// any_test.cpp:30    Chore(const Chore& other), id: 783, other: 405
// any_test.cpp:52    ~Chore(), id: 783
// any_test.cpp:52    ~Chore(), id: 405
// any_test.cpp:162    -------------------Chore a1(a0)-------------------
// any_test.cpp:21    Chore(), id: 379
// any_test.cpp:30    Chore(const Chore& other), id: 558, other: 379
// any_test.cpp:52    ~Chore(), id: 558
// any_test.cpp:52    ~Chore(), id: 379
// any_test.cpp:167    --------------------Chore ch;---------------------
// any_test.cpp:21    Chore(), id: 968
// any_test.cpp:52    ~Chore(), id: 968
// any_test.cpp:171    --------------------no process--------------------
