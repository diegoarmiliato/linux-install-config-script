#!/usr/bin/env bash

distrobox create --name archlinux --image archlinux

distrobox enter archlinux

sudo pacman -S aichat --noconfirm

distrobox-export -app aichat