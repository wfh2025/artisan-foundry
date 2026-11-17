set(TARGET_NAME "tgt-learn-cxx")
set(EXEC_NAME "bin-learn-cxx")

find_package(Threads REQUIRED)
find_package(GTest CONFIG REQUIRED PATHS "${ART_CXX_DEPS_DIR}/googletest" NO_DEFAULT_PATH)
find_package(spdlog CONFIG REQUIRED PATHS "${ART_CXX_DEPS_DIR}/spdlog" NO_DEFAULT_PATH)

add_executable("${TARGET_NAME}" "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp")
set_target_properties("${TARGET_NAME}" PROPERTIES CXX_STANDARD 20
                                                  CXX_STANDARD_REQUIRED ON
                                                  CXX_EXTENSIONS OFF
                                                  UNITY_BUILD OFF
                                                  OUTPUT_NAME "${EXEC_NAME}"
)

target_include_directories("${TARGET_NAME}" PRIVATE "${CMAKE_SOURCE_DIR}")

file(GLOB SRC_FILES CONFIGURE_DEPENDS 
    "${ART_CXX_ROOT}/cstdint/*.h"
    "${ART_CXX_ROOT}/cstdint/*.hpp"
    "${ART_CXX_ROOT}/cstdint/*.cpp"
    "${ART_CXX_ROOT}/cstdint/*.cxx"
)

target_sources("${TARGET_NAME}" PRIVATE ${SRC_FILES})

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
