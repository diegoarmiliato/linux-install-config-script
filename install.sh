#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
USER=$(whoami)
LOG_FILE="./log/install-$(date +%T).log"
mkdir -p log
exec > >(tee ${LOG_FILE}) 2>&1


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
  gnome-tweaks
  breeze-cursor-theme
  dconf-editor
  rclone
  rclone-browser
  rabbitvcs-nautilus
  distrobox
)

COLOR='\033[1;36m'         # Cyan
NC='\033[0m'               # No Color

# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Atualizando o repositório ##
echo -e "${COLOR}#### $(date +%T) - ATUALIZANDO REPOSITÓRIOS${NC}"
sudo dnf update -y

## Alterando configurações DNF
echo -e "${COLOR}#### $(date +%T) - ADICIONANDO PARAMETROS DNF.CONF${NC}"
cat /etc/dnf/dnf.conf
if ! cat /etc/dnf/dnf.conf | grep -q "max_parallel_downloads"; then echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "fastestmirror"; then echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "deltarpm"; then echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "defaultyes"; then echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf; fi
cat /etc/dnf/dnf.conf

## Atualizando o repositório ##
echo -e "${COLOR}#### $(date +%T) - ATUALIZANDO REPOSITÓRIOS${NC}"
sudo dnf update -y

echo -e "${COLOR}#### $(date +%T) - HABILITAR RPM FUSION FREE${NC}"
## Habilitar RPM Fusion Free
#sudo dnf install \
#  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y

echo -e "${COLOR}#### $(date +%T) - HABILITAR RPM FUSION NONFREE${NC}"
## Habilitar RPM Fusion Nonfree
#sudo dnf install \
#  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Repositório Visual Studio Code
echo -e "${COLOR}#### $(date +%T) - HABILITAR REPOSITÓRIO VISUAL STUDIO CODE${NC}"
cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

echo -e "${COLOR}#### $(date +%T) - EXECUTANDO DNF UPGRADE${NC}"
## Atualizar com os dados dos repositórios adicionados
sudo dnf upgrade --refresh

echo -e "${COLOR}#### $(date +%T) - INSTALAR CODECS DE MIDIA${NC}"
## Instalar CODECs de Mídia
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y --allowerasing

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
echo -e "${COLOR}#### $(date +%T) - ATUALIZANDO REPOSITÓRIOS${NC}"
sudo dnf update -y

echo -e "${COLOR}#### $(date +%T) - INSTALANDO PACOTES RPM${NC}"
## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_REAL_VNC"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo rpm -i $DIRETORIO_DOWNLOADS/*.rpm
rm -rf "$DIRETORIO_DOWNLOADS"

echo -e "${COLOR}#### $(date +%T) - INSTALANDO APPS VIA DNF${NC}"
# Instalar programas no dnf
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
    sudo dnf install "$nome_do_programa" -y
done

## Instalando pacotes Flatpak ##
echo -e "${COLOR}#### $(date +%T) - INSTALANDO APPS VIA FLATPAK${NC}"
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub nz.mega.MEGAsync -y
flatpak install flathub com.rtosta.zapzap -y
flatpak install flathub com.logseq.Logseq -y
flatpak install flathub io.missioncenter.MissionCenter -y
flatpak install flathub io.github.realmazharhussain.GdmSettings -y

echo -e "${COLOR}#### $(date +%T) - CONFIGURAÇÕES GLOBAIS GIT${NC}"
git config --global user.email "degoarmiliato@gmail.com"
git config --global user.name "diegoarmiliato"

## Instalando Extensões Gnome ##
echo -e "${COLOR}#### $(date +%T) - INSTALANDO EXTENSÕES GNOME${NC}"
git clone https://github.com/ToasterUwU/install-gnome-extensions.git
cd install-gnome-extensions
chmod +x install-gnome-extensions.sh
./install-gnome-extensions.sh -e --file ./../gnome-extensions.txt
cd ..
rm -rf ./install-gnome-extensions

## Removendo Backgound Logo
echo -e "${COLOR}#### $(date +%T) - REMOVENDO EXTENSÃO BACKGROUND LOGO FEDORA${NC}"
sudo dnf remove gnome-shell-extension-background-logo -y

## Trocando o Tema
echo -e "${COLOR}#### $(date +%T) - INSTALANDO CURSOR BREEZE${NC}"
dconf write /org/gnome/desktop/interface/cursor-theme "'breeze_cursors'"
dconf update

## Instalando Oh-My-Zsh
echo -e "${COLOR}#### $(date +%T) - INSTALANDO OH-MY-ZSH${NC}"
CURRENT_DIR=$(pwd)
cd ~
if [ ! -d ".oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &

  echo "Waiting Oh-My-Zsh installation to finish ..."
  until [ -d ".oh-my-zsh" ]
  do     
     sleep 5
     echo "..."
  done
  echo "finished"

  echo -e "${COLOR}#### $(date +%T) - INSTALANDO PLUGIN AUTOSUGGESTION ZSH${NC}"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  sed -i 's/plugins=(git/plugins=(git zsh-autosuggestions docker docker-compose gh/g' ~/.zshrc

  echo -e "${COLOR}#### $(date +%T) - INSTALANDO TEMA DRACULA ZSH${NC}"
  cd Downloads
  git clone https://github.com/dracula/zsh.git
  cd zsh
  cp dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
  cp -r lib ~/.oh-my-zsh/themes
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dracula"/g' ~/.zshrc
  cd ..
  rm -rf zsh
  chsh -s /bin/zsh $USER
else
  echo "Já instalado. Ignorando..."
fi
cd $CURRENT_DIR

echo -e "${COLOR}#### $(date +%T) - INSTALANDO DOCKER${NC}"
if ! command -v docker &>/dev/null; then
  sudo dnf install dnf-plugins-core -y
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  sudo systemctl start docker
else
  echo "Já instalado. Ignorando..."
fi

