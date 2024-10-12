#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


debian_get_arch() {
    echo "$(dpkg --print-architecture)"
}
