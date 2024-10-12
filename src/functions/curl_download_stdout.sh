#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


curl_download_stdout() {
    local url=$1
    curl \
    --silent \
    --location \
    --output '-' \
    --connect-timeout 5 \
        "${url}"
}
