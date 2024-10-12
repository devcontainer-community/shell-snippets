#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


source apt_get_update.sh
source apt_get_checkinstall.sh
source apt_get_cleanup.sh

# Checks if curl and ca-certificates are installed and installs those if not
check_curl_envsubst_file_tar_installed() {
    declare -a requiredAptPackagesMissing=()
    if ! [ -r '/etc/ssl/certs/ca-certificates.crt' ]; then
        requiredAptPackagesMissing+=('ca-certificates')
    fi

    if ! command -v curl >/dev/null 2>&1; then
        requiredAptPackagesMissing+=('curl')
    fi

    if ! command -v envsubst >/dev/null 2>&1; then
        requiredAptPackagesMissing+=('gettext-base')
    fi

    if ! command -v file >/dev/null 2>&1; then
        requiredAptPackagesMissing+=('file')
    fi

    if ! command -v tar >/dev/null 2>&1; then
        requiredAptPackagesMissing+=('tar')
    fi

    declare -i requiredAptPackagesMissingCount=${#requiredAptPackagesMissing[@]}
    if [ $requiredAptPackagesMissingCount -gt 0 ]; then
        apt_get_update
        apt_get_checkinstall "${requiredAptPackagesMissing[@]}"
        apt_get_cleanup
    fi
}
