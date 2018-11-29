#!/usr/bin/env bash

#### Instalacion de software para equipos OEM
#### Escrito por: Alejandro Troncoso - www.altmar.es - founds@gmail.com

SOFT_INST=$(dpkg --get-selections)
START=$(date +%s)
LOCK="/var/run/rsync.lock"

txtund=$(tput sgr 0 1)    # Underline
txtbld=$(tput bold)       # Bold
txtred=$(tput setaf 1)    # Red
txtgrn=$(tput setaf 2)    # Green
txtylw=$(tput setaf 3)    # Yellow
txtblu=$(tput setaf 4)    # Blue
txtpur=$(tput setaf 5)    # Purple
txtcyn=$(tput setaf 6)    # Cyan
txtwht=$(tput setaf 7)    # White
txtrst=$(tput sgr0)       # Text reset

# Evita que se pueda abrir mas de una instancia.

# Requerir permisos administrativos
if [[ $(/usr/bin/id -u) -ne 0 ]]; then 
	echo "${txtred}✖ ${txtbld}Tiene que tener permisos de root para poder ejecutar script.${txtrst}" 
	exit 
fi

### MAQUETAS

## Escritorio Normal
function f_desktop()
{
	apt update
	apt dist-upgrade
	apt install -y vlc gnome-tweak-tool chrome-gnome-shell gstreamer1.0-fluendo-mp3 gstreamer1.0-libav ubuntu-restricted-extras unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip chromium-browser mtp-tools ipheth-utils ideviceinstaller ifuse printer-driver-all git python-software-properties shutter
	/usr/share/doc/libdvdread4/install-css.s­h 
}

function f_developer()
{
	apt install -y filezilla gitg git
}

### HERRAMIENTAS

## DISCO DURO

# PARTIMAGE
function f_partimage()
{
	apt-get install partimage
}

### CRIPTOMONEDAS

## MINEROS

# DASH CPU MINER
function f_cpuminer()
{
	cd ~
	git clone https://github.com/elmad/darkcoin-cpuminer-1.3-avx-aes
	cd darkcoin-cpuminer-1.3-avx-aes/
	chmod +x autogen.sh
	./autogen.sh
	./configure CFLAGS="-O3 -march=native"
	make
	make install
}


## WALLETS

# DASH WALLET
function f_cgminer()
{
	cd ~
	wget https://github.com/dashpay/dash/releases/download/v0.12.3.2/dashcore-0.12.3.2-x86_64-linux-gnu.tar.gz

### REPOSITORIOS

## SISTEMA
function Repos() 
{
	add-apt-repository ppa:nemh/systemback
	add-apt-repository ppa:alexlarsson/Flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak remote-add --if-not-exists winepak https://dl.winepak.org/repo/winepak.flatpakrepo
	
	## Drivers gráficos
	add-apt-repository ppa:graphics-drivers/ppa
	add-apt-repository ppa:ubuntu-x-swat/updates
	
	add-apt-repository -y ppa:webupd8team/java
}

### MULTIMEDIA

## GRABACIÓN Y EDICIÓN DE VIDEO

#OBS
function f_obs() 
{
	add-apt-repository ppa:obsproject/obs-studio
	apt update
	apt install obs-studio
}
	

### PROGRAMACIÓN

# Apache Cordova
function Apache_Cordova() 
{
	apt-get install python-software-properties -y
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	sudo apt-get install nodejs -y
	npm install -g cordova
}


### SISTEMA
function f_sistema() 
{
	apt install debfoster
	apt install localpurge
	apt install smartmontools gsmartcontrol
}

## NAVEGADORES
function Brave() 
{
	wget -O brave.deb https://laptop-updates.brave.com/latest/dev/ubuntu64
	sudo dpkg -i brave.deb
	apt -f install
}

# Gestión de librerias de fotos
function Shotwell() 
{
	add-apt-repository ppa:yg-jensge/shotwell
	apt-get install shotwell
}

##  COPIAS DE SEGURIDAD
function f_backups() 
{
	apt-get install systemback
}

### JUEGOS

## STEAM
function Steam() 
{
	apt-get install steam
}
## WINEPAK


## GameMode
function GameMode() 
{
	apt-get install meson libsystemd-dev pkg-config ninja-build flatpak
	cd ~
	git clone https://github.com/FeralInteractive/gamemode.git
	cd gamemode
	git checkout 1.1
	./bootstrap.sh
	# cargar el servicio al sistema
	meson --prefix=/usr build -Dwith-systemd-user-unit-dir=/etc/systemd/user
	cd build
	ninja
	ninja install
	systemctl --user daemon-reload
	systemctl --user enable gamemoded
	systemctl --user start gamemoded
	systemctl --user status gamemoded
}

## TrackMania Nations Forever 
function TrackMania() 
{
	snap install tmnationsforever
}

function which_sistema() 
{
	local foo_options=("Sistema Esencial" "Copias de Seguridad" "Retroceder")
    	local PS3="Seleccione una opción: "

    	select foo in "${foo_options[@]}"
    	do
        case $REPLY in
            1) f_sistema
               break ;;

            2) f_backups
               break ;;

            3) break ;;
	    *) echo "invalid option";;
        esac
    done
}

function which_maqueta() 
{
	local foo_options=("Escritorio" "Copias de Seguridad" "Retroceder")
    	local PS3="Seleccione una opción: "

    	select foo in "${foo_options[@]}"
    	do
        case $REPLY in
            1) f_desktop
               break ;;

            2) f_backups
               break ;;

            3) break ;;
	    *) echo "invalid option";;
        esac
    done
}

ACTIONS=("Sistema" "Programación" "Juegos" "Maqueta" "Salir")
PS3="Seleccione una opción: "

select action in "${ACTIONS[@]}"
do
    case $action in
         "Sistema") which_sistema
                break ;;

         "bar") which_bar # Not present in this example
                break ;;

	 "Maqueta") which_maqueta
		break ;;

         "Salir") break ;;
	 *) echo "invalid option";;
    esac
done

END=$(date +%s)
DIFF=$(( $END - $START ))
DIFF=$(( $DIFF / 60 ))

echo -e "${txtgrn}Tiempo de ejecución:${DIFF}\nGracias por usar este script. Adios.${txtrst}"
