#!/bin/bash

# Variáveis de cores
RED="\033[1;31m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;93m"
NORMAL="\033[0;0m"
BOLD="\033[;1m"

function print_msg {
  # Aplica substituições de cores em um único comando awk
  echo -e "{R}$1{N}" |  \
      awk '{ gsub(/{R}/, "'$RED'"); print }'      |\
      awk '{ gsub(/{N}/, "'$NORMAL'"); print }'
}

# Banner USBOOT
banner_usboot="
{Y}________________________________________\n
{Y}___/ / / / ___// __ )/ __ \/ __ \/_  __/\n
{Y}__/ / / /\__ \/ ___ / / / / / / / / /   \n
{Y}_/ /_/ /___/ / /_/ / /_/ / /_/ / / /    \n
{Y}_\____//____/_____/\____/\____/ /_/     {G}1.0   {N}\n
{R}_____________________b y ___p a t r i c k____f a c c h i n{N}\n"

# Banner VBOX
banner_vbox=$(cat << "EOF"
>>=======================================================<<
||     __     ___      _               _ ____            ||
||     \ \   / (_)_ __| |_ _   _  __ _| | __ )  _____  __||
||      \ \ / /| | '__| __| | | |/ _` | |  _ \ / _ \ \/ /||
||       \ V / | | |  | |_| |_| | (_| | | |_) | (_) >  < ||
||TEST:   \_/  |_|_|   \__|\__,_|\__,_|_|____/ \___/_/\_\||
>>=======================================================<<
EOF
)

# Banner QEMU
banner_qemu=$(cat << "EOF"
>>=====================================<<
||       ___    _____   __  __   _   _ ||
||      / _ \  | ____| |  \/  | | | | |||
||     | | | | |  _|   | |\/| | | | | |||
||     | |_| | | |___  | |  | | | |_| |||
||TEST: \__\_\ |_____| |_|  |_|  \___/ ||
>>=====================================<<
EOF
)

function print_banner {
  # Inicia limpando a tela
  clear

  # Obtém o valor da variável passada como argumento
  local text="${!1}"

  # Aplica substituições de cores em um único comando awk
  echo -e "$text" |  \
      awk '{ gsub(/{R}/, "'$RED'"); print }'      |\
      awk '{ gsub(/{B}/, "'$BLUE'"); print }'     |\
      awk '{ gsub(/{C}/, "'$CYAN'"); print }'     |\
      awk '{ gsub(/{G}/, "'$GREEN'"); print }'    |\
      awk '{ gsub(/{Y}/, "'$YELLOW'"); print }'   |\
      awk '{ gsub(/{N}/, "'$NORMAL'"); print }'   |\
      awk '{ gsub(/{B}/, "'$BOLD'"); print }'
}








