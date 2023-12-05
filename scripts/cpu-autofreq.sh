#!/usr/bin/env bash

cd ~

cd Downloads

git clone https://github.com/AdnanHodzic/auto-cpufreq.git

cd auto-cpufreq

chmod +x auto-cpufreq-installer

sudo ./auto-cpufreq-installer

sudo auto-cpufreq --install

sudo auto-cpufreq --monitor

sudo auto-cpufreq --live

sudo auto-cpufreq --stats
