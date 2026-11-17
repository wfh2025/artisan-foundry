#!/usr/bin/env bash

PROJ_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
PROJ_DEPS="${PROJ_ROOT}/.deps"
PROJ_BUILD="${PROJ_ROOT}/.build"
PROJ_VENDOR="${PROJ_ROOT}/../vendor"
PROJ_CUR_SCRIPT="${PROJ_ROOT}/${BASH_SOURCE[0]##*/}"

PROJ_OS="$(uname -s)"
PROJ_ARCH="$(uname -m)"

PROJ_CC=$(command -v cc)
PROJ_CXX=$(command -v c++)
PROJ_CMAKE=$(command -v cmake)
PROJ_CLANGFORMAT=$(command -v clang-format)

PROJ_CMAKE_GENERATOR="Ninja"

PROJ_SHFMT="${PROJ_VENDOR}/shfmt-3.14.1/${PROJ_OS}/${PROJ_ARCH}/shfmt"
PROJ_SHELLCHECK="${PROJ_VENDOR}/shellcheck-0.11.0/${PROJ_OS}/${PROJ_ARCH}/shellcheck"

PROJ_CLANGFORMAT_STYLE="${PROJ_ROOT}/.clang-format"

#: 用 shfmt 格式化单个文件
function _format_shell_file() {
    local file="$1"
    "${PROJ_SHFMT}" --indent 4 \
              --case-indent \
              --keep-padding \
              --space-redirects \
        --language-dialect auto --write "${file}"
}

#: 用 shellcheck 最严格档检查单个文件
function _check_shell_file() {
    local file="$1"
    "${PROJ_SHELLCHECK}" --check-sourced \
                         --color=auto \
                         --extended-analysis=true \
                         --format=tty \
                         --enable=all \
                         --source-path='SCRIPTDIR' \
                         --shell=bash \
                         --severity=style \
                         --wiki-link-count=0 \
                         --external-sources "${file}"
}

#: 递归格式化并静态检查所有 shell 脚本(shfmt + shellcheck)
function _pretty_shell() {
    local file rc=0 total=0 fail=0

    local -a blacklist=(
        -path "${PROJ_BUILD}"
        -o -path "${PROJ_DEPS}"
        -o -name '.*'
    )

    local -a suffixes=(
        -name '*.sh'
        -o -name '*.bash'
    )

    local -a find_args=(
        "${PROJ_ROOT}"
        \(
        "${blacklist[@]}"
        \) -prune -o
        \(
        "${suffixes[@]}"
        \)
        -type f
        -print
    )

    while IFS= read -r file; do
        [[ -n ${file} ]] || continue
        total=$((total + 1))
        printf '==> [pretty] %s\n' "${file}"
        if ! _format_shell_file "${file}" ||
            ! _check_shell_file "${file}"; then
            fail=$((fail + 1))
            rc=1
        fi
    done < <(find "${find_args[@]}" || true)

    printf '==> [pretty] total=%d fail=%d\n' "${total}" "${fail}"
    return "${rc}"
}

#: 批量导出clang-format内置style配置
function _dump_clangformat_styles() {
    local out_dir="${1:-.}"
    local style file
    local total=0 fail=0 rc=0
    local -a styles=(
        GNU
        LLVM
        Google
        WebKit
        Mozilla
        Chromium
        Microsoft
    )

    mkdir -p "${out_dir}" || return 1
    out_dir=$(cd -- "${out_dir}" && pwd -P) || return 1
    for style in "${styles[@]}"; do
        file="${out_dir}/cpp-$(printf '%s' "${style}" | tr '[:upper:]' '[:lower:]').clang-format"
        total=$((total + 1))
        printf '==> [clang-format] %s -> %s\n' "${style}" "${file}"
        if "${PROJ_CLANGFORMAT}" -style="${style}" -dump-config > "${file}"; then
            continue
        fi
        rm -f "${file}"
        fail=$((fail + 1))
        rc=1
        printf '==> [clang-format] FAIL %s\n' "${style}"
    done
    printf '==> [clang-format] total=%d fail=%d\n' "${total}" "${fail}"
    return "${rc}"
}

#: 用 clang-format格式化文件
function _format_file_by_clangformat() {
    local file="$1"
    "${PROJ_CLANGFORMAT}" --Werror \
        --fail-on-incomplete-format \
        --style="file:${PROJ_CLANGFORMAT_STYLE}" \
        -i "${file}"
}

#: 用clang-format检查文件
function _check_file_by_clangformat() {
    local file="$1"
    "${PROJ_CLANGFORMAT}" --Werror --dry-run \
        --fail-on-incomplete-format \
        --style="file:${PROJ_CLANGFORMAT_STYLE}" \
        "${file}"
}

#: 递归格式化并静态检查所有 C/C++/Java文件
function _pretty_by_clangformat() {
    local file rc=0 total=0 fail=0

    local -a blacklist=(
        -path "${PROJ_BUILD}"
        -o -path "${PROJ_DEPS}"
        -o -name '.*'
    )

    local -a suffixes=(
        -name '*.c'
        -o -name '*.cc'
        -o -name '*.cpp'
        -o -name '*.cxx'
        -o -name '*.h'
        -o -name '*.hpp'
        -o -name '*.hh'
        -o -name '*.hxx'
        -o -name '*.java'
    )

    local -a find_args=(
        "${PROJ_ROOT}"
        \(
        "${blacklist[@]}"
        \) -prune -o
        \(
        "${suffixes[@]}"
        \)
        -type f
        -print
    )

    while IFS= read -r file; do
        [[ -n ${file} ]] || continue
        total=$((total + 1))
        printf '==> [pretty] %s\n' "${file}"
        if ! _format_file_by_clangformat "${file}" ||
            ! _check_file_by_clangformat "${file}"; then
            fail=$((fail + 1))
            rc=1
        fi
    done < <(find "${find_args[@]}" || true)

    printf '==> [pretty] total=%d fail=%d\n' "${total}" "${fail}"
    return "${rc}"
}

#: 格式化并静态检查代码
function pretty() {
    local rc=0
    _pretty_shell || rc=1
    _pretty_by_clangformat || rc=1
    return "${rc}"
}

#: 构建gflags
function _build_gflags() {
    local name="gflags"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/gflags-2.2.2"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"
    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_POLICY_VERSION_MINIMUM=3.10 \
          -DCMAKE_MINIMUM_REQUIRED_VERSION=3.10 \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install
    rm -fr "${build_dir}"
}

#: 构建json
function _build_nlohmann_json() {
    local name="json"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"

    local src="${PROJ_VENDOR}/json-3.12.0"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"

    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DJSON_BuildTests=OFF \
          -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install

    rm -fr "${build_dir}"
}

#: 构建leveldb
function _build_leveldb() {
    local name="leveldb"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/leveldb-1.23"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"

    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER="${PROJ_CC}" \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" \
          -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_POLICY_VERSION_MINIMUM=3.10 \
          -DLEVELDB_BUILD_BENCHMARKS=OFF \
          -DLEVELDB_BUILD_TESTS=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install

    rm -fr "${build_dir}"
}

#: 构建libressl
function _build_libressl() {
    local name="libressl"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/libressl-4.2.1"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"

    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER="${PROJ_CC}" \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DLIBRESSL_TESTS=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install

    rm -fr "${build_dir}"
}

#: 构建pugixml
function _build_pugixml() {
    local name="pugixml"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/pugixml-1.15"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"
    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install
    rm -fr "${build_dir}"
}

#: 构建fmt
function _build_fmt() {
    local name="fmt"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/fmt-12.0.0"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"
    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DFMT_TEST=OFF -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install
    rm -fr "${build_dir}"
}

#: 构建civetweb
function _build_civetweb() {
    local name="civetweb"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/civetweb-1.16"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"

    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
          -DBUILD_TESTING=OFF \
          -DCIVETWEB_BUILD_TESTING=OFF \
          -DCIVETWEB_ALLOW_WARNINGS=OFF \
          -DCIVETWEB_ENABLE_SSL=OFF \
          -DCIVETWEB_ENABLE_SSL_DYNAMIC_LOADING=OFF \
          -DCIVETWEB_ENABLE_SERVER_STATS=ON \
          -DCIVETWEB_ENABLE_CXX=ON \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER="${PROJ_CC}" \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" \
          -DBUILD_SHARED_LIBS=OFF \
          -DCIVETWEB_ENABLE_MEMORY_DEBUGGING=ON \
          -DCIVETWEB_ENABLE_WEBSOCKETS=ON \
          -DCIVETWEB_INSTALL_EXECUTABLE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install

    rm -fr "${build_dir}"
}

#: CMake 构建并安装 spdlog 到 deps/spdlog
function _build_spdlog() {
    local name="spdlog"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/spdlog-1.17.0"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"

    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -G "${PROJ_CMAKE_GENERATOR}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" \
          -DSPDLOG_BUILD_SHARED=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install

    rm -fr "${build_dir}"
}

#: CMake 构建并安装 googletest 到 deps/googletest
function _build_googletest() {
    local name="googletest"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/googletest-1.18.0"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"
    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -G "${PROJ_CMAKE_GENERATOR}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER="${PROJ_CC}" \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install
    rm -fr "${build_dir}"
}

#: 构建abseil-cpp
function _build_abseil_cpp() {
    local name="abseil-cpp"
    local build_dir="${PROJ_BUILD}/${name}"
    local install_dir="${PROJ_DEPS}/${name}"
    local src="${PROJ_VENDOR}/abseil-cpp-20250814.1"

    rm -fr "${build_dir}" "${install_dir}" && mkdir -p "${install_dir}"
    ${PROJ_CMAKE} -B "${build_dir}" \
          -S "${src}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER="${PROJ_CXX}" \
          -DCMAKE_CXX_STANDARD=17 \
          -DBUILD_SHARED_LIBS=OFF \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ${PROJ_CMAKE} --build "${build_dir}" --parallel --target install
    rm -fr "${build_dir}"
}

#: 并行构建第三方依赖
function build_deps() {
    local -a fns=(
        _build_googletest
        _build_spdlog
        _build_abseil_cpp
        _build_civetweb
        _build_fmt
        _build_pugixml
        _build_gflags
        _build_nlohmann_json
        _build_leveldb
        _build_libressl
    )
    local -a pids=() logs=()
    local fn pid log i rc=0

    mkdir -p "${PROJ_BUILD}"

    for fn in "${fns[@]}"; do
        log="${PROJ_BUILD}/${fn}.log"
        "${fn}" > "${log}" 2>&1 &
        pid=$!
        pids+=("${pid}")
        logs+=("${log}")
        printf '==> [deps] start %s (pid=%s)\n' "${fn}" "${pid}"
    done

    for i in "${!fns[@]}"; do
        if wait "${pids[${i}]}"; then
            printf '==> [deps] ok %s\n' "${fns[${i}]}"
        else
            rc=1
            printf '==> [deps] FAIL %s, log: %s\n' "${fns[${i}]}" "${logs[${i}]}"
            cat "${logs[${i}]}"
        fi
    done

    return "${rc}"
}

#: 输出平台信息单行: distro|kernel|arch (ubuntu|Linux|x86_64)
#: local distro kernel arch info
#: info=$(platform_info) || return 1
#: IFS='|' read -r distro kernel arch <<< "${info}"
function platform_info() {
    local kernel arch distro

    kernel=$(uname -s) # Darwin / Linux
    arch=$(uname -m)   # arm64 / x86_64 / ...

    case ${kernel} in
        Darwin)
            # 系统自述产品名: macOS(新)/Mac OS X(旧)；与 Linux 读 os-release 对称
            distro=$(sw_vers -productName 2> /dev/null) || distro=unknown
            ;;
        Linux)
            # /etc/os-release 的 ID 是发行版小写标识：ubuntu/centos/rocky/debian...
            # ID 缺失或为空时退回 ID_LIKE 的第一个同族名，再缺失则 unknown
            distro=$(
                # shellcheck disable=SC1091
                . /etc/os-release 2> /dev/null &&
                    printf '%s' "${ID:-${ID_LIKE%% *}}" || printf 'unknown'
            )
            ;;
        *)
            distro=unknown
            ;;
    esac

    printf '%s|%s|%s\n' "${distro}" "${kernel}" "${arch}"
}

#: 输出当前毫秒级时间戳(多平台兜底)
function _now_ms() {
    local raw sec frac value

    # bash >= 5：秒.微秒，小数点固定为 '.'
    raw=${EPOCHREALTIME-}
    if [[ ${raw} == *.* ]]; then
        sec=${raw%%.*}
        frac=${raw#*.}000
        value=$((10#${sec} * 1000 + 10#${frac:0:3}))
        printf '%s\n' "${value}"
        return 0
    fi

    # GNU date。%3N 是毫秒；10# 避免前导 0 被当成八进制
    if raw=$(date +%s%3N 2> /dev/null) && [[ ${raw} =~ ^[0-9]{13,}$ ]]; then
        printf '%s\n' "$((10#${raw}))"
        return 0
    fi
    if command -v gdate > /dev/null 2>&1 &&
        raw=$(gdate +%s%3N 2> /dev/null) && [[ ${raw} =~ ^[0-9]{13,}$ ]]; then
        printf '%s\n' "$((10#${raw}))"
        return 0
    fi
    if command -v perl > /dev/null 2>&1 &&
        raw=$(perl -MTime::HiRes=gettimeofday -e '($s,$us)=gettimeofday(); printf "%d", $s*1000+int($us/1000)' 2> /dev/null) &&
        [[ ${raw} =~ ^[0-9]+$ ]]; then
        printf '%s\n' "${raw}"
        return 0
    fi
    if command -v python3 > /dev/null 2>&1 &&
        raw=$(python3 -c 'import time; print(int(time.time()*1000))' 2> /dev/null) &&
        [[ ${raw} =~ ^[0-9]+$ ]]; then
        printf '%s\n' "${raw}"
        return 0
    fi

    # 整秒。bash >= 4.2 用内建，否则用 date +%s
    raw=
    if ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2))); then
        printf -v raw '%(%s)T' -1
    fi
    if [[ ! ${raw} =~ ^[0-9]+$ ]]; then
        raw=$(date +%s 2> /dev/null || true)
    fi
    if [[ ! ${raw} =~ ^[0-9]+$ ]]; then
        raw=0
    fi
    printf '%s\n' "$((10#${raw} * 1000))"
}

#: 执行命令并打印耗时
function display_elapsed() {
    local cmd="$*"
    local startMs endMs costMs rc=0
    local elapsed

    startMs=$(_now_ms)
    "$@" || rc=$?
    endMs=$(_now_ms)

    costMs=$((endMs - startMs))
    if ((costMs < 1000)); then
        printf -v elapsed '%d ms' "${costMs}"
    elif ((costMs < 60000)); then
        printf -v elapsed '%d.%03d s' "$((costMs / 1000))" "$((costMs % 1000))"
    else
        printf -v elapsed '%dm %02d.%03d s' \
            "$((costMs / 60000))" \
            "$(((costMs / 1000) % 60))" \
            "$((costMs % 1000))"
    fi

    printf 'cmd: %s, elapsed: %s\n' "${cmd}" "${elapsed}"
    return "${rc}"
}

#: 生成定宽标题行: 两侧用填充字符、中间放文字(宽度按字符数计, 奇数余量归右侧)
#: banner <width> [text] [char]
#: banner 7 xxx          -> ==xxx==
#: banner 20 xxx         -> ========xxx=========
#: banner 20 '' '*'      -> ********************
function banner() {
    local width text ch
    width="${1-}"
    text="${2-}"
    ch="${3-=}"

    if [[ ! ${width} =~ ^[1-9][0-9]*$ ]]; then
        printf 'Usage: banner <width> [text] [char]\n' >&2
        return 1
    fi

    local text_len left right left_pad right_pad
    text_len=${#text}

    # 文本长度不小于总宽时原样输出
    if ((text_len >= width)); then
        printf '%s\n' "${text}"
        return 0
    fi

    left=$(((width - text_len) / 2))
    right=$((width - text_len - left))

    printf -v left_pad '%*s' "${left}" ''
    printf -v right_pad '%*s' "${right}" ''
    printf '%s%s%s\n' "${left_pad// /${ch}}" "${text}" "${right_pad// /${ch}}"
}

#: 回显命令并执行
function display_cmd() {
    local rc=0

    printf '$ %s\n' "$*"
    "$@" || rc=$?
    printf '\n\n'
    return "${rc}"
}

#: 并排对比两个文件差异
function display_diff() {
    local l="$1"
    local r="$2"
    diff -y --suppress-common-lines "${l}" "${r}"
    printf '\n'
}

#: 生成 前缀_时间戳_pid_随机 的唯一名
function unique_name() {
    local prefix timestamp
    prefix="${1-}"
    timestamp="$(date +%Y%m%d_%H%M%S)"

    if [[ -n ${prefix} ]]; then
        printf '%s_%s_%s_%s' "${prefix}" "${timestamp}" "$$" "${RANDOM}"
    else
        printf '%s_%s_%s' "${timestamp}" "$$" "${RANDOM}"
    fi
}

#: 保存后自动重跑指定命令(watch)
#: macOS: brew install watch
function watch_cmd() {
    local cmdName="${1-}"
    local cmdPath=""

    if [[ -z ${cmdName} ]]; then
        printf 'Usage: watch_cmd <command> [args...]\n' >&2
        return 1
    fi
    if [[ ${cmdName} == watch_cmd ]]; then
        printf 'Refusing to watch watch_cmd.\n' >&2
        return 1
    fi

    shift
    if declare -F "${cmdName}" > /dev/null 2>&1; then
        watch -n -1 -d --exec -- "${PROJ_CUR_SCRIPT}" "${cmdName}" "$@"
        return
    fi

    cmdPath=$(type -P "${cmdName}" 2> /dev/null || true)
    if [[ -z ${cmdPath} ]]; then
        printf 'Command not found: %s\n' "${cmdName}" >&2
        return 1
    fi
    watch -n -1 -d --exec -- "${cmdPath}" "$@"
}

#: 导出 man 手册为 PDF
function export_cmd_pdf() {
    local cmd file page section
    section="$1"
    cmd="$2"
    file="${3:-${cmd}.pdf}"
    page=$(man -w "${section}" "${cmd}") || return 1
    mandoc -T pdf "${page}" > "${file}"
}

#: 打印所有命令及功能说明(#: 首行进帮助，后续行仅作源码注释)
function help() {
    printf 'Usage: %s <command> [args...]\n\n' "${PROJ_CUR_SCRIPT}"
    awk '
        /^#: / && desc == "" {
            sub(/^#: */, "")
            desc = $0
        }
        /^function / {
            name = $2
            sub(/\(\)/, "", name)
            if (name !~ /^_/) {
                n++
                names[n] = name
                descs[n] = desc
                if (length(name) > maxlen) maxlen = length(name)
            }
            desc = ""
        }
        END {
            for (i = 1; i <= n; i++)
                printf "  %-*s %s\n", maxlen, names[i], descs[i]
        }
    ' "${PROJ_CUR_SCRIPT}"
}

function _main() {
    local funcName="${1-}"
    (($#))   && shift

    if [[ -z ${funcName} ]]; then
        help
        return 0
    fi
    if ! declare -F "${funcName}" > /dev/null 2>&1; then
        printf 'Unknown command: %s, try: %s help\n' "${funcName}" "${PROJ_CUR_SCRIPT}" >&2
        return 127
    fi
    "${funcName}" "$@"
}
_main "$@"
