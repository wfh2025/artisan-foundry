#include <iostream>

static void test_ref() {
    int a = 42;
    int &a_ref = a;
    int b = 100;
    
    // 应用不能被重定位
    // 将b的值赋值给a
    a_ref = b;
    
    std::cout << __LINE__ << ", " <<
        "a = " << a << ", "<<
        "&a = " << &a << ", " <<
        "a_ref = " << a_ref << ", " <<
        "&a_ref = " << &a_ref << ", " <<
        "b = " << b << ", " <<
        "&b = " << &b << ", " <<
        std::endl;
}

static void test_ptr() {
    int a = 42;
    int *a_ptr = &a;
    int b = 100;
    *a_ptr = b;
    
    std::cout << __LINE__ << ", " <<
        "a = " << a << ", "<<
        "&a = " << &a << ", " <<
        "a_ptr = " << a_ptr << ", " <<
        "b = " << b << ", " <<
        "&b = " << &b << ", " <<
        std::endl;
}

int main() {
    test_ref();
    test_ptr();

    return 0;
}


// 运行结果
// 12, a = 100, &a = 0x7ff7bfeff2dc, a_ref = 100, &a_ref = 0x7ff7bfeff2dc, b = 100, &b = 0x7ff7bfeff2cc, 
// 28, a = 100, &a = 0x7ff7bfeff2dc, a_ptr = 0x7ff7bfeff2dc, b = 100, &b = 0x7ff7bfeff2cc, 
// Program ended with exit code: 0