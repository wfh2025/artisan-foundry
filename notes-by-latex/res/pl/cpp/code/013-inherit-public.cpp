#include <iostream>


class Stu {
public:
    void set_grade(std::string grade) {
        m_grade = grade;
    }
    std::string get_grade() {
        return m_grade;
    }
    void set_name(std::string name) {
        m_name = name;
    }
    std::string get_name() {
        return m_name;
    }
    
protected:
    std::string m_grade;
private:
    std::string m_name;
};


class UnderGraduate: public Stu {
public:
    UnderGraduate(std::string major):m_major(major) {
        std::cout << __LINE__ << ", " << "UnderGraduate(std::string major)" << std::endl;
    }
    void show() {
        std::cout
            << __LINE__ << ", "
            << "name = " << get_name() << ", "
            << "grade = " << get_grade() << ", "
            << "grade = " << m_grade << ", "
            << "major = " << m_major
            << std::endl;
    }
private:
    std::string m_major;
};

int main() {
    UnderGraduate stu{"computer"};
    stu.set_grade("dasan");
    stu.set_name("zhangsan");
    stu.show();

    return 0;
}

// 运行结果：
// 29, UnderGraduate(std::string major)
// 33, name = zhangsan, grade = dasan, grade = dasan, major = computer
// Program ended with exit code: 0