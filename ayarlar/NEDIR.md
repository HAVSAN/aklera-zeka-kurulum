# ayarlar/ — oto mod ve izinler

`settings-sablon.json`, kurulum sırasında **`%USERPROFILE%\.claude\settings.json`** konumuna
yerleştirilir. Amacı: kullanıcıya gün boyu izin sorusu sordurmamak, ama **geri alınamaz**
işlemlerde daima sordurmak.

Hedef profil **belge üreten kullanıcıdır**, kod yazan değil.

## Üç parça

| Anahtar | Ne yapar |
|---|---|
| `permissions.defaultMode: "acceptEdits"` | Dosya düzenlemelerini kalıcı olarak otomatik kabul eder. Her `.md` yazımında soru çıkmaz. |
| `permissions.allow` | Belirtilen komutları sormadan çalıştırır (okuma, kopyalama, belge dönüştürme, güvenli git). |
| `permissions.deny` | Bu komutlar **hiçbir koşulda** çalışmaz. Silme, biçimlendirme, sistem ayarı, geri alınamaz git, kimlik/parola dosyası okuma. |

## Öncelik sırası — bilinmesi şart

Kurallar **deny → ask → allow** sırasıyla değerlendirilir. İlk eşleşen kazanır.
Yani `deny` listesindeki bir komut, `allow`'da da yazsa ve `defaultMode: acceptEdits` olsa
bile **çalışmaz.** Bu kasıtlıdır: oto mod silmeyi kapsamaz.

## Windows notu — neden hem `Bash(...)` hem `PowerShell(...)`

Komutun hangi kabuk adı altında değerlendirileceği ortama göre değişebilir (Git Bash kurulu
mu, editör hangi kabuğu açıyor). İki karşılık da yazılır: **fazlası zararsız, eksiği sessiz
izin sorusu doğurur** ve kullanıcı "yine soruyor" der.

## Var olan ayar dosyası varsa

⛔ **Ezme.** Kurulum önce mevcut `settings.json`'u okur, anahtarları **birleştirir**
(mevcut `allow`/`deny` girdileri korunur, buradakiler eklenir), sonucun geçerli JSON
olduğunu doğrular. Doğrulama: `araclar\kurulum-dogrula.ps1`.

## Kullanıcı "yine izin soruyor" derse

Sorulan komutu **birebir** öğren, `allow` listesine karşılığını ekle, dosyayı kaydet,
**yeni bir sohbet** aç (ayar dosyası oturum başında okunur). Silme/biçimlendirme sorusu
çıkıyorsa bu **doğru davranıştır** — `deny` kaldırılmaz.
