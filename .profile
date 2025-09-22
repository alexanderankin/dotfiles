# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# original: https://git.launchpad.net/ubuntu/+source/bash/tree/debian/skel.profile?h=ubuntu/noble

# set env vars
export TOTP_PASS=p # no i dont care - its not for security, its for convenience https://github.com/yitsushi/totp-cli
export HOMEBREW_NO_AUTO_UPDATE=1

# homebrew paths
test -x /opt/homebrew/bin/brew && {
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="$(brew --prefix python@3.11)/libexec/bin:$PATH"
  export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gsed)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gawk)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix ruby)/bin:$PATH"

  export PATH="$PATH":~/Library/Android/sdk/platform-tools
}

# paths
export PATH=$PATH:~/.local/bin:~/.yarn/bin:~/.pulumi/bin
# bun
export BUN_INSTALL=~/.bun
export PATH="$PATH:${BUN_INSTALL}/bin"
# toolbox
if [[ -n ${HOMEBREW_PREFIX:-} ]] ; then
# Added by Toolbox App
export PATH="$PATH":~/"Library/Application Support/JetBrains/Toolbox/scripts"
else
# Added by Toolbox App
export PATH="$PATH":~/".local/share/JetBrains/Toolbox/scripts"
fi
# sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# nix
# ~/.nix-profile/etc/profile.d/nix.sh
# if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
# export XDG_DATA_HOME="${XDG_DATA_HOME:="$HOME/.local/share"}"
# cargo
test -f $HOME/.cargo/env && . "$HOME/.cargo/env"
# gvm
[[ -s ~/.gvm/scripts/gvm ]] && source ~/.gvm/scripts/gvm
[[ -s ~/.gvm/scripts/gvm ]] && gvm use go1.21
# ruby
command -v rbenv > /dev/null && eval "$(rbenv init -)"
# asdf
# asdf was rewritten in go in version 0.16
command -v asdf > /dev/null && {
  export ASDF_DATA_DIR=~/.asdf
  export PATH="$PATH:$ASDF_DATA_DIR/shims"
} || {
  alias setup_asdf="git clone https://github.com/asdf-vm/asdf.git ~/.asdf && cd ~/.asdf && make"
  alias download_asdf="curl -fSsL 'https://api.github.com/repos/asdf-vm/asdf/releases' | jq .[0].assets[].browser_download_url -r"
}

# previous version of asdf were shell utilities:
#[[ -f ~/.asdf/asdf.sh ]] && . ~/.asdf/asdf.sh
#[[ -f ~/.asdf/completions/asdf.bash ]] && . ~/.asdf/completions/asdf.bash

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('~/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "~/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "~/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="~/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<

# if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
# export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
