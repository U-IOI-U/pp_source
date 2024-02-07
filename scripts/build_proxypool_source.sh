#!/bin/bash

function git_clone_repo()
{
    local repo="${1:-}"
    local branch="${2:-}"
    local folder="${3:-}"

    [ "$repo" != "" ] || return

    if [ "$branch" != "" ]; then
        git clone -q -b "$branch" --depth=1 "$repo" $folder
    else
        git clone -q --depth=1 "$repo" $folder
    fi
    if [ "$?" != "0" ]; then
        echo -e "Clone Repo [\033[32m ERR \033[0m] [ $folder <= $repo:$branch ]"
        rm -rf "$folder"
    else
        echo -e "Clone Repo [\033[31m OK  \033[0m] [ $folder <= $repo:$branch ]"
    fi
}

echo "[ guoxin123/aa ]"
git_clone_repo "https://github.com/guoxing123/aa.git" "main" "aa"
if [ -d "aa" ]; then
    for i in `find aa -name '*.yaml'`; do
        {
            echo "- type: clash"
            echo "  options:"
            echo "    url: https://github.com/guoxing123/aa/raw/main/$(basename $i)"
            echo ""
        } >> /workdir/pp_source.yaml
    done
fi

echo "[ pojiezhiyuanjun/2023 ]"
git_clone_repo "https://github.com/pojiezhiyuanjun/2023.git" "main" "2023"
if [ -d "2023" ]; then
    for i in `find 2023 -name '*.yml'`; do
        {
            echo "- type: clash"
            echo "  options:"
            echo "    url: https://github.com/pojiezhiyuanjun/2023/raw/main/$(basename $i)"
            echo ""
        } >> /workdir/pp_source.yaml
    done
fi
