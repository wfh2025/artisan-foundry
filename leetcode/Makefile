PROJ_DIR                 := $(abspath $(CURDIR))
DEPS_DIR                 := ${PROJ_DIR}/deps
BUILD_DIR                := ${PROJ_DIR}/build/main
PROJ_CC                  := $(shell command -v cc)
PROJ_CXX                 := $(shell command -v c++)
PROJ_CMAKE               := cmake
PROJ_CMAKE_GENERATOR     := Ninja
RM                       := rm -fr
MKDIR                    := mkdir -p
.DEFAULT_GOAL            := help

export NINJA_STATUS      := [%f/%t running:%r elapsed:%es] 
help:  ## 打印帮助
		@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
all: deps build   ## 构建所有
build: generate   ## 构建自研代码
	${PROJ_CMAKE} --build "${BUILD_DIR}" --parallel
generate: clean  ## cmake生成
	${PROJ_CMAKE} -B "${BUILD_DIR}" -S "${PROJ_DIR}" \
	-G "${PROJ_CMAKE_GENERATOR}" \
	-DCMAKE_C_COMPILER="${PROJ_CC}" \
	-DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
	-DCMAKE_MESSAGE_LOG_LEVEL=FATAL_ERROR -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
deps: clean ## 构建依赖
	${RM} "${DEPS_DIR}" && mkdir -p "${DEPS_DIR}" && ${PROJ_DIR}/entry.sh display_elapsed build_deps
clean:  ## 删除临时目录
	${RM} "${BUILD_DIR}"
run: build ## 运行
	DYLD_LIBRARY_PATH=${BUILD_DIR}/lib:${DEPS_DIR}/qt/lib DYLD_FRAMEWORK_PATH=${DEPS_DIR}/qt/lib ${BUILD_DIR}/bin/bin-leetcode
gdb: build ## 调试
	DYLD_LIBRARY_PATH=${BUILD_DIR}/lib lldb ${BUILD_DIR}/bin/bin-leetcode
print-%: ## 打印变量
	@echo $* = $($*)
.PHONY: all clean build deps run generate
