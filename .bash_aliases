alias wanip4='curl -s4 icanhazip.com'
alias wanip6='curl -s6 icanhazip.com'
alias dns_google='nmcli device modify wlp0s20f3 ipv4.dns 8.8.8.8,8.8.4.4 && nmcli device modify wlp0s20f3 ipv6.dns 2001:4860:4860::8888,2001:4860:4860::8844'
alias clearssh="for i in \$(ps -aux | grep ssh | awk '{ print \$2 }'); do kill -9 \$i; done;"

function devurandom() { cat /dev/urandom | tr -dc 'a-zA-Z0-9#' | head -c ${1:-20} && printf '#' && echo; }
