#!/usr/bin/env bash
# ─── 注释规范 ───────────────────────────────────────────────
# #: 仅用于函数上方连续注释块(紧邻 function，无空行分隔)：
#    首行 = 摘要(进 help/TAB 补全)，后续行 = 源码级补充说明
# #  用于其他一切场合(文件头/函数体内/行尾/分隔线)
# 可见性：_ 前缀函数为内部实现，不进 help/TAB；无前缀 = 用户命令
# ───────────────────────────────────────────────────────────
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
PROJ_CLANGFORMAT="$(brew --prefix llvm)/bin/clang-format"

export PROJ_ROOT PROJ_OS PROJ_ARCH PROJ_CUR_SCRIPT \
    PROJ_VENDOR PROJ_SHFMT PROJ_SHELLCHECK PROJ_BUILD PROJ_DEPS \
    PROJ_CC PROJ_CXX PROJ_CMAKE_GENERATOR PROJ_CMAKE PROJ_CLANGFORMAT

#: 调试插槽：当前包装 clang-format，用于验证参数效果
# gaga
# xxx
function dbg() {
    # gaga xxyyy #:
    "${PROJ_CLANGFORMAT}" "$@"
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
        if ! "${PROJ_CUR_SCRIPT}" _format_shell_file "${file}" ||
            ! "${PROJ_CUR_SCRIPT}" _check_shell_file "${file}"; then
            fail=$((fail + 1))
            rc=1
        fi
    done < <(find "${find_args[@]}" || true)

    printf '==> [pretty] total=%d fail=%d\n' "${total}" "${fail}"
    return "${rc}"
}

#: 并行构建第三方依赖(googletest、spdlog)到 deps/
function build_deps() {
    local -a fns=(
        _build_googletest
        _build_spdlog
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

#: CMake 构建并安装 spdlog 到 deps/spdlog
function _build_spdlog() {
    local build_dir="${PROJ_BUILD}/spdlog"
    local install_dir="${PROJ_DEPS}/spdlog"
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

    # rm -fr "${build_dir}"
}

#: CMake 构建并安装 googletest 到 deps/googletest
function _build_googletest() {
    local build_dir="${PROJ_BUILD}/googletest"
    local install_dir="${PROJ_DEPS}/googletest"
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
    # rm -fr "${build_dir}"
}

#: 从 vendor/*.tar.gz 解压生成各工具的二进制目录
function make_vendor_bin() {
    cp -r shellcheck-0.11.0 ruff-0.17.4
    find ./ruff-0.17.4 -type f -delete
    find ruff-0.17.4 -type f -name "*.tar.gz" -execdir tar -zxvf {} \;
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
                printf "  %-18s %s\n", name, desc
            }
            desc = ""
        }
    ' "${PROJ_CUR_SCRIPT}"
}

#: 打印 TAB 补全注册代码；zsh 用 compdef -p 模式注册，一次安装对所有 entry.sh 实例生效
function completion() {
    local script="${PROJ_CUR_SCRIPT}"

    if [[ ${SHELL-} == *zsh* ]]; then
        cat << EOF
if ! (( \$+functions[compdef] )); then
    autoload -Uz compinit && compinit
fi
_entry_sh_complete() {
    local script="\${words[1]:a}"
    local -a cmds
    cmds=(\${(f)"\$(awk '/^#: /&&d==""{sub(/^#: */,"");d=\$0} /^function /{n=\$2;sub(/\(.*/,"",n);if(n!~/^_/)print n":"d;d=""}' "\${script}")"})
    _describe 'command' cmds
}
compdef -p _entry_sh_complete '*entry.sh'
EOF
    else
        cat << EOF
_entry_sh_complete() {
    local script="\${COMP_WORDS[0]}"
    local cur="\${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(\$(compgen -W "\$(awk '/^function /{n=\$2;sub(/\(.*/,"",n);if(n!~/^_/)print n}' "\${script}")" -- "\$cur"))
}
complete -F _entry_sh_complete entry.sh ${script} ./entry.sh
EOF
    fi
}

#: 安装 TAB 补全：写入 ~/.config/entry-sh/ 并在 rc 文件追加 source 行(幂等，重跑自动修正旧路径)
function install() {
    local rc comp_dir comp_file sh_name tmp
    local tag='# entry.sh completion (managed by entry.sh install)'

    if [[ ${SHELL-} == *zsh* ]]; then
        rc="${HOME}/.zshrc"
        sh_name="zsh"
    else
        rc="${HOME}/.bashrc"
        sh_name="bash"
    fi

    comp_dir="${HOME}/.config/entry-sh"
    comp_file="${comp_dir}/completion.${sh_name}"
    mkdir -p "${comp_dir}"

    completion | grep -v '^#' > "${comp_file}" || true

    # 自愈：先移除旧安装行(可能指向历史坏路径)，再追加当前正确路径
    if [[ -f ${rc} ]] && grep -Fq "${tag}" "${rc}"; then
        tmp=$(mktemp)
        awk -v tag="${tag}" '
            $0 == tag { skip = 2; next }
            skip > 0 { skip--; next }
            { print }
        ' "${rc}" > "${tmp}" && mv "${tmp}" "${rc}"
        printf '==> [install] 已移除旧安装行\n'
    fi
    printf '\n%s\nsource %q\n' "${tag}" "${comp_file}" >> "${rc}"
    printf '==> [install] 已写入 %s 并追加 source 行到 %s\n' "${comp_file}" "${rc}"
    printf '==> [install] 生效：重开终端，或执行 source %q\n' "${comp_file}"
}

#: 卸载 TAB 补全：删除 rc 文件中的安装行与补全文件
function uninstall() {
    local rc comp_dir tmp
    local tag='# entry.sh completion (managed by entry.sh install)'

    if [[ ${SHELL-} == *zsh* ]]; then
        rc="${HOME}/.zshrc"
    else
        rc="${HOME}/.bashrc"
    fi
    comp_dir="${HOME}/.config/entry-sh"

    if [[ -f ${rc} ]] && grep -Fq "${tag}" "${rc}"; then
        tmp=$(mktemp)
        awk -v tag="${tag}" '
            $0 == tag { skip = 2; next }
            skip > 0 { skip--; next }
            { print }
        ' "${rc}" > "${tmp}" && mv "${tmp}" "${rc}"
        printf '==> [uninstall] 已从 %s 移除安装行\n' "${rc}"
    else
        printf '==> [uninstall] %s 中未发现安装行\n' "${rc}"
    fi
    rm -fr "${comp_dir}"
    printf '==> [uninstall] 已删除 %s\n' "${comp_dir}"
}

#: 入口：分发 ./entry.sh <命令> [参数...]
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
