#include <iostream>

static void test_basic_init() {
    // 可靠的方式：初始化为0
    int a = 0;
    int b{};
    int c = {};
    
    // 不可靠，初始化的值未知
    int d;
    
    std::cout << __LINE__ << "\t" <<
        a << "\t" <<
        b << "\t" <<
        c << "\t" <<
        d << std::endl;
}

static void test_basic_assigment() {
    int e = 42;
    int f{42};
    int g = {42};
    int h(42);
    std::cout << __LINE__ << "\t" <<
        e << "\t" <<
        f << "\t" <<
        g << "\t" <<
        h << std::endl;
}

struct PodStruct {
    uint64_t a;
    char b[256];
    bool c;
};

static void test_arr_init() {
    // 数组长度为3；1，2，3
    int a1[] {1,2,3};
    
    // 数组长度为5；0, 0, 0, 0, 0
    int a2[5]{};
    
    // 数组长度为5；1， 2，3，0，0
    int a3[5] {1,2,3};
    
    // 数组长度为5，未初始化值
    int a4[5];
}

static void test_pod_init() {
    // 要求:
    // 参数顺序与成员顺序一致
    // 省略成员都为0
    // 只能从右到左省略字段
    
    
    // 全部字段为0
    PodStruct p1{};
    
    // 全部字段为0
    PodStruct p2 = {};
    
    // a & b设置，c为0
    PodStruct p3{42, "Hello"};
    
    // 所有字段设置
    PodStruct p4{44, "ku", true};
    
    
    PodStruct p5 = {45, "kud", true};
    
    // PodStruct p6 = 0; ==> 无法编译
    
    // PodStruct p7 = (45, "kud", true); ==> 无法编译
    
    (void) p1;
    (void) p2;
    (void) p3;
    (void) p4;
    (void) p5;
}

struct Taxonomist {
    Taxonomist() {
        std::cout << __LINE__ << ", " << "Taxonomist()" << std::endl;
    }
    Taxonomist(char x) {
        std::cout << __LINE__ << ", " << "Taxonomist(char x)" << ", " << x <<std::endl;
    }
    Taxonomist(int x) {
        std::cout << __LINE__ << ", " << "Taxonomist(int x)" << ", " << x <<std::endl;
    }
    
    Taxonomist(float x) {
        std::cout << __LINE__ << ", " << "Taxonomist(float x)" << ", " << x <<std::endl;
    }
};

static void test_struct_init() {
    // 无参构造函数调用
    Taxonomist t1;
    Taxonomist t2{'c'};
    Taxonomist t3{65537};
    Taxonomist t4{6.02e23f};
    Taxonomist t5('g');
    Taxonomist t6 = {'l'};
    Taxonomist t7{};
    
    // Taxonomist t8(); ==> 函数声明
}

// 大括号使用类成员
// 不能使用小括号
struct JohanVanDerSMut{
    bool gold = true;
    int year_of_accident{1970};
    char key_location[256] = {"xxxxx"};
    
    char f[99] = ("ss");
};
int main() {
    test_basic_init();
    test_basic_assigment();
    test_pod_init();
    test_arr_init();
    test_struct_init();
    return 0;
}

// 运行结果
// 12	0	0	0	2059272384
// 24	42	42	42	42
// 86, Taxonomist()
// 89, Taxonomist(char x), c
// 92, Taxonomist(int x), 65537
// 96, Taxonomist(float x), 6.02e+23
// 89, Taxonomist(char x), g
// 89, Taxonomist(char x), l
// 86, Taxonomist()
// Program ended with exit code: 0