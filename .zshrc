export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/toor/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
