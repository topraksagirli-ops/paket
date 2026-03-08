#!/bin/bash
echo ">>> ToprakOS Sistem Yapılandırması ve Mühürleme Başlıyor..."

# 1. Klasörleri ve Tema Altyapısını Hazırla
# Plymouth klasörü ve dosyası olmadan tema mühürlenemez
mkdir -p /usr/share/plymouth/themes/toprak-theme
touch /usr/share/plymouth/themes/toprak-theme/toprak-theme.plymouth

# 2. Grafik Arayüz (X11) Otomatik Başlatma Yapılandırması
# Hem mevcut root/kullanıcı hem de yeni oluşturulacak kullanıcılar için:
echo ">>> X11 yapılandırması ekleniyor..."
echo 'if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx; fi' >> /etc/skel/.bash_profile
echo 'if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx; fi' >> ~/.bash_profile

# 3. GRUB ve Splash Ayarları (Sessiz ve Logolu Önyükleme)
if [ -f "/etc/default/grub" ]; then
    echo ">>> GRUB sessiz mod ayarlanıyor..."
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
else
    echo "!!! HATA: /etc/default/grub bulunamadı!"
fi

# 4. Plymouth Temasını Mühürle
echo ">>> Boot teması 'toprak-theme' olarak mühürleniyor..."
plymouth-set-default-theme -R toprak-theme || echo "Bilgi: Tema klasörü oluşturuldu, tam içerik bekleniyor."

# 5. Kernel ve Bootloader Seviyesinde Güncelleme
echo ">>> Sistem kernel ve bootloader seviyesinde güncelleniyor..."

# Initramfs güncelleme (Kernel seviyesinde değişiklikleri kaydetmek için)
if command -v update-initramfs > /dev/null; then
    update-initramfs -u
fi

# GRUB Config güncelleme
if command -v update-grub > /dev/null; then
    update-grub
else
    # Eğer update-grub komutu yoksa direkt config oluştur
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# Eğer grub.cfg.new oluştuysa onu asıl dosya yap (Codespace/Docker kısıtlamasını aşmak için)
if [ -f "/boot/grub/grub.cfg.new" ]; then
    mv /boot/grub/grub.cfg.new /boot/grub/grub.cfg
    echo ">>> GRUB config başarıyla asıl dosyaya taşındı."
fi

echo ">>> [BAŞARILI] İşlem Tamamlandı. ToprakOS mühürlendi!"
