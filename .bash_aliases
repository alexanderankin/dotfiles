# utils

_should_complete() {
    # https://unix.stackexchange.com/a/9607
    # basically an interactive check (?)
    # if not empty, return error (false)
    if [[ -n $SSH_TTY ]] ; then return 1 ; fi
    return 0
}

_has_bc() {
    # _available_interfaces comes from bash-completions package
    # check if we have the bash completions package available
    # if not type is function = return error
    if ! [[ "$(type -t _available_interfaces)" == "function" ]] ; then return 1 ; else return 0; fi
}

parse_jwt() {
    local jwt=$1;
    local header=$(cut -d'.' -f1 <<< $jwt);
    local body=$(cut -d'.' -f2 <<< $jwt);
    echo "header:";
    echo $header | base64 -d 2>/dev/null | jq . || true;
    echo "body:";
    echo $body | base64 -d 2>/dev/null | jq . || true;
}

###
### local environment management
###

# fix up dns settings via the nmcli (NetworkManager CLI)
dns_set() {
    if [[ $# != "3" ]] ; then echo 'Usage: dns_set $interface $dns4 $dns6'; return 1; fi;
    nmcli device modify $1 ipv4.dns $2 && nmcli device modify $1 ipv6.dns $3;
}
dns_google() { dns_set "8.8.8.8,8.8.4.4" "2001:4860:4860::8888,2001:4860:4860::8844"; }
_should_complete && _has_bc && complete -F _available_interfaces dns_google

# https://unix.stackexchange.com/a/349821
# https://superuser.com/a/1088260
scan_ssh() { ssh-keygen -l -E md5 -f <(ssh-keyscan "$1" 2>/dev/null); }
# this one is neat but not perf friendly
# _should_complete && _has_bc && { __load_completion ssh && complete -F _ssh scan_ssh; }

gigabit_ethernet() { sudo ethtool -s $1 autoneg off speed 1000 duplex full; }
_should_complete && _has_bc && complete -F _available_interfaces gigabit_ethernet

# get however many chars, if there are no #, make the last one a #
devurandom() { local p=$(cat /dev/urandom | tr -dc '#A-Za-z0-9_' | head -c ${1:-16}); case "$p" in *#*) ;; *) p="${p::-1}#"; esac; echo $p; }

# # aliases for using external kb
# set_pinky_row_ext() { xmodmap -e 'keycode 112 = Home' -e 'keycode 117 = Prior' -e 'keycode 110 = Next' -e 'keycode 115 = End'; }
# set_pinky_row_us() { xmodmap -e 'keycode 110 = Home' -e 'keycode 112 = Prior' -e 'keycode 117 = Next' -e 'keycode 115 = End'; }

###
### server environment management
###
alias clearssh="for i in \$(ps -aux | grep ssh | awk '{ print \$2 }'); do kill -9 \$i; done;"
certonly () { sudo certbot --dry-run certonly --webroot -w "/var/www/verification/$1" -d "$1"; }

###
### dev tools
###

# git
desired_committer () {
    if [[ $# != "1" ]] ; then echo "Usage: desired_committer 'Name <email@host>'"; return 1; fi;
    local n=$(echo $1 | sed 's/ <.*//');
    local e=$(echo $1 | sed -e 's/.*<//' -e 's/>$//');
    git config user.email "$e";
    git config user.name "$n"
}
desired_committer_from_last() { desired_committer "$(git log -n1 --format='%aN <%aE>')"; }
git_remote_fix_https_to_ssh() {
    git remote set-url origin $(git remote get-url origin  | sed 's#https://github.com/\(.*\)#git@github.com:\1#');
}

# load dev secrets
SD=~/.ssh/.secrets.d; [[ -d $SD && $(find $SD -type f 2>/dev/null) ]] && for i in $SD/*; do ''. $i; done;

alias sqlcmd='docker run -it --rm --name sqlcmd -v $PWD:/wd --workdir /wd -u root mcr.microsoft.com/mssql/server:2019-CU11-ubuntu-20.04 /opt/mssql-tools/bin/sqlcmd'

token_for() { token=$(jq -r '.auths["'$1'"].auth' ~/.docker/config.json); }
token_for_() { local words=$(jq -r '.auths | keys | join(" ")' ~/.docker/config.json); COMPREPLY=($(compgen -W "$words" -- "${COMP_WORDS[COMP_CWORD]}")); return 0; }
complete -F token_for_ token_for

print_top_n_files() { sudo du -ha $1 | sort -h -r | head -n ${2:-50}; }

alias mqtt='java -jar ~/.bin/mqtt-cli-4.8.1.jar'
alias hs=http-server

# clipboard
# [[ -f 'C:\Windows\System32\clip.exe' ]] && :; # no alias necessary
[[ -f 'C:\Windows\System32\clip.exe' ]] && alias paste='powershell -command "Get-Clipboard"'
[[ -f /usr/bin/pbcopy ]] && { alias clip='pbcopy'; alias paste='pbpaste'; }
[[ -f /usr/bin/xclip ]] && { alias clip='xclip -sel clip'; alias paste='xclip -sel clip -o'; }

# cloud stuff
# alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias wanip4='curl -s4 icanhazip.com'
alias wanip6='curl -s6 icanhazip.com'

# command -v kind > /dev/null && source <(kind completion bash)
# command -v kubectl > /dev/null && source <(kubectl completion bash)

fork_it() { git remote add $2 $(git remote get-url origin | sed "s/$1/$2/"); }

complete -C aws_completer aws

# busl/foss HCP products
command -v tofu > /dev/null && {
    which_tf=$(which tofu)
    alias tf=tofu
    complete -C $which_tf tofu
    complete -C $which_tf tf
} || { :; }

command -v terraform > /dev/null && complete -C "$(which terraform)" terraform
command -v vault > /dev/null && complete -C vault vault
[[ -f /usr/bin/vault ]] && complete -C /usr/bin/vault vault

alias hs=http-server
alias tf=tofu

k_current_cluster() { kubectl config view -o json | jq '([.contexts[]|{key:.name,value:.}]|from_entries)[.["current-context"]].context.cluster' -r; }
# PKG=json-conv; BINS=(json2yaml yaml2json toml2json json2toml json2csv csv2json); { [[ -d ~/.$PKG-venv ]] || { [[ -d ~/.$PKG-venv/bin ]] && . ~/.$PKG-venv/bin/activate || . ~/.$PKG-venv/Scripts/activate; }; } && . ~/.$PKG-venv/bin/activate && pip install -U pip wheel && pip install 'git+https://github.com/alexanderankin/side-projects.git@main#egg='"$PKG"'&subdirectory=misc/projects/json-converters' && for b in "${BINS[@]}"; do ln -fvrs $(which $b) ~/.local/bin; done && deactivate
# PKG=ruff; BINS=(ruff); { [[ -d ~/.$PKG-venv ]] || python -m venv ~/.$PKG-venv; } && { [[ -d ~/.$PKG-venv/bin ]] && . ~/.$PKG-venv/bin/activate || . ~/.$PKG-venv/Scripts/activate; } && pip install -U pip wheel && pip install $PKG && for b in "${BINS[@]}"; do ln -fvrs $(which $b) ~/.local/bin; done && deactivate
# PKG=uv; BINS=(uv); { [[ -d ~/.$PKG-venv ]] || python -m venv ~/.$PKG-venv; } && { [[ -d ~/.$PKG-venv/bin ]] && . ~/.$PKG-venv/bin/activate || . ~/.$PKG-venv/Scripts/activate; } && pip install -U pip wheel && pip install $PKG && for b in "${BINS[@]}"; do ln -fvrs $(which $b) ~/.local/bin; done && deactivate
# PKG=poetry; BINS=(poetry); { [[ -d ~/.$PKG-venv ]] || python -m venv ~/.$PKG-venv; } && { [[ -d ~/.$PKG-venv/bin ]] && . ~/.$PKG-venv/bin/activate || . ~/.$PKG-venv/Scripts/activate; } && pip install -U pip wheel && pip install $PKG && for b in "${BINS[@]}"; do ln -fvrs $(which $b) ~/.local/bin; done && deactivate
# PKG=oci-cli; BINS=(oci); { [[ -d ~/.$PKG-venv ]] || python -m venv ~/.$PKG-venv; } && { [[ -d ~/.$PKG-venv/bin ]] && . ~/.$PKG-venv/bin/activate || . ~/.$PKG-venv/Scripts/activate; } && pip install -U pip wheel && pip install $PKG && for b in "${BINS[@]}"; do ln -fvrs $(which $b) ~/.local/bin; done && deactivate
