#!/usr/bin/env -S bash --noprofile --norc -o errexit -o pipefail -o noclobber -o nounset -o allexport


echo_banner() {
  local text="$1"
  # ANSI codes: \e[1m -> Bold, \e[97m -> Bright white, \e[41m -> Red background, \e[0m -> Reset
  echo -e "\e[1m\e[97m\e[41m${text}\e[0m"
}
