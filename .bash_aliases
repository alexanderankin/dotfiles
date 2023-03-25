# https://git.launchpad.net/ubuntu/+source/base-files/tree/share/dot.bashrc
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias wanip4='curl -s4 icanhazip.com'
alias wanip6='curl -s6 icanhazip.com'
alias dns_google='nmcli device modify wlp0s20f3 ipv4.dns 8.8.8.8,8.8.4.4 && nmcli device modify wlp0s20f3 ipv6.dns 2001:4860:4860::8888,2001:4860:4860::8844'
alias clearssh="for i in \$(ps -aux | grep ssh | awk '{ print \$2 }'); do kill -9 \$i; done;"

function devurandom() { cat /dev/urandom | tr -dc 'a-zA-Z0-9#' | head -c ${1:-20} && printf '#' && echo; }

function gigabit_ethernet() { sudo ethtool -s $1 autoneg off speed 1000 duplex full; }
# https://unix.stackexchange.com/a/9607
[ -z $SSH_TTY ] && command -v complete >/dev/null 2>&1 && $(complete -p ethtool | sed '$s/\w*$/gigabit_ethernet/');