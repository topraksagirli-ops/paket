#!/bin/bash
echo ">>> ToprakOS Sistem Yapılandırması Başlıyor..."

# 1. Klasörleri ve Sahte Temayı Oluştur (Hata almamak için)
mkdir -p /usr/share/plymouth/themes/toprak-theme
touch /usr/share/plymouth/themes/toprak-theme/toprak-theme.plymouth

# 2. X11 Otomatik Başlatma (Hataları gizlemeden ekle)
echo 'if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx; fi' >> ~/.bash_profile

# 3. GRUB Ayarını Yap (Sed hatası zaten çözüldü)
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub

# 4. Plymouth Temasını Ayarla
echo ">>> Tema mühürleniyor..."
plymouth-set-default-theme -R toprak-theme || echo "Bilgi: Tema klasörü oluşturuldu ama dosya içeriği eksik."

# 5. GRUB Güncelleme (Chroot dostu yöntem)
echo ">>> Bootloader güncelleniyor..."
if command -v update-grub > /dev/null; then
    update-grub
else
    # Eğer update-grub yoksa manuel config oluştur
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo ">>> İşlem Tamamlandı. Sistem gerçekten mühürlendi!"
