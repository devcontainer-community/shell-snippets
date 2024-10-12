#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


curl_download_to() {
    local url=$1
    local output=$2
    curl -s -L -o "${output}" "${url}"
}
