# https://git.launchpad.net/ubuntu/+source/base-files/tree/share/dot.bashrc
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias wanip4='curl -s4 icanhazip.com'
alias wanip6='curl -s6 icanhazip.com'
alias dns_google='nmcli device modify wlp0s20f3 ipv4.dns 8.8.8.8,8.8.4.4 && nmcli device modify wlp0s20f3 ipv6.dns 2001:4860:4860::8888,2001:4860:4860::8844'
alias clearssh="for i in \$(ps -aux | grep ssh | awk '{ print \$2 }'); do kill -9 \$i; done;"
scanssh() { ssh-keygen -lf <(ssh-keyscan "$1" 2>/dev/null); } # https://unix.stackexchange.com/a/349821

# get however many chars, if there are no #, maybe the last one a #
devurandom() { local p=$(cat /dev/urandom | tr -dc '#A-Za-z0-9_' | head -c ${1:-16}); case "$p" in *#*) ;; *) p="${p#[a-z]}#"; esac; echo $p; }

function gigabit_ethernet() { sudo ethtool -s $1 autoneg off speed 1000 duplex full; }
# https://unix.stackexchange.com/a/9607
[ -z $SSH_TTY ] && command -v complete >/dev/null 2>&1 && $(complete -p ethtool | sed '$s/\w*$/gigabit_ethernet/');

# aliases for using external kb
set_pinky_row_ext() { xmodmap -e 'keycode 112 = Home' -e 'keycode 117 = Prior' -e 'keycode 110 = Next' -e 'keycode 115 = End'; }
set_pinky_row_us() { xmodmap -e 'keycode 110 = Home' -e 'keycode 112 = Prior' -e 'keycode 117 = Next' -e 'keycode 115 = End'; }

function aws_completion() { complete -C $(which aws_completer) aws; }

function certonly () { sudo certbot --dry-run certonly --webroot -w "/var/www/verification/$1" -d "$1"; }

function git_remote_fix_https_to_ssh() {
    git remote set-url origin $(git remote get-url origin  | sed 's#https://github.com/\(.*\)#git@github.com:\1#');
}

desired_committer () {
    local n=$(echo $1 | sed 's/ <.*//');
    local e=$(echo $1 | sed -e 's/.*<//' -e 's/>$//');
    git config user.email "$e";
    git config user.name "$n"
}

desired_committer_from_last() { desired_committer "$(git log -n1 --format='%aN <%aE>')"; }
