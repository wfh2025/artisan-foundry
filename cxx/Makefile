PROJ_ROOT              := $(abspath $(CURDIR))
PROJ_DEPS              := ${PROJ_ROOT}/.deps
PROJ_BUILD             := ${PROJ_ROOT}/.build
PROJ_CACHE             := ${PROJ_ROOT}/.cache
PROJ_BUILD_MAIN        := ${PROJ_BUILD}/main
PROJ_SRC               := ${PROJ_ROOT}
PROJ_CMAKE             := cmake
PROJ_RM                := rm -fr
PROJ_MKDIR             := mkdir -p
.DEFAULT_GOAL          := help
PROJ_CMAKE_GENERATOR   := Ninja
PROJ_CC                := $(shell command -v cc)
PROJ_CXX               := $(shell command -v c++)

export NINJA_STATUS      := [%f/%t running:%r elapsed:%es] 
help:  ## 打印帮助
		@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
all: deps build                                                                             ## 构建所有
build: generate                                                                             ## 构建自研代码
	${PROJ_CMAKE} --build "${PROJ_BUILD_MAIN}" --parallel
generate: clean pretty                                                                      ## cmake生成
	${PROJ_CMAKE} -B "${PROJ_BUILD_MAIN}" -S "${PROJ_SRC}" \
	-G "${PROJ_CMAKE_GENERATOR}" \
	-DCMAKE_C_COMPILER="${PROJ_CC}" \
	-DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
	-DCMAKE_MESSAGE_LOG_LEVEL=FATAL_ERROR -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
deps: distclean                                                                             ## 构建依赖
	${PROJ_MKDIR} "${PROJ_DEPS}" && ${PROJ_ROOT}/entry.sh display_elapsed build_deps
clean:                                                                                      ## 删除临时目录
	${PROJ_RM} "${PROJ_BUILD_MAIN}"
distclean:                                                                                  ## 删除build和deps
	${PROJ_RM} "${PROJ_BUILD}" "${PROJ_DEPS}" "${PROJ_CACHE}"
pretty:                                                                                     ## 代码格式化
	${PROJ_ROOT}/entry.sh pretty
run: build                                                                                  ## 运行
	DYLD_LIBRARY_PATH=${PROJ_BUILD_MAIN}/lib ${PROJ_BUILD_MAIN}/bin/bin-learn-cxx
print-%: ## 打印变量
	@echo $* = $($*)
.PHONY: all clean build deps run generate pretty distclean
