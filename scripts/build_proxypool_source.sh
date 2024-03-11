#!/bin/bash

REPO_AUTHOR=""
REPO_NAME=""
REPO_BRANCH=""
REPO_FOLDER=""

function git_clone_repo()
{
    local repo="${1:-}"
    local branch="${2:-}"
    local folder="${3:-}"

    [ "$repo" != "" ] || return

    if [ "$branch" != "" -a "$branch" != "main" ]; then
        git clone -q -b "$branch" --depth=1 "$repo" $folder
    else
        git clone -q --depth=1 "$repo" $folder
    fi
    if [ "$?" != "0" ]; then
        echo -e "Clone Repo [\033[31m ERR \033[0m] [ $folder <= $repo:$branch ]"
        rm -rf "$folder"
    else
        echo -e "Clone Repo [\033[33m OK  \033[0m] [ $folder <= $repo:$branch ]"
    fi
}

function add_proxypool_source()
{
    local stype="${1:-}"
    local src="${2:-}"

    [ "$stype" != "" -a "$src" != "" ] || return

    case "$stype" in
        clash|subscribe|webfuzzsub)
            {
                echo "- type: $stype"
                echo "  options:"
                echo "    url: $src"
                echo ""
            } >> /workdir/pp_source.yaml
            ;;
        tgchannel)
            {
                echo "- type: tgchannel"
                echo "  options:"
                echo "    channel: $src"
                echo "    num: 100"
                echo ""
            } >> /workdir/pp_source.yaml
            ;;
        append)
            {
                cat "$src"
                echo ""
            } >> /workdir/pp_source.yaml
            ;;
    esac
}

function add_proxypool_github_source()
{
    if [ -f "$REPO_FOLDER/$2" ]; then
        if [ "$1" = "append" ]; then
            add_proxypool_source "$1" "$REPO_FOLDER/$2"
        else
            add_proxypool_source "$1" "https://raw.githubusercontent.com/$REPO_AUTHOR/$REPO_NAME/$REPO_BRANCH/$2"
        fi
    fi
}

REPO_AUTHOR="guoxing123"
REPO_NAME="aa"
REPO_BRANCH="main"
REPO_FOLDER="aa"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    for i in `find $REPO_FOLDER -name '*.yaml'`; do
        add_proxypool_github_source "clash" "$(echo $i | sed 's#'$REPO_FOLDER'/##')"
    done
    rm -rf "$REPO_FOLDER"
fi


# REPO_AUTHOR="pojiezhiyuanjun"
# REPO_NAME="2023"
# REPO_BRANCH="main"
# REPO_FOLDER="2023"

# echo "[ $REPO_AUTHOR/$REPO_NAME ]"
# git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
# if [ -d "$REPO_FOLDER" ]; then
#     for i in `find $REPO_FOLDER -name '*.yml'`; do
#         add_proxypool_github_source "clash" "$(echo $i | sed 's#'$REPO_FOLDER'/##')"
#     done
#     rm -rf "$REPO_FOLDER"
# fi


REPO_AUTHOR="changfengoss"
REPO_NAME="pub"
REPO_BRANCH="main"
REPO_FOLDER="pub"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    for i in `find $REPO_FOLDER/data/2024_* -name '*.yaml'`; do
        if [ `grep -c 'proxies:' $i` -ne 0 ]; then
            add_proxypool_github_source "clash" "$(echo $i | sed 's#'$REPO_FOLDER'/##')"
        elif [ `grep -c '{' $i` -eq 0 ]; then
            add_proxypool_github_source "subscribe" "$(echo $i | sed 's#'$REPO_FOLDER'/##')"
        fi
    done
    rm -rf "$REPO_FOLDER"
fi


REPO_AUTHOR="lee-alone"
REPO_NAME="proxypool_source.yaml"
REPO_BRANCH="main"
REPO_FOLDER="lee-alone"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "append" "source.yaml"
    add_proxypool_github_source "subscribe" "diylist"
    rm -rf "$REPO_FOLDER"
fi


REPO_AUTHOR="snakem982"
REPO_NAME="proxypool"
REPO_BRANCH="main"
REPO_FOLDER="proxypool"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "webfuzzsub" "nodelist.txt"
    add_proxypool_github_source "webfuzzsub" "proxies.txt"
    add_proxypool_github_source "append" "webfuzz.yaml"
    if [ -f "$REPO_FOLDER/tgchannel.json" ]; then
        for i in `grep '"' $REPO_FOLDER/tgchannel.json | awk -F '"' '{print $2}'`; do
            add_proxypool_source "tgchannel" "$i"
        done
    fi
    rm -rf "$REPO_FOLDER"
fi


REPO_AUTHOR="zyjia"
REPO_NAME="proxypool"
REPO_BRANCH="main"
REPO_FOLDER="proxypool"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "webfuzzsub" "nodelist.txt"
    add_proxypool_github_source "webfuzzsub" "proxies.txt"
    add_proxypool_github_source "append" "webfuzz.yaml"
    if [ -f "$REPO_FOLDER/tgchannel.json" ]; then
        for i in `grep '"' $REPO_FOLDER/tgchannel.json | awk -F '"' '{print $2}'`; do
            add_proxypool_source "tgchannel" "$i"
        done
    fi
    rm -rf "$REPO_FOLDER"
fi


REPO_AUTHOR="xiaoqi33221"
REPO_NAME="xiaoqi-Node-pools"
REPO_BRANCH="main"
REPO_FOLDER="proxypool"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "webfuzzsub" "nodelist.txt"
    add_proxypool_github_source "webfuzzsub" "proxies.txt"
    add_proxypool_github_source "append" "webfuzz.yaml"
    if [ -f "$REPO_FOLDER/tgchannel.json" ]; then
        for i in `grep '"' $REPO_FOLDER/tgchannel.json | awk -F '"' '{print $2}'`; do
            add_proxypool_source "tgchannel" "$i"
        done
    fi
    add_proxypool_github_source "clash" "clash058fb.yaml"
    rm -rf "$REPO_FOLDER"
fi


REPO_AUTHOR="hjchjchjc4352"
REPO_NAME="proxypool"
REPO_BRANCH="main"
REPO_FOLDER="proxypool"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "webfuzzsub" "nodelist.txt"
    add_proxypool_github_source "webfuzzsub" "proxies.txt"
    add_proxypool_github_source "append" "webfuzz.yaml"
    if [ -f "$REPO_FOLDER/tgchannel.json" ]; then
        for i in `grep '"' $REPO_FOLDER/tgchannel.json | awk -F '"' '{print $2}'`; do
            add_proxypool_source "tgchannel" "$i"
        done
    fi
    add_proxypool_github_source "clash" "clash.yaml"
    add_proxypool_github_source "clash" "mihomo.yaml"
    rm -rf "$REPO_FOLDER"
fi

REPO_AUTHOR="peasoft"
REPO_NAME="NoMoreWalls"
REPO_BRANCH="master"
REPO_FOLDER="NoMoreWalls"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "clash" "list.yml"
    add_proxypool_github_source "clash" "list.meta.yml"
    rm -rf "$REPO_FOLDER"
fi

REPO_AUTHOR="mahdibland"
REPO_NAME="V2RayAggregator"
REPO_BRANCH="master"
REPO_FOLDER="V2RayAggregator"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "clash" "Eternity.yml"
    rm -rf "$REPO_FOLDER"
fi

REPO_AUTHOR="mfuu"
REPO_NAME="v2ray"
REPO_BRANCH="main"
REPO_FOLDER="v2ray"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "clash" "clash.yaml"
    rm -rf "$REPO_FOLDER"
fi

REPO_AUTHOR="w1770946466"
REPO_NAME="Auto_proxy"
REPO_BRANCH="main"
REPO_FOLDER="Auto_proxy"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "subscribe" "Long_term_subscription_num"
    add_proxypool_github_source "subscribe" "Long_term_subscription_try"
    rm -rf "$REPO_FOLDER"
fi

REPO_AUTHOR="ermaozi"
REPO_NAME="get_subscribe"
REPO_BRANCH="main"
REPO_FOLDER="get_subscribe"

echo "[ $REPO_AUTHOR/$REPO_NAME ]"
git_clone_repo "https://github.com/$REPO_AUTHOR/$REPO_NAME.git" "$REPO_BRANCH" "$REPO_FOLDER"
if [ -d "$REPO_FOLDER" ]; then
    add_proxypool_github_source "clash" "subscribe/clash.yml"
    rm -rf "$REPO_FOLDER"
fi
