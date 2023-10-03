#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  git																											  
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Atualizando o repositório ##
echo "##############################################################################"
echo "1. ATUALIZANDO REPOSITÓRIOS"
echo "##############################################################################"
sudo dnf update -y
echo "1. FIM"

## Alterando configurações DNF
echo "##############################################################################"
echo "2. ADICIONANDO PARAMETROS DNF.CONF"
echo "##############################################################################"
cat /etc/dnf/dnf.conf
if ! cat /etc/dnf/dnf.conf | grep -q "max_parallel_downloads"; then sudo echo "max_parallel_downloads=10">>/etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "fastestmirror"; then sudo echo "fastestmirror=true">>/etc/dnf/dnf.conf; fi
if ! cat /etc/dnf/dnf.conf | grep -q "deltarpm"; then sudo echo "deltarpm=true">>/etc/dnf/dnf.conf; fi
cat /etc/dnf/dnf.conf
echo "2. FIM"

## Atualizando o repositório ##
echo "##############################################################################"
echo "3. ATUALIZANDO REPOSITÓRIOS"
echo "##############################################################################"
sudo dnf update -y
echo "3. FIM"

echo "##############################################################################"
echo "4. HABILITAR RPM FUSION FREE"
echo "##############################################################################"
## Habilitar RPM Fusion Free
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
echo "4. FIM"

echo "##############################################################################"
echo "5. HABILITAR RPM FUSION NONFREE"
echo "##############################################################################"
## Habilitar RPM Fusion Nonfree
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
echo "5. FIM"


echo "##############################################################################"
echo "6. EXECUTANDO DNF UPGRADE"
echo "##############################################################################"
## Atualizar com os dados dos repositórios adicionados
sudo dnf upgrade --refresh
echo "6. FIM"

echo "##############################################################################"
echo "7. INSTALAR CODECS DE MIDIA"
echo "##############################################################################"
## Instalar CODECs de Mídia
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y --allowerasing
echo "7. FIM"

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
echo "##############################################################################"
echo "8. ATUALIZANDO REPOSITÓRIOS"
echo "##############################################################################"
sudo dnf update -y
echo "8. FIM"

echo "##############################################################################"
echo "9. INSTALANDO PACOTES RPM"
echo "##############################################################################"
## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
## wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.rpm
rm -rf "$DIRETORIO_DOWNLOADS"
echo "9. FIM"

echo "##############################################################################"
echo "10. INSTALANDO APPS VIA DNF"
echo "##############################################################################"
# Instalar programas no dnf
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! rpm -qa | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    dnf install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done
echo "10. FIM"

## Instalando pacotes Flatpak ##
echo "##############################################################################"
echo "11. INSTALANDO APPS VIA FLATPAK"
echo "##############################################################################"
flatpak install flathub com.mattjakeman.ExtensionManager -y
echo "11. FIM"

git config --global user.email "degoarmiliato@gmail.com"
git config --global user.name "diegoarmiliato"
