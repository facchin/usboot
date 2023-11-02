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
source libs/usb.sh

DEVICE="/dev/${USB_PREFIX}"
DATA_PARTITION="${DEVICE}1"
USB_MOUNT="/mnt/usboot"
ISO_DIRECTORY="./isos"

print_banner banner_usboot

print_msg "Desmontar partição, se montada"
umount_usb_all

print_msg "Executando gdisk com a opção 'r' automaticamente..."
print_msg "r\nq\n" | sudo gdisk "${DEVICE}" >/dev/null 2>&1

print_msg "Formatando dispositivo ..."

sfdisk --no-reread -Y dos "${DEVICE}" <<EOF
label: dos
sector-size: 512
1 : start=2048, size=30000000, type=ef, bootable
EOF
mkfs.vfat -n USBOOT "${DATA_PARTITION}"

# Montar a partição de dados
mount "${DATA_PARTITION}" "${USB_MOUNT}"

print_msg "Instalando o GRUB no dispositivo USB"
mkdir -p "${USB_MOUNT}/boot"
mkdir -p "${USB_MOUNT}/efi"
grub-install \
  --target=x86_64-efi --removable --no-nvram \
  --root-directory="${USB_MOUNT}" \
  --boot-directory="${USB_MOUNT}/boot" \
  --efi-directory="${USB_MOUNT}/efi"

grub-install --target=i386-pc \
  --root-directory="${USB_MOUNT}" \
  --boot-directory="${USB_MOUNT}/boot" \
  "${DEVICE}"

print_msg "Atualizando grub.cfg"
cp grub_boot.cfg "$USB_MOUNT/boot/grub/grub.cfg"

echo "Inicializando pasta de isos..."
mkdir -p "$USB_MOUNT/isos"

echo "Copiando todas as ISOs de ${ISO_DIRECTORY} para a pasta de isos..."
for ISO_FILE in "${ISO_DIRECTORY}"/*.iso; do
  echo $ISO_FILE
  if [ -f "$ISO_FILE" ]; then
    ISO_NAME=$(basename "$ISO_FILE")
    pv "$ISO_FILE" > "$USB_MOUNT/isos/$ISO_NAME"
    echo "ISO '$ISO_NAME' movida para '$USB_MOUNT/isos/'"
  fi
done
