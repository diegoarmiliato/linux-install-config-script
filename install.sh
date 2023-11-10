#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
URL_REAL_VNC="https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.6.1-Linux-x64.rpm"

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  git
  code
  nautilus-python
  bottles
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Atualizando o repositório ##
echo "#### $(date +%T) - ATUALIZANDO REPOSITÓRIOS"
sudo dnf update -y

## Alterando configurações DNF
echo "#### $(date +%T) - ADICIONANDO PARAMETROS DNF.CONF"
cat /etc/dnf/dnf.conf
if ! cat /etc/dnf/dnf.conf | grep -q "max_parallel_downloads"; then echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "fastestmirror"; then echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "deltarpm"; then echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf; fi
cat /etc/dnf/dnf.conf

## Atualizando o repositório ##
echo "#### $(date +%T) - ATUALIZANDO REPOSITÓRIOS"
sudo dnf update -y

echo "#### $(date +%T) - HABILITAR RPM FUSION FREE"
## Habilitar RPM Fusion Free
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y

echo "#### $(date +%T) - HABILITAR RPM FUSION NONFREE"
## Habilitar RPM Fusion Nonfree
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Repositório Visual Studio Code
echo "#### $(date +%T) - HABILITAR REPOSITÓRIO VISUAL STUDIO CODE"
cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

echo "#### $(date +%T) - EXECUTANDO DNF UPGRADE"
## Atualizar com os dados dos repositórios adicionados
sudo dnf upgrade --refresh

echo "#### $(date +%T) - INSTALAR CODECS DE MIDIA"
## Instalar CODECs de Mídia
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y --allowerasing

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
echo "#### $(date +%T) - ATUALIZANDO REPOSITÓRIOS"
sudo dnf update -y

echo "#### $(date +%T) - INSTALANDO PACOTES RPM"
## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_REAL_VNC"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo rpm -i $DIRETORIO_DOWNLOADS/*.rpm
rm -rf "$DIRETORIO_DOWNLOADS"

echo "#### $(date +%T) - INSTALANDO APPS VIA DNF"
# Instalar programas no dnf
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
    sudo dnf install "$nome_do_programa" -y
done

## Instalando pacotes Flatpak ##
echo "#### $(date +%T) - INSTALANDO APPS VIA FLATPAK"
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub nz.mega.MEGAsync -y
flatpak install flathub com.rtosta.zapzap -y

git config --global user.email "degoarmiliato@gmail.com"
git config --global user.name "diegoarmiliato"
