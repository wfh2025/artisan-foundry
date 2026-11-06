#!/usr/bin/env bash
PROJ_ROOT=$(cd "$(dirname -- "$0")" && pwd -P)
export PROJ_ROOT

export PROJ_VENDOR="${PROJ_ROOT}/vendor"
export PROJ_CUR_SCRIPT="${PROJ_ROOT}/$(basename "$0")"
export PROJ_SHFMT="${PROJ_VENDOR}/shfmt-3.14.1/$(uname -s)/$(uname -m)/shfmt"
export PROJ_SHELLCHECK="${PROJ_VENDOR}/shellcheck-0.11.0/$(uname -s)/$(uname -m)/shellcheck"
export PROJ_SHELLHARDEN="${PROJ_VENDOR}/shellharden-4.3.2/$(uname -s)/$(uname -m)/shellharden"

function dbg() {
	$PROJ_SHFMT "$@"
}

function detect_shell_file() {
	local file=$1
	"${PROJ_SHFMT}" -w ${file}
}

function format_shell_file() {
    local file="$1"
    "${PROJ_SHFMT}" --language-dialect auto --indent 4 --binary-next-line --case-indent --space-redirects --keep-padding --func-next-line -w "${file}"
}

function now_ms() {
	local raw sec frac value

	# bash >= 5：秒.微秒，小数点固定为 '.'
	raw=${EPOCHREALTIME-}
	if [[ $raw == *.* ]]; then
		sec=${raw%%.*}
		frac=${raw#*.}000
		value=$((10#$sec * 1000 + 10#${frac:0:3}))
		printf '%s\n' "$value"
		return 0
	fi

	# GNU date。%3N 是毫秒；10# 避免前导 0 被当成八进制
	if raw=$(date +%s%3N 2>/dev/null) && [[ $raw =~ ^[0-9]{13,}$ ]]; then
		printf '%s\n' "$((10#$raw))"
		return 0
	fi
	if command -v gdate >/dev/null 2>&1 &&
		raw=$(gdate +%s%3N 2>/dev/null) && [[ $raw =~ ^[0-9]{13,}$ ]]; then
		printf '%s\n' "$((10#$raw))"
		return 0
	fi
	if command -v perl >/dev/null 2>&1 &&
		raw=$(perl -MTime::HiRes=gettimeofday -e '($s,$us)=gettimeofday(); printf "%d", $s*1000+int($us/1000)' 2>/dev/null) &&
		[[ $raw =~ ^[0-9]+$ ]]; then
		printf '%s\n' "$raw"
		return 0
	fi
	if command -v python3 >/dev/null 2>&1 &&
		raw=$(python3 -c 'import time; print(int(time.time()*1000))' 2>/dev/null) &&
		[[ $raw =~ ^[0-9]+$ ]]; then
		printf '%s\n' "$raw"
		return 0
	fi

	# 整秒。bash >= 4.2 用内建，否则用 date +%s
	raw=
	if ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2))); then
		printf -v raw '%(%s)T' -1
	fi
	if [[ ! $raw =~ ^[0-9]+$ ]]; then
		raw=$(date +%s 2>/dev/null || true)
	fi
	if [[ ! $raw =~ ^[0-9]+$ ]]; then
		raw=0
	fi
	printf '%s\n' "$((10#$raw * 1000))"
}

function display_elapsed() {
	local cmd="$*"
	local startMs endMs costMs rc=0
	local elapsed

	startMs=$(now_ms)
	"$@" || rc=$?
	endMs=$(now_ms)

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

function display_cmd() {
	local rc=0

	printf '$ %s\n' "$*"
	"$@" || rc=$?
	printf '\n\n'
	return "${rc}"
}

function display_diff() {
	local l="$1"
	local r="$2"
	diff -y --suppress-common-lines "${l}" "${r}"
	printf '\n'
}

function unique_name() {
	local prefix=${1-}

	if [[ -n ${prefix} ]]; then
		printf '%s_%s_%s_%s' "${prefix}" "$(date +%Y%m%d_%H%M%S)" "$$" "${RANDOM}"
	else
		printf '%s_%s_%s' "$(date +%Y%m%d_%H%M%S)" "$$" "${RANDOM}"
	fi
}

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
	if declare -F "${cmdName}" >/dev/null 2>&1; then
		watch -n -1 -d --exec -- "${PROJ_CUR_SCRIPT}" "${cmdName}" "$@"
		return
	fi

	cmdPath=$(type -P "${cmdName}" 2>/dev/null || true)
	if [[ -z ${cmdPath} ]]; then
		printf 'Command not found: %s\n' "${cmdName}" >&2
		return 1
	fi
	watch -n -1 -d --exec -- "${cmdPath}" "$@"
}

function main() {
	local funcName="$1"
	shift
	"$funcName" "$@"
}
main "$@"
