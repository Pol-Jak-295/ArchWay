#! /bin/bash

kexec -l /boot/vmlinuz-linux --initrd=/boot/amd-ucode.img,/boot/initramfs-linux.img --reuse-cmdline
systemctl kexec