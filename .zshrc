# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files source by it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Automaticaly wrap TTY with a transparent tmux ('integrated'), or start a
# full-fledged tmux ('system'), or disable features that require tmux ('no').
zstyle ':z4h:' start-tmux       'no'
# Move prompt to the bottom when zsh starts up so that it's always in the
# same position. Has no effect if start-tmux is 'no'.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# ssh when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over ssh to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.tmux.conf' '~/.profile' '~/.hushlogin'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
# z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=($HOME/bin $HOME/.local/bin $path)
if [[ -d /usr/local/opt/coreutils/libexec/gnubin ]]; then
  path=(/usr/local/opt/coreutils/libexec/gnubin $path)
fi
if [[ -d $HOME/.linuxbrew ]]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  if [[ -d $HOME/.linuxbrew/opt/coreutils/libexec/gnubin ]]; then
    path=($HOME/.linuxbrew/opt/coreutils/libexec/gnubin $path)
  fi
fi

# Export environment variables.
ZLE_RPROMPT_INDENT=0
export GPG_TTY=$TTY
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=UTF-8
export XDG_CONFIG_HOME=$HOME/.config
if [[ -d $HOME/.local/share/perl5/lib/perl5 ]]; then
  eval "$(perl -I$HOME/.local/share/perl5/lib/perl5 -Mlocal::lib=$HOME/.local/share/perl5)" &>/dev/null
fi
if [[ -f $HOME/.local/share/global-lightswitch/.dircolors.base16.dark ]]; then
  eval "$(dircolors $HOME/.local/share/global-lightswitch/.dircolors.base16.dark)"
fi
# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source $Z4H/ohmyzsh/ohmyzsh/lib/diagnostics.zsh
# z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/emoji-clock/emoji-clock.plugin.zsh
# fpath+=($Z4H/ohmyzsh/ohmyzsh/plugins/supervisor)

# Source additional local files if they exist.
# z4h source ~/.iterm2_shell_integration.zsh
if type brew &>/dev/null; then
  fpath+=($(brew --prefix)/share/zsh/site-functions)

  autoload -Uz compinit
  compinit
  if type asdf &>/dev/null; then
    . $(brew --prefix asdf)/asdf.sh
    . ~/.asdf/plugins/java/set-java-home.zsh
  fi
fi

# Define key bindings.
z4h bindkey undo Ctrl+/  # undo the last command line change
z4h bindkey redo Alt+/   # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

function rr () {
  INITIAL_QUERY=""
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --height=50% --layout=reverse --delimiter : --preview 'bat --style=numbers --color=always --line-range :5000 -H {2} {1}' --preview-window '+{2}+3/2'
}

function mssh () {
  kitty +kitten ssh "$1" 'echo "kitty terminfo deployed"' 
  z4h ssh "$@"
}

function colors () {
  for i in {0..21} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i % 7 == 0 )); then
        printf "\n";
    fi
  done
}

# function tmux () {
#   if [[ ! -d ~/.tmux/plugins/tpm ]]; then 
#     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#   fi
#   command tmux "$@" 
# }

function yeet () {
  (nohup yeet "$@" &>/dev/null &)
}

function weather () {
  locations='Leipzig,Paderborn,Hannover,Aachen,Silves,Peking,Reykjavik,San Francisco'
  curl -s 'wttr.in/{'"$locations"'}?format=3' | fzf --height=20% --layout=reverse | sed -r -e 's/^(.*):.*/\1/' | cat <(echo -n "wttr.in/") - | xargs curl -0
}

function brewit () {
  brew update
  brew outdated
  echo "Continue? (y/n)"
  read -sk tmp
  if [[ "$tmp" == "y" ]]; then
    brew upgrade --greedy --casks --no-quarantine && brew upgrade --formulae
  fi
}

# Replace `ssh` with `z4h ssh` to automatically teleport z4h to remote hosts.
# function ssh() { z4h ssh "$@" }

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -n $z4h_win_home ]] && hash -d w=$z4h_win_home

# Define aliases.
if [[ $OSTYPE == darwin* ]]; then
  alias bi='brew install '
  alias bic='brew install --cask --no-quarantine '
  alias sed='gsed'
  alias grep='ggrep'
  alias units='gunits'
fi

alias ls='ls -Alh --color=auto'
alias tree='tree -a -I .git'
alias mc='mc -x'
# Add flags to existing aliases.
if command ls --hyperlink=auto /dev/null &> /dev/null; then
  alias ls="${aliases[ls]:-ls} --hyperlink=auto"
fi

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

if ps $PPID | grep mc; then
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"