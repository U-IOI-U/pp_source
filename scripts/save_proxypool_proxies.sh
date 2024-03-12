#!/bin/bash

while [ true ]; do
    curl -O -L https://github.com/U-IOI-U/proxypool/releases/download/debug/proxypool-linux-amd64
    [ -f 'proxypool-linux-amd64' ] || break
    chmod +x proxypool-linux-amd64

    curl -O -L https://github.com/U-IOI-U/proxypool/raw/0.7.13/assets/flags.json
    curl -O -L https://github.com/U-IOI-U/proxypool/raw/0.7.13/assets/GeoLite2-City.mmdb
    [ -f 'flags.json' -a -f 'GeoLite2-City.mmdb' ] || break
    mkdir assets && mv flags.json GeoLite2-City.mmdb assets/

    curl -O -L https://github.com/U-IOI-U/proxypool/raw/0.7.13/config/config.yaml
    [ -f 'config.yaml' ] || break

    echo "save-proxy-file: \"proxies\"" >> config.yaml
    echo "save-proxy-mode: \"link\"" >> config.yaml
    echo "show-subscribe-mode: \"showall\"" >> config.yaml
    sed -i 's/zero_fail: false/zero_fail: true/g' config.yaml

    cp /workdir/pp_source.yaml source.yaml

    curl -O -L https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies_all
    if [ -f 'proxies_all' ]; then
        if [ `stat -c "%s" proxies_all` -gt '10485760' ]; then
            if [ `head -n1 proxies_all | grep -c proxies` -eq 1 ]; then
                {
                    echo "- type: clash"
                    echo "  options:"
                    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies"
                    echo ""
                } >> ./source.yaml
            elif [ `head -n1 proxies_all | grep -c ":"` -ne 0 ]; then
                {
                    echo "- type: subscribe"
                    echo "  options:"
                    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies"
                    echo ""
                } >> ./source.yaml
            else
                {
                    echo "- type: webfuzz"
                    echo "  options:"
                    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies"
                    echo ""
                } >> ./source.yaml
            fi
        else
            if [ `head -n1 proxies_all | grep -c proxies` -eq 1 ]; then
                {
                    echo "- type: clash"
                    echo "  options:"
                    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies_all"
                    echo ""
                } >> ./source.yaml
            elif [ `head -n1 proxies_all | grep -c ":"` -ne 0 ]; then
                {
                    echo "- type: subscribe"
                    echo "  options:"
                    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies_all"
                    echo ""
                } >> ./source.yaml
            else
                {
                    echo "- type: webfuzz"
                    echo "  options:"
                    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies_all"
                    echo ""
                } >> ./source.yaml
            fi
        fi
    fi

    {
        echo "- type: webfuzzsub"
        echo "  options:"
        echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/webfuzzsub_auto"
        echo ""
    } >> ./source.yaml

    {
        echo "- type: webfuzzsub"
        echo "  options:"
        echo "    url: https://github.com/U-IOI-U/pp_source/raw/dev/webfuzzsub"
        echo ""
    } >> ./source.yaml

    {
        cat tgchannel
        echo ""
    } >> ./source.yaml

    ./proxypool-linux-amd64 -c config.yaml -d | tee output.txt

    if [ -f 'output.txt' ]; then
        grep -o 'Subscribe access.*' output.txt > link.txt
        if [ -f 'link.txt' ]; then
            sed /\ count=0\ /d link.txt | grep -o ' url = .*' | sed 's/ = /=/' | cut -d '=' -f 2- | sort -u > suc.txt
            sort suc.txt webfuzzsub | uniq -d > dup.txt
            sort suc.txt dup.txt | uniq -u > webfuzzsub_auto
        fi
    fi

    if [ -f 'proxies_all' ]; then
        mv proxies proxies_all webfuzzsub_auto /workdir/
    fi
    break
done
