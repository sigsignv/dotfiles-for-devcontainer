#!/bin/sh
set -u

if [ -z "${HOME:-}" ]; then
  echo "ERROR: \$HOME is not set" >&2
  exit 1
fi

file="${HOME}/.profile"
if [ ! -f "${file}" ]; then
  echo "ERROR: ${file} does not exist" >&2
  exit 1
fi

header="dotfiles-loader"
if grep -q "${header}" "${file}"; then
  echo "Skip: Loader is already present in ${file}"
  exit 0
fi

loader=$(cat <<'EOS'
if [ -d "$HOME/.profile.d" ]; then
    for i in $HOME/.profile.d/*.sh; do
        if [ -r "$i" ]; then
            . "$i"
        fi
    done
    unset i
fi
EOS
)

{
  echo ""
  echo "# ${header}"
  echo "${loader}"
} >> "${file}"

echo "Added loader to ~/.profile"
