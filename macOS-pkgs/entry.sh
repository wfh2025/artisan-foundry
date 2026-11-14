#!/usr/bin/env bash
# ─── 注释规范 ─────────────────────────────
# 1. 函数上方连续注释块使用 #:
# 2. 其他地方注释使用 #
# 3. 私有函数名使用 _ 作为前缀
# ───────────────────────────────────────────
PROJ_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
PROJ_DEPS="${PROJ_ROOT}/deps"
PROJ_BUILD="${PROJ_ROOT}/build"
PROJ_VENDOR="${PROJ_ROOT}/../vendor"
PROJ_CUR_SCRIPT="${PROJ_ROOT}/${BASH_SOURCE[0]##*/}"

PROJ_OS="$(uname -s)"
PROJ_ARCH="$(uname -m)"

PROJ_CC=$(command -v cc)
PROJ_CXX=$(command -v c++)
PROJ_CMAKE=$(command -v cmake)

PROJ_CMAKE_GENERATOR="Ninja"

PROJ_SHFMT="${PROJ_VENDOR}/shfmt-3.14.1/${PROJ_OS}/${PROJ_ARCH}/shfmt"
PROJ_SHELLCHECK="${PROJ_VENDOR}/shellcheck-0.11.0/${PROJ_OS}/${PROJ_ARCH}/shellcheck"

export PROJ_ROOT PROJ_OS PROJ_ARCH PROJ_CUR_SCRIPT \
    PROJ_VENDOR PROJ_SHFMT PROJ_SHELLCHECK PROJ_BUILD PROJ_DEPS \
    PROJ_CC PROJ_CXX PROJ_CMAKE_GENERATOR PROJ_CMAKE

#: 调试插槽
function dbg() {
    # "$(brew --prefix llvm)/bin/clang-format" "$@"
    local distro kernel arch info

    info=$(platform_info) || return 1
    IFS='|' read -r distro kernel arch <<< "${info}"
    printf 'distro = %s, kernel = %s, arch = %s \n' "${distro}" "${kernel}" "${arch}"
}

#: 批量安装包，存在则忽略；缺省 Brewfile
function install_pkgs_noupgrade() {
    local brew_file="${1:-Brewfile}"
    brew bundle install --no-upgrade --file "${brew_file}"
}

#: 递归格式化并静态检查所有 shell 脚本(shfmt + shellcheck)
function pretty() {
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

#: 用 shfmt 格式化单个文件
function _format_shell_file() {
    local file="$1"
    "${PROJ_SHFMT}" --indent 4 \
              --case-indent \
              --keep-padding \
              --space-redirects \
        --language-dialect auto --write "${file}"
}

#: 格式化脚本: xxx.sh fmt <args.0> <args.1> ...
function fmt() {
    _format_shell_file "$@"
    _check_shell_file "$@"
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

#: 原地删除文件中所有 # 注释行(保留 shebang): strip_comments <file>...
function strip_comments() {
    local file tmp
    for file in "$@"; do
        if [[ ! -f ${file} ]]; then
            printf 'Not a regular file: %s\n' "${file}" >&2
            return 1
        fi
        tmp=$(mktemp "${file}.XXXXXX") || return 1
        if sed '1!{ /^[[:space:]]*#/d; }' "${file}" > "${tmp}"; then
            cat "${tmp}" > "${file}" # 回写以保留原 inode 与权限
            rm -f "${tmp}"
            printf '==> [strip_comments] %s\n' "${file}"
        else
            rm -f "${tmp}"
            return 1
        fi
    done
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
                printf "  %-18s %s\n", name, desc
            }
            desc = ""
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
