#!/usr/bin/env bash
if [[ "$0" != "$BASH_SOURCE" ]]; then echo "no sourcing">&2; return 1; fi;
set -eu -o pipefail
[[ ${DEBUG:-} ]] && set -x

full="$(readlink -f "$BASH_SOURCE")"; dir=${full%\/*}; file=${full##*/};

files=""
for i in ~/.bashrc ~/.bash_aliases ~/.profile ; do files="$files $i"; done; unset i;

backup=$(date +%Y-%m-%d)

for f in $files; do
  echo installing $f
  mv -vn $f{,.backup.$backup} || :;

  src="$dir/$(basename $f)"
  [[ -h "$f" ]] && rm "$f" # if dest is link, remove it
  ln -s "$src" $f;
done
