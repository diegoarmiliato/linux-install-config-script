#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
URL_REAL_VNC="https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.6.1-Linux-x64.rpm"

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  git
  code
  nautilus-python
  bottles
  tilix
  gh
  zsh
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

echo "#### $(date +%T) - CONFIGURAÇÕES GLOBAIS GIT"
git config --global user.email "degoarmiliato@gmail.com"
git config --global user.name "diegoarmiliato"

## Instalando Extensões Gnome ##
echo "#### $(date +%T) - INSTALANDO EXTENSÕES GNOME"
git clone https://github.com/ToasterUwU/install-gnome-extensions.git
cd install-gnome-extensions
chmod +x install-gnome-extensions.sh
./install-gnome-extensions.sh --enable --file ./../gnome-extensions.txt
cd ..
rm -rf ./install-gnome-extensions

## Instalando Oh-My-Zsh
echo "#### $(date +%T) - INSTALANDO OH-MY-ZSH"
CURRENT_DIR=$(pwd)
cd ~
if [ -d ".oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "#### $(date +%T) - INSTALANDO PLUGIN AUTOSUGGESTION ZSH"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  sed -i 's/plugins=(git/plugins=(git zsh-autosuggestions docker docker-compose gh/g' ~/.zshrc

  echo "#### $(date +%T) - INSTALANDO TEMA DRACULA ZSH"
  cd Downloads
  git clone https://github.com/dracula/zsh.git
  cd zsh
  cp dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
  cp -r lib ~/.oh-my-zsh/themes
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dracula"/g' ~/.zshrc
  cd ..
  rm -rf zsh

  source ~/.zshrc
else
  echo "Já instalado. Ignorando..."
fi
cd $CURRENT_DIR




