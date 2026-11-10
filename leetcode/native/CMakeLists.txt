set(TARGET_NAME "tgt-leetcode")
set(EXEC_NAME "bin-leetcode")

find_package(Threads REQUIRED)
find_package(GTest CONFIG REQUIRED PATHS "${ART_CXX_DEPS_DIR}/googletest" NO_DEFAULT_PATH)
find_package(spdlog CONFIG REQUIRED PATHS "${ART_CXX_DEPS_DIR}/spdlog" NO_DEFAULT_PATH)

add_executable("${TARGET_NAME}" "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp")
set_target_properties("${TARGET_NAME}" PROPERTIES CXX_STANDARD 20
                                                  CXX_STANDARD_REQUIRED ON
                                                  CXX_EXTENSIONS OFF
                                                  UNITY_BUILD ON
                                                  OUTPUT_NAME "${EXEC_NAME}"
)

target_include_directories("${TARGET_NAME}" PRIVATE "${CMAKE_SOURCE_DIR}"
                                                    "${CMAKE_CURRENT_SOURCE_DIR}/include"
                                         
)

file(GLOB PROBLEMS_FILES CONFIGURE_DEPENDS 
    "${CMAKE_CURRENT_SOURCE_DIR}/problems/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/problems/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/problems/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/problems/*.cxx"
)
file(GLOB TESTDATA_FILES CONFIGURE_DEPENDS 
    "${CMAKE_CURRENT_SOURCE_DIR}/testdata/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/testdata/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/testdata/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/testdata/*.cxx"
)
target_sources("${TARGET_NAME}" PRIVATE ${PROBLEMS_FILES}
                                        ${TESTDATA_FILES}
)

target_compile_definitions("${TARGET_NAME}" PRIVATE
                            SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_DEBUG
)

target_compile_options("${TARGET_NAME}" PRIVATE -ggdb
                                                -Wno-unused-value
                                                -Wno-unused-parameter
                                                -Wno-return-stack-address
                                                -Wno-tautological-undefined-compare
)

target_link_libraries("${TARGET_NAME}" PRIVATE Threads::Threads
                                               GTest::gtest
                                               GTest::gmock
                                               spdlog::spdlog
)
