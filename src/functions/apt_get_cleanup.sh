#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


# Cleans up the apt-get cache
apt_get_cleanup() {
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}
