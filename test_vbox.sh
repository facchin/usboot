#!/bin/bash

# Verifique se o arquivo .env existe
if [ -f .env ]; then
  source .env
else
  echo "O arquivo .env não foi encontrado."
  exit 1
fi

# Importa funções de suporte
source libs/printings.sh
source libs/functions.sh
source libs/usb.sh
source libs/vbox.sh

# Configurações
USB_PATH="/dev/${USB_PREFIX}1"

print_banner banner_vbox

# Verifica se o script é executado como root
if [ "$(id -u)" != "0" ]; then
    print_msg "OPS! VOCÊ TEM QUE EXECUTAR O SCRIPT COMO ROOT" 1>&2
    exit 1
fi

# Pergunta ao usuário se deseja testar o USBOOT
read -p "Deseja testar o USBOOT? (y/n): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit
fi

main() {
  # Atualiza o "grub.cfg"
  mount_usb && update_grub && umount_usb_all

  # Criar VM
  create_vm

  # Desativa mensagens indesejadas (default: showRuntimeError.warning.HostAudioNotResponding,confirmInputCapture )
  VBoxManage setextradata global "GUI/SuppressMessages" all
  # Força o desligamento da VM sem enviar o evento de desligamento ACPI ao fechar a janela
  VBoxManage setextradata "${VM_NAME}" "GUI/DefaultCloseAction" Poweroff

  # Inicia a VM
  print_msg "VBOX: ligando VM ..."
  VBoxManage startvm "${VM_NAME}"

  # Verifica a VM e a remove se estiver inativa
  check_and_remove_vm
}

main


