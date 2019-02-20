#!/bin/sh

export BROWSER="qutebrowser"
export TERMINAL="urxvt"
export SUDO_ASKPASS="$HOME/.scripts/dmenupass"
export EDITOR="vim"

# ocaml and rust shit for cmsc330
eval `opam config env`
export PATH="$HOME/.cargo/bin:$PATH"
