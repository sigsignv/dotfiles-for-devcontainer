#!/bin/sh

set -u

if [ -z "${HOME:-}" ]; then
    printf '%s\n' 'ERROR: $HOME is not set' >&2
    exit 1
fi

# Set XDG_CONFIG_HOME to the default if not set
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

deploy_config() {
    src="$1"
    dest="$2"

    if [ -z "${src}" ] || [ -z "${dest}" ]; then
        printf '%s\n' "ERROR: source and destination must be provided" >&2
        exit 1
    fi

    if [ ! -e "${src}" ]; then
        printf '%s\n' "Skip: ${src} does not exist"
        return
    fi

    if [ -e "${dest}" ]; then
        printf '%s\n' "Skip: ${dest} already exists"
        return
    fi

    dir="$(dirname -- "${dest}")"
    mkdir -p -- "${dir}" || {
        printf '%s\n' "ERROR: failed to create directory: ${dir}" >&2
        exit 1
    }

    ln -s -- "${src}" "${dest}" || {
        printf '%s\n' "ERROR: failed to create symbolic link: ${dest}" >&2
        exit 1
    }
}

srcDir="$(realpath -- "$(dirname -- "$0")")"

deploy_config "${srcDir}/git/ignore" "${XDG_CONFIG_HOME}/git/ignore"
deploy_config "${srcDir}/.npmrc" "${HOME}/.npmrc"
