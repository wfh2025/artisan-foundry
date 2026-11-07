#include <iostream>
#include <random>

static int gen_random() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, 99);
    return dis(gen);
}

class A {
  public:
    A():m_value(gen_random()) {
        std::cout << __LINE__ << ", A(), " << "value = " << this->m_value << std::endl;
    }
    A(const A& other) {
        this->m_value = gen_random();
        std::cout << __LINE__ << ", A(const A& other), " << "value = " << this->m_value << std::endl;
    }
    ~A() {
        std::cout << __LINE__ << ", ~A(), " << "value = " << this->m_value << std::endl;
    }
    
    void hello() {
        std::cout << __LINE__ << ", void hello(), " << "value = " << this->m_value << std::endl;
    }
    
    A& operator=(A & other) {
        std::cout << __LINE__ << ", A& operator=(A & other)  " << std::endl;
        this->m_value = gen_random();
        return *this;
    }

  private:
    int m_value;
};


int main() {
    // 1. unique_ptr禁止拷贝构造函数
    // 2. unique_ptr禁止赋值操作
    // 3. unique_ptr在同一时间，只有一个unique_ptr拥有对象所有权
    // 4. unique_ptr可以通过移动语义来转移所有权,转移后就不能再用以前的unique_ptr变量操作
    std::unique_ptr<A> p1(new A());
    std::cout << __LINE__ << ", " << p1 << std::endl;
    
    
    std::unique_ptr<A> p2 = std::move(p1);
    
    if (nullptr == p1) {
        std::cout << __LINE__ << ", " << p1 << std::endl;
    }
    
    p2->hello();

    return 0;
}


// 运行结果
// 14, A(), value = 60
// 45, 0x600003578050
// 51, 0x0
// 25, void hello(), value = 60
// 21, ~A(), value = 60
// Program ended with exit code: 0