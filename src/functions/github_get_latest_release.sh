#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


source github_list_releases.sh

github_get_latest_release() {
  if [ -z "$1" ]; then
    echo "Usage: get_latest_github_release <owner/repo>"
    return 1
  fi

  # Get the latest release version for the given repository
  github_list_releases "$1" | head -n 1
}
