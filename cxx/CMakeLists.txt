cmake_minimum_required(VERSION 3.0...1024.0)
project(LearnCxx)

set(ART_CXX_ROOT "${CMAKE_SOURCE_DIR}")
set(ART_CXX_DEPS_DIR "${ART_CXX_ROOT}/.deps")
set(ART_CXX_VENDOR_DIR "${ART_CXX_ROOT}/../vendor")

set(ART_CXX_OUTPUT "${CMAKE_BINARY_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${ART_CXX_OUTPUT}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${ART_CXX_OUTPUT}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${ART_CXX_OUTPUT}/lib")

#: clangd 后台索引缓存软链到源码根目录, 避免被 make clean/distclean 清掉后全量重建索引
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/.cache")
file(REMOVE_RECURSE "${CMAKE_BINARY_DIR}/.cache")
file(CREATE_LINK "${CMAKE_SOURCE_DIR}/.cache" "${CMAKE_BINARY_DIR}/.cache" SYMBOLIC)

add_subdirectory(main)
