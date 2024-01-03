#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/scripts/helpers.sh

nordvpn_commands=(
	"#($CURRENT_DIR/scripts/nordvpn_status.sh)"
)

nordvpn_interpolation=(
	"\#{nordvpn_status}"
)

do_interpolation() {
  local all_interpolated="$1"
  for ((i = 0; i < ${#nordvpn_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${nordvpn_interpolation[$i]}/${nordvpn_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  	local option
  	local option_value
  	local new_option_value
  	option=$1
  	option_value=$(get_tmux_option "$option")
  	new_option_value=$(do_interpolation "$option_value")
  	set_tmux_option "$option" "$new_option_value"
	echo "$option" 
	echo "$new_option_value"
}

main() {
  update_tmux_option "status-left"
  update_tmux_option "status-right"
}

main
