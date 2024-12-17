#!/bin/bash

# Verifica se o svxlink está instalado
if ! dpkg -l | grep -q svxlink; then
  echo "Adicionando depedencias..."
  sudo add-apt-repository ppa:felix.lechner/hamradio

  echo "Atualizando lista de pacotes..."
  sudo apt update
  sudo apt-get install -y svxlink-server

else
  echo "svxlink já está instalado."
fi

current_dir=$(pwd)

if ! dpkg -l | grep -q svxlink; then
  echo "svxlink não está instalado."
else
    echo "copiando audios."
    cp -r $current_dir/pt_BR /usr/share/svxlink/sounds/pt_BR
    cp $current_dir/Logic.tcl /usr/share/svxlink/events.d/Logic.tcl

    echo "Digite seu indicativo:"
    read callsign

    callsign_upper=$(echo "$callsign" | tr '[:lower:]' '[:upper:]')
    
    sudo sed -i "s/^CALLSIGN=.*/CALLSIGN=$callsign_upper/" $current_dir/svxlink.conf

    sudo sed -i "s/^CALLSIGN=.*/CALLSIGN=$callsign_upper-L/" $current_dir/ModuleEchoLink.conf

    echo "Digite a senha do echolink:"
    read password

    sudo sed -i "s/^PASSWORD=.*/PASSWORD=$password/" $current_dir/ModuleEchoLink.conf

    echo "copiando Configuraçoes."
    cp $current_dir/svxlink.conf /etc/svxlink/
    cp $current_dir/ModuleEchoLink.conf /etc/svxlink/svxlink.d/

    echo "Reiniciando svxlink..."
    sudo systemctl restart svxlink
fi