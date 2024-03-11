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

    echo "save-clash-proxy: \"proxies\"" >> config.yaml

    cp /workdir/pp_source.yaml source.yaml

    {
    echo "- type: clash"
    echo "  options:"
    echo "    url: https://github.com/U-IOI-U/pp_source/releases/download/proxypool/proxies"
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

    ./proxypool-linux-amd64 -c config.yaml -d
    if [ -f 'proxies_all' ]; then
        mv proxies proxies_all /workdir/
    fi
    break
done
