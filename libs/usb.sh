#!/bin/bash

# Função para listar os dispositivos USB no estilo "tree"
list_devices_tree() {
    local prefix="$1"
    shift
    for device in "$@"; do
        local red_device=$(echo -e "\e[91m$device\e[0m")
        echo -e "${prefix}└── $red_device"
    done
}

# Função para montar a unidade USB
mount_usb() {
  umount_usb_all

  # Cria o diretório de montagem se não existir
  [ -d "$USB_MOUNT" ] || mkdir -p "$USB_MOUNT"

  # Monta a unidade USB
  mount "$USB_PATH" "$USB_MOUNT"
}

# Desmonta qualquer unidade USB montada
umount_usb_all() {
  for usb_dev in /dev/disk/by-id/usb-*; do
    dev=$(readlink -f "$usb_dev")
    grep -q "^$dev" /proc/mounts && umount "$dev" >/dev/null 2>&1
  done
}

umount_usb() {
  # Monta a unidade USB
  umount "$USB_PATH" "$USB_MOUNT"

  # Cria o diretório de montagem se não existir
  [ -d "$USB_MOUNT" ] || rmdir "$USB_MOUNT"
}

# Lista os dispositivos USB conectados
list_usb_devices() {
  devices=($(lsblk -l -o NAME,TYPE,MOUNTPOINT | grep 'disk' | awk '{print $1}'))
  usb_devices=()
  for device in "${devices[@]}"; do
    if [[ -e "/sys/block/$device/removable" ]] && \
       [[ "$(cat "/sys/block/$device/removable")" -eq "1" ]]; then
      usb_devices+=("/dev/$device")
    fi
  done

  # Retorna a lista de dispositivos USB
  echo "${usb_devices[@]}"
}
