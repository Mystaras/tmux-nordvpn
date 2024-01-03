# tmux-nordVPN
Simple TMUX plugin to keep track of you nordVPN status.

## Installation

Add the plugin to your `~/.tmux.conf` file.
```bash
set -g @plugin 'Mystaras/tmux-nordvpn.git'
```

Add the `#{nordvpn_status}` format string to your status bar.
```bash
set -g status-right '#{nordvpn_status}'
```

Finally, `prefix + I` to fetch the plugin and source it.

## Issues
If the output does not refresh to your liking, add to your `~/.tmux.conf` file.
```bash
set -g status-interval 1
```



