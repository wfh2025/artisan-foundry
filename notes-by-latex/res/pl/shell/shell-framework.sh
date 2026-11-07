#!/usr/bin/env bash
export PROJ_ROOT=$(cd "$(dirname -- "$0")" && pwd -P)

# 将man文档转换成pdf
function man2pdf(){
  man -t cmake | ps2pdf - cmake.pdf
}

function dbg() {
  echo "dbg"
}

function main() {
    local funcName="$1"
    shift
    "$funcName" "$@"
}
main "$@"
