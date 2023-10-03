#!/usr/bin/env bash

echo "#### $(date +%T) - INSTALANDO FERRAMENTAS NECESSÁRIAS"
sudo dnf install kmodtool akmods mokutil openssl -y

echo "#### $(date +%T) - GERANDO CHAVE"
sudo kmodgenca -a

echo "#### $(date +%T) - CONFIGURANDO A CHAVE"
sudo mokutil --import /etc/pki/akmods/certs/public_key.der

echo "#### $(date +%T) - REINICIANDO EM 10 SEGUNDOS"
sleep 10s
sudo reboot

echo "#### $(date +%T) - INSTALANDO DRIVERS NVIDIA"
sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 -y --allowerasing

echo "#### $(date +%T) - AGUARDANDO 10 MINUTOS PARA QUE SEJAM CARREGADOS OS MÓDULOS"
sleep 10m
echo "#### $(date +%T) - ESPERA FINALIZADA"

echo "#### $(date +%T) - ATUALIZANDO MÓDULOS KERNEL"
sudo akmods --force
sudo dracut --force

echo "#### $(date +%T) - REINICIANDO EM 10 SEGUNDOS"
sleep 10s
sudo reboot
