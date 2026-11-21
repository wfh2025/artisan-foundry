#!/usr/bin/env bash
PROJ_ROOT=$(cd "$(dirname -- "$0")" && pwd -P)

# 将man文档转换成pdf
function man2pdf() {
    man -t cmake | ps2pdf - cmake.pdf || true
}

function dbg() {
    echo "${PROJ_ROOT}"
}

function main() {
    local funcName="$1"
    shift
    "${funcName}" "$@"
}
main "$@"
