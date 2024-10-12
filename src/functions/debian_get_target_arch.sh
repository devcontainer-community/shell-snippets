#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


source debian_get_arch.sh

debian_get_target_arch() {
    case $(debian_get_arch) in
        amd64) echo 'x86_64';;
        arm64) echo 'aarch64';;
        armhf) echo 'armv7';;
        i386) echo 'i686';;
        *) echo 'unknown';;
    esac
}
