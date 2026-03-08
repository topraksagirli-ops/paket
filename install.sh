#!/bin/bash
echo ">>> ToprakOS Sistem Yapılandırması Başlıyor..."

# X11 Otomatik Başlatma
echo 'if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx; fi' >> ~/.bash_profile

# GRUB ve Splash Ayarları
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub

# Tema ve Kernel Güncelleme
# Not: Chroot içinde plymouth veya update-grub yoksa hata vermemesi için kontrol ekleyebilirsin
plymouth-set-default-theme -R toprak-theme 2>/dev/null || echo "Plymouth teması ayarlanamadı (Paket eksik olabilir)."
update-grub 2>/dev/null || echo "GRUB güncellenemedi."
update-initramfs -u 2>/dev/null

echo ">>> İşlem Tamamlandı. Sistem mühürlendi!"
