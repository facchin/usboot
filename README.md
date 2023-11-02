----------------------------------------------------
### Formatar pendrive e instalar grub
``` sh
$ git clone https://github.com/facchin/usboot.git facchin/usboot
$ cd facchin/usboot
$ sudo chmod +x usboot.sh
$ sudo ./usboot.sh
```

----------------------------------------------------
### Testar boot do pendrive

Teste com VirtualBox:
``` sh
$ sudo chmod +x test_vbox.sh
$ sudo ./test_vbox.sh
```

Teste com QEMU:
``` sh
$ sudo chmod +x test_qemu.sh
$ sudo ./test_qemu.sh
```
