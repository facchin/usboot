#!/bin/bash

# Função para remover a VM
remove_vm() {
  # Verifica se a VM está em execução
  if VBoxManage list runningvms | grep -q "${VM_NAME}"; then
    print_msg "A VM está rodando. Parando a VM..."
    VBoxManage controlvm "${VM_NAME}" poweroff
  fi

  # Remove a VM e o disco VDI associado
  if VBoxManage list vms | grep -q "${VM_NAME}"; then
    print_msg "Removendo VM e disco associado"
    VBoxManage unregistervm "${VM_NAME}" --delete
    VBoxManage closemedium disk "./${VM_NAME}.vdi" --delete
  fi
}

# Retorna o status da VM
get_vm_status() {
  vm_name="$1"
  # Coleta o resultado do comanado
  vm_info=$(VBoxManage showvminfo "$vm_name" --machinereadable)

  # Verifica o código de saída do comando
  if [ $? -ne 0 ]; then
    # O comando falhou, retornar "error"
    echo "error"
  else
    # O comando teve êxito, obtém o status da VM
    vm_state=$(echo "$vm_info" | grep "VMState=" | cut -d'=' -f2 | tr -d '"')
    echo "$vm_state"
  fi
}

# Função para criar e configurar a VM
create_vm() {
  # Remove a VM e o disco VDI associado, se existirem
  remove_vm

  # Cria o disco VMDK
  print_msg "VBOX: criando vmdk ..."
  VBoxManage internalcommands createrawvmdk -filename "${VM_NAME}.vmdk" -rawdisk "/dev/${USB_PREFIX}"

  # Cria o disco VDI
  print_msg "VBOX: criando vdi ..."
  VBoxManage createhd --filename "./${VM_NAME}.vdi" --size 512

  # Cria a VM
  print_msg "VBOX: criando VM ..."
  VBoxManage createvm --name "${VM_NAME}" --ostype 'Linux_64' --register --basefolder "${PWD}"

  # Cria o controlador IDE
  print_msg "VBOX: criando IDE controller ..."
  VBoxManage storagectl "${VM_NAME}" --name 'IDE Controller' --add ide

  # Vincula o disco VMDK ao controlador IDE
  print_msg "VBOX: vinculando vmdk a IDE controller..."
  VBoxManage storageattach "${VM_NAME}" --storagectl 'IDE Controller' --port 0 --device 0 --type hdd --medium "./${VM_NAME}.vmdk"

  # Configurações da VM
  print_msg "VBOX: modificando valores da VM ..."
  VBoxManage modifyvm "${VM_NAME}" --boot1 disk --boot2 none --boot3 none --boot4 none
  VBoxManage modifyvm "${VM_NAME}" --memory 2048 --vram 128
  VBoxManage modifyvm "${VM_NAME}" --bioslogodisplaytime 1
}

# Função para verificar a VM e, se não estiver ativa, removê-la
check_and_remove_vm() {
  local vm_state
  while true; do
    # Verifica o estado da VM
    vm_state=$(get_vm_status "${VM_NAME}")
    if [ "$vm_state" != 'running' ]; then
      sleep 2
      remove_vm
      break
    fi
    sleep 1  # Aguarda 1 segundo antes de verificar novamente
  done
}
