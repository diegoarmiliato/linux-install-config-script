#!/usr/bin/env bash
LOG_FILE="./log/nvidia-$(date +%T).log"
mkdir -p log
exec > >(tee ${LOG_FILE}) 2>&1

COLOR='\033[1;36m'         # Cyan
NC='\033[0m'               # No Color

if sudo bash -c '[ ! -f "/etc/pki/akmods/certs/public_key.der" ]'; then 
    echo -e "${COLOR}#### $(date +%T) - INSTALANDO FERRAMENTAS NECESSÁRIAS${NC}"
    sudo dnf install kmodtool akmods mokutil openssl -y

    echo -e "${COLOR}#### $(date +%T) - GERANDO CHAVE${NC}"
    sudo kmodgenca -a

    echo -e "${COLOR}#### $(date +%T) - CONFIGURANDO A CHAVE${NC}"
    sudo mokutil --import /etc/pki/akmods/certs/public_key.der

    echo -e "${COLOR}#### $(date +%T) - REINICIANDO EM 10 SEGUNDOS${NC}"
    sleep 10s
    sudo reboot
else
    echo -e "${COLOR}#### $(date +%T) - INSTALANDO DRIVERS NVIDIA${NC}"
    sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 -y --allowerasing

    echo -e "${COLOR}#### $(date +%T) - AGUARDANDO 10 MINUTOS PARA QUE SEJAM CARREGADOS OS MÓDULOS${NC}"
    sleep 10m

    echo -e "${COLOR}#### $(date +%T) - ESPERA FINALIZADA${NC}"

    echo -e "${COLOR}#### $(date +%T) - ATUALIZANDO MÓDULOS KERNEL${NC}"
    sudo akmods --force
    sudo dracut --force

    echo -e "${COLOR}#### $(date +%T) - REINICIANDO EM 10 SEGUNDOS${NC}"
    sleep 10s
    sudo reboot
fi    
