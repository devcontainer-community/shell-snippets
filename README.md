# devcontainer.community: Shell Snippets

> A collection of shell snippets for frequently used commands in `install.sh` scripts for devcontainer features.


## Examples

### Install an `apt` package, and cleanup

```bash
apt_get_checkinstall git
apt_get_clean
```

To use this snippet, use the functions defined in `src/functions/apt_get_checkinstall.sh`, `src/functions/apt_get_update`, and `src/functions/apt_get_clean.sh`:

```bash
apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

apt_get_checkinstall() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends --no-install-suggests --option 'Debug::pkgProblemResolver=true' --option 'Debug::pkgAcquire::Worker=1' "$@"
    fi
}

apt_get_cleanup() {
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}
```

### Bundling install scripts

The functions defined in `src/functions/*.sh` can be bundled into a single script.
All of those functions use the `source` command to reference other scripts.

We can use [bash_bundler](https://github.com/malscent/bash_bundler) to bundle all the scripts into a single file.

Here is an example script:

```bash
source functions/echo_banner.sh
echo_banner "devcontainer.community"
```

To bundle this script, run the following command:

```sh
bash_bundler bundle -e example_script.sh -o bundle.example_script.sh
```

A full example for an `install.sh` script that installs [chezmoi](https://github.com/twpayne/chezmoi) from GitHub releases is given in `src/examples/example.install.chezmoi.sh`:

```bash
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
```
