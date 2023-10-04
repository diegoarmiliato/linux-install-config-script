#!/usr/bin/env bash

mkdir -p ~/.local/share/nautilus-python/extensions

cd ~/.local/share/nautilus-python/extensions

wget https://raw.githubusercontent.com/jesusferm/Nautilus-43-BackSpace/main/BackSpace.py

killall nautilus
