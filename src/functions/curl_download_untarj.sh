#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport

source curl_download_stdout.sh

curl_download_untarj() {
    local url=$1
    local strip=$2
    local target=$3
    local bin_path=$4
    curl_download_stdout "${url}" | tar \
    -xj \
    -f '-' \
    --strip-components="${strip}" \
    -C "${target}" \
      "${bin_path}"
}
