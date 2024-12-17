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

if ! dpkg -l | grep -q svxlink; then
  echo "svxlink não está instalado."
else
    echo "copiando audios."
    cp -r pt_BR /usr/share/svxlink/sounds/pt_BR
    cp Logic.tcl /usr/share/svxlink/events.d/Logic.tcl

    echo "Digite seu indicativo:"
    read callsign

    callsign_upper=$(echo "$callsign" | tr '[:lower:]' '[:upper:]')
    
    sudo sed -i "s/^CALLSIGN=.*/CALLSIGN=$callsign_upper/" svxlink.conf

    sudo sed -i "s/^CALLSIGN=.*/CALLSIGN=$callsign_upper-L/" ModuleEcholink.conf

    echo "Digite a senha do echolink:"
    read password

    sudo sed -i "s/^PASSWORD=.*/PASSWORD=$password/" ModuleEcholink.conf

    echo "copiando Configuraçoes."
    cp svxlink.conf /etc/svxlink/svxlink.conf
    cp ModuleEchoLink.conf /etc/svxlink/svxlink.d/ModuleEchoLink.conf

    echo "Reiniciando svxlink..."
    sudo systemctl restart svxlink
fi