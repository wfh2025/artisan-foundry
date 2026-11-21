PROJ_ROOT              := $(abspath $(CURDIR))
PROJ_VENDOR            := ${PROJ_ROOT}/vendor
.DEFAULT_GOAL          := help

help:  ## 打印帮助
		@awk 'BEGIN {FS = ":.*##"; printf "\n\Usage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
pretty:                                        ## 格式化
	${PROJ_ROOT}/artisan.sh pretty
dbg:                                           ## 调试
	${PROJ_ROOT}/artisan.sh dbg
.PHONY: all prettyåå