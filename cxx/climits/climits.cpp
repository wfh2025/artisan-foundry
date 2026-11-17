#include <climits>

#include "gmock/gmock.h"
#include "gtest/gtest.h"
#include "spdlog/spdlog.h"

#define LOG_MACRO_VALUE(macro) SPDLOG_INFO(#macro " = {}", macro)

TEST(climits_macro, 001)
{
    LOG_MACRO_VALUE(CHAR_BIT);    // 一个字节的位数
    LOG_MACRO_VALUE(CHAR_MIN);    // char 最小值
    LOG_MACRO_VALUE(CHAR_MAX);    // char 最大值
    LOG_MACRO_VALUE(SCHAR_MIN);   // signed char 最小值
    LOG_MACRO_VALUE(SCHAR_MAX);   // signed char 最大值
    LOG_MACRO_VALUE(UCHAR_MAX);   // unsigned char 最大值
    LOG_MACRO_VALUE(MB_LEN_MAX);  // 多字节字符最大字节数

    LOG_MACRO_VALUE(SHRT_MIN);   // short 最小值
    LOG_MACRO_VALUE(SHRT_MAX);   // short 最大值
    LOG_MACRO_VALUE(USHRT_MAX);  // unsigned short 最大值

    LOG_MACRO_VALUE(INT_MIN);   // int 最小值
    LOG_MACRO_VALUE(INT_MAX);   // int 最大值
    LOG_MACRO_VALUE(UINT_MAX);  // unsigned int 最大值

    LOG_MACRO_VALUE(LONG_MIN);   // long 最小值
    LOG_MACRO_VALUE(LONG_MAX);   // long 最大值
    LOG_MACRO_VALUE(ULONG_MAX);  // unsigned long 最大值

    LOG_MACRO_VALUE(LLONG_MIN);   // long long 最小值
    LOG_MACRO_VALUE(LLONG_MAX);   // long long 最大值
    LOG_MACRO_VALUE(ULLONG_MAX);  // unsigned long long 最大值
}
