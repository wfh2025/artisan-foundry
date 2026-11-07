#include <iostream>

class Animal {
public:
    void move() {
        std::cout << __LINE__ << ", " << "Animal void move()" << std::endl;
    }
protected:
    void hello() {
        std::cout << __LINE__ << ", " << "Animal void hello()" << std::endl;
    }
private:
    void word() {
        std::cout << __LINE__ << ", " << "Animal  void word()" << std::endl;
    }
};

class Cat: public Animal {
public:
    Cat(std::string name):m_name(name){
        std::cout << __LINE__ << ", " << "Cat(std::string name)" << std::endl;
    }
    void walk() {
        hello();
        std::cout << __LINE__ << ", " << "Cat void walk(), " << m_name << std::endl;
    }
private:
    std::string m_name;
};
int main() {
    Cat cat("mao");
    cat.move();
    cat.walk();

    return 0;
}

// 运行结果:
// 21, Cat(std::string name)
// 6, Animal void move()
// 10, Animal void hello()
// 25, Cat void walk(), mao
// Program ended with exit code: 0