# Script de Setup Inicial para Fedora

## install.sh

Realiza os seguintes passos de forma automatizada:
- [instalação de pacotes DNF](#instalacao-dnf)
- [alterar parâmetros **dnf.conf**](#dnf-conf)
- habilitar repositórios RPM Fusion Free e Nonfree
- habilitar repositório Visual Studio Code
- instalação de codecs de mídia
- [download e instalação de pacotes RPM](#instalacao-rpm)
- [download e instalação de pacotes Flatpak](#instalacao-flatpak)
- [instalação de extensões GNOME](#instalacao-extensoes-gnome)
- [troca do tema padrão](#troca-tema-padrao)
- [instalação Oh-My-Zsh](#instalacao-oh-my-zsh)

#
<a id="instalacao-dnf"></a>
### Instalação de pacotes DNF

> - git
> - code
> - nautilus-python
> - bottles
> - tilix
> - gh
> - zsh
> - gnome-tweaks
> - breeze-cursor-theme
> - dconf-editor
> - rclone
> - rclone-browser

#
<a id="dnf-conf"></a>
### Alterar Parâmetros dnf.conf

Adiciona os seguintes parâmetros para o arquivos dnf.conf

> - max_parallel_downloads=10
> - fastestmirror=true\n
> - deltarpm=true

#
<a id="instalacao-rpm"></a>
### Download e Instalação de Pacotes RPM

>- Real VNC Viewer

#
<a id="instalacao-flatpak"></a>
### Download e Instalação de Pacotes Flatpak

>- [GNOME Extension Manager](https://flathub.org/pt-BR/apps/com.mattjakeman.ExtensionManager)
>- [ONLY Office](https://flathub.org/pt-BR/apps/org.onlyoffice.desktopeditors)
>- [MEGA Sync](https://flathub.org/pt-BR/apps/nz.mega.MEGAsync)
>- [ZapZap WhatsApp Client](https://flathub.org/pt-BR/apps/com.rtosta.zapzap)
>- [Logseq](https://flathub.org/pt-BR/apps/com.mattjakeman.ExtensionManager)

#
<a id="instalacao-extensoes-gnome"></a>
### Instalação de Extensões GNOME

Instala as extensões listadas no arquivo [gnome-extensions.txt](./gnome-extensions.txt)

>- [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
>- [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
>- [Tray Icons Reloaded](https://extensions.gnome.org/extension/2890/tray-icons-reloaded/)
>- [Lock Keys Indicator](https://extensions.gnome.org/extension/36/lock-keys/)
>- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)
>- [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
>- [Removable Drive Menu](https://extensions.gnome.org/extension/7/removable-drive-menu/)
>- [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

Desinstala a extensão padrão de marca d'água do Fefora

>- [Gnome Shell Background Logo](https://src.fedoraproject.org/rpms/gnome-shell-extension-background-logo)

#
<a id="troca-tema-padrao"></a>
### Troca o Tema Padrão

Troca o cursor padrão para o Breeze Cursor.

#
<a id="instalacao-oh-my-zsh"></a>
### Instalação Oh-My-Zsh

Instala o Oh-My-Zsh para incrementar o terminal ZSH.

Instala também o Plugin [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) no ZSH.

Instala o tema [Dracula](https://github.com/dracula/zsh.git) no ZSH.

Ativa por padrão os plugins do ZSH:
>- git
>- zsh-autosuggestions
>- docker
>- docker-compose
>- gh