#!/usr/bin/env bash
PROJ_ROOT=$(cd "$(dirname -- "$0")" && pwd -P)
export PROJ_ROOT

# ./download.sh repos_download ./repo-test.txt ~/tmp/x
# github批量下载仓库
function repos_download() {
    local list_file=$1
    local tgt_prefix=$2
    local user repo user_repo tgt_dir
    local prefix="https://github.com/"
    #    local prefix="https://gitee.com/"

    while IFS= read -r url || [[ -n "${url}" ]]; do
        url=$(echo "${url}" | tr -d '\r' | xargs || true) # 删除回车符和空格
        if [[ -z ${url} ]]; then
            continue
        fi

        if [[ "${url}" =~ ^# ]]; then
            echo "comment url: ${url}, ignore"
            continue
        fi
        user_repo="${url#"${prefix}"}"
        user=$(echo "${user_repo}" | cut -d '/' -f 1)
        repo=$(echo "${user_repo}" | cut -d '/' -f 2)
        repo="${repo%.git}"
        tgt_dir="${tgt_prefix}/${user}/${repo}"
        if [[ -d "${tgt_dir}" ]]; then
            echo "${url} exist ${tgt_dir}, ignore"
            continue
        fi

        if git clone "${url}" "${tgt_dir}"; then
            echo "Succeed to git clone, url: ${url}"
        else
            echo "Failed to git clone, url: ${url}"
            continue
        fi
    done < "${list_file}"
}

function main() {
    local funcName="$1"
    shift
    "${funcName}" "$@"
}
main "$@"
