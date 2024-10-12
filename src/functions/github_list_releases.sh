#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


github_list_releases() {
  if [ -z "$1" ]; then
    echo "Usage: list_github_releases <owner/repo>"
    return 1
  fi

  # GitHub API URL to list releases for the given repository
  local repo="$1"
  local url="https://api.github.com/repos/$repo/releases"

  # Get the release data from the GitHub API, extract the version tags (X.Y.Z format)
  curl -s "$url" | grep -Po '"tag_name": "\K.*?(?=")' | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sed 's/^v//'
}
