#!/bin/sh


eval `opam config env`

export PATH=$PATH:/home/larry/.local/bin
export LD_LIBRARY_PATH=/usr/lib/openssl-1.0

export BROWSER="qutebrowser"
export TERMINAL="urxvt"
export SUDO_ASKPASS="$HOME/.scripts/dmenupass"
export EDITOR="vim"

# ocaml and rust shit for cmsc330
eval `opam config env`
export PATH="$HOME/.cargo/bin:$PATH"
