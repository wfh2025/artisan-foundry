#!/usr/bin/env bash
################################################使用说明##############################################
# shell脚本规范
# 1. 内部函数名以'_'为前缀
# 2. 两个函数之间参数传递不得以共享变量方案实现
# 3. 函数正上方连续注释使用'#:'，其它地方使用'#'注释
# 4. shell脚本必须使用shfmt格式化
# 5. shell脚本必须通过shellcheck格式化
# 6. shell脚本运行的bash版本以3.x.y为主
####################################################################################################
PROJ_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
PROJ_CUR_SCRIPT="${PROJ_ROOT}/${BASH_SOURCE[0]##*/}"
PROJ_VENDOR="${PROJ_ROOT}/vendor"

PROJ_SHFMT="${PROJ_VENDOR}/shfmt-3.14.1/shfmt"
PROJ_SHELLCHECK="${PROJ_VENDOR}/shellcheck-0.11.0/shellcheck"

#: 测试
function dbg() {
    local -a urls=(
        "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-macos-amd64"
        "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-macos-arm64"
        "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux-amd64"
        "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux-arm64"
    )
    local -a proxies=(
        "https://cfgh.ikgy.top"
        "https://gh.07150721.xyz"
        "https://gh.meali.top"
    )
    local dst_dir="${PROJ_ROOT}/vendor2"
    local url name dst log
    local rc=0 total=0 fail=0 i
    local -a pids=() names=() logs=()

    mkdir -p "${dst_dir}"
    for raw_url in "${urls[@]}"; do
        name="${raw_url##*/}"
        url="${proxies[i]}/${raw_url}"
        dst="${dst_dir}/${name}"
        log="${dst}.log"
        total=$((total + 1))
        printf '==> [fetch] %s\n' "${name}"
        _wget_with_log "${dst}" "${url}" "${log}" &
        pids+=("$!")
        names+=("${name}")
        logs+=("${log}")
        i=$(((i+1) % ${#proxies[@]}))
    done

    for ((i = 0; i < total; i++)); do
        if wait "${pids[i]}"; then
            printf '==> [fetch] ok: %s\n' "${names[i]}"
        else
            printf '==> [fetch] fail: %s, log: %s\n' "${names[i]}" "${logs[i]}"
            fail=$((fail + 1))
            rc=1
        fi
    done

    printf '==> [fetch] total=%d fail=%d\n' "${total}" "${fail}"
    return "${rc}"

}

#: 下载封装
#: 需提前创建dst所在目录
#: dst是存储文件路径
function _wget() {
    local dst="$1"
    local url="$2"

    local rc=0
    local tries=3
    local dns_timeout=$((1 * 60))
    local read_timeout=$((1 * 60))
    local connect_timeout=$((1 * 60))

    wget --no-verbose \
        --show-progress \
        --progress "bar:force:scroll" \
        --tries "${tries}" \
        --dns-timeout "${dns_timeout}" \
        --read-timeout "${read_timeout}" \
        --connect-timeout "${connect_timeout}" \
        --output-document "${dst}" "${url}" || rc=$?
    return "${rc}"
}

#: 并发批量下载文件到vendor2目录
#: 用法: fetch <url> [<url>...], 文件名取url末段, 失败时保留同名.log日志
function fetch() {
    if (($# == 0)); then
        printf 'Usage: fetch <url> [<url>...]\n' >&2
        return 2
    fi

    local dst_dir="${PROJ_ROOT}/vendor2"
    local url name dst log
    local rc=0 total=0 fail=0 i
    local -a pids=() names=() logs=()

    mkdir -p "${dst_dir}"

    for url in "$@"; do
        name="${url##*/}"
        dst="${dst_dir}/${name}"
        log="${dst}.log"
        total=$((total + 1))
        printf '==> [fetch] %s\n' "${name}"
        _wget_with_log "${dst}" "${url}" "${log}" &
        pids+=("$!")
        names+=("${name}")
        logs+=("${log}")
    done

    for ((i = 0; i < total; i++)); do
        if wait "${pids[i]}"; then
            printf '==> [fetch] ok: %s\n' "${names[i]}"
        else
            printf '==> [fetch] fail: %s, log: %s\n' "${names[i]}" "${logs[i]}"
            fail=$((fail + 1))
            rc=1
        fi
    done

    printf '==> [fetch] total=%d fail=%d\n' "${total}" "${fail}"
    return "${rc}"
}

#: 下载单个文件
#: $1: dst文件路径
#: $2: 下载地址
#: $3: 日志文件路径, 下载成功后自动删除
function _wget_with_log() {
    local dst="$1"
    local url="$2"
    local log="$3"

    if _wget "${dst}" "${url}" > "${log}" 2>&1; then
        rm -f "${log}"
        return 0
    fi
    return 1
}

#: 格式化并静态检查代码
function pretty() {
    local rc=0
    _pretty_shell || rc=1
    return "${rc}"
}

#: 递归格式化并静态检查所有shell脚本
function _pretty_shell() {
    local file rc=0 total=0 fail=0

    local -a blacklist=(
        -path "${PROJ_VENDOR}"
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

#: 格式化单个shell文件
function _format_shell_file() {
    local file="$1"
    "${PROJ_SHFMT}" --indent 4 \
              --case-indent \
              --keep-padding \
              --space-redirects \
        --language-dialect auto --write "${file}"
}

#: shellcheck检查单个shell文件
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

#: 打印命令及功能说明
#: '#:' => 首行进帮助
#: 后续行仅作源码注释
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
