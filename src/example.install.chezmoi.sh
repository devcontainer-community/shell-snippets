#!/usr/bin/env -S bash --noprofile --norc


set -o errexit      # Exit on error
set -o pipefail     # Pipeline fails if any command fails
set -o noclobber    # Prevent overwriting files
set -o nounset      # Error on using unset variables
set -o allexport    # Export all variables automatically

### Configuration

#### Package Information
readonly githubRepository='twpayne/chezmoi'
readonly binaryName='chezmoi'
readonly versionArgument='--version'
readonly downloadUrlTemplate='https://github.com/${githubRepository}/releases/download/v${version}/${name}_${version}_linux_${architecture}.tar.gz'

#### Installation Information
readonly binaryTargetFolder='/usr/local/bin'

readonly name="${githubRepository##*/}"


source functions/check_curl_envsubst_file_tar_installed.sh
source functions/curl_check_url.sh
source functions/curl_download_untar.sh
source functions/debian_get_arch.sh
source functions/echo_banner.sh
source functions/github_get_latest_release.sh
source functions/utils_check_version.sh


install() {
    utils_check_version "${VERSION}"
    check_curl_envsubst_file_tar_installed

    readonly architecture="$(debian_get_arch)"
    readonly binaryTargetPathTemplate='${binaryTargetFolder}/${binaryName}'

    if [ "${VERSION}" == 'latest' ] || [ -z "${VERSION}" ]; then
        VERSION=$(github_get_latest_release "${githubRepository}")
    fi

    readonly version="${VERSION:?}"
    readonly downloadUrl="$(echo -n "${downloadUrlTemplate}" | envsubst)"

    curl_check_url "${downloadUrl}"

    readonly binaryPathInArchive="${binaryName}"
    readonly stripComponents="$(echo -n "${binaryPathInArchive}" | awk -F'/' '{print NF-1}')"
    readonly binaryTargetPath="$(echo -n "${binaryTargetPathTemplate}" | envsubst)"

    curl_download_untar "${downloadUrl}" "${stripComponents}" "${binaryTargetFolder}" "${binaryPathInArchive}"
    chmod 755 "${binaryTargetPath}"
}

echo_banner "devcontainer.community"
echo "Installing ${name}..."
install "$@"
echo "(*) Done!"
