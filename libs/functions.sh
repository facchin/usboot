#!/bin/bash

# Atualiza o arquivo grub.cfg
update_grub() {
  rm -f "$USB_MOUNT/boot/grub/grub.cfg"
  cp grub_boot.cfg "$USB_MOUNT/boot/grub/grub.cfg"

  print_msg "Grub.cfg atualizado."
}
