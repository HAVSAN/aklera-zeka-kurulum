# ayarlar/ — oto mod ve izinler

`settings-sablon.json`, kurulum sırasında **`%USERPROFILE%\.claude\settings.json`** konumuna
yerleştirilir. Amacı: kullanıcıya gün boyu izin sorusu sordurmamak, ama **geri alınamaz**
işlemlerde daima sordurmak.

Hedef profil **belge üreten kullanıcıdır**, kod yazan değil.

## Yazılımcı profili — ek katman

`settings-yazilimci-ek.json` **yalnız yazılımcı profilinde** kurulur ve `settings-sablon.json`'un
**üzerine birleştirilir** (onu değiştirmez; belge profilleri bu dosyayı hiç görmez).

| Ne ekler | Neden |
|---|---|
| `allow`: `dotnet test/build/run`, `npm`, `node`, `npx`, dal işlemleri, `git push`, `gh pr`, `curl` | Geliştirici gün boyu bunları koşar; her birinde izin sorusu çıkarsa oto mod anlamsızlaşır. **`git push` bilinçli olarak açıktır** — ana dala push'u engelleyen şey izin listesi değil, deponun `pre-push` kapısıdır (testler kırmızıysa push reddedilir). |
| `allow`: `* yayinla.ps1 *`, `* kapi-kur.ps1 *` | Yayın ve kapı kurulumu betikle yapılır. |
| `deny`: `ssh`, `scp`, `docker`, `docker-compose`, `psql`, `pg_dump`, `pg_restore`, `kubectl`, `Enter-PSSession` | **Canlı sisteme elle dokunmayı kapatır.** Bu araçlara ihtiyaç duyan iş yayındır ve yayın `yayinla.ps1` ile yapılır; betiğin kendi içinden çağırdığı komutlar bu listeden etkilenmez. Elle `docker` çalıştırmak, sürümü kimsenin bilmediği bir canlı sistem üretir. |
| `deny`: `git rebase`, `branch -D`, `tag -d`, `remote set-url`, `push --force/--delete` | Geçmişi ya da uzak depoyu geri alınamaz biçimde değiştirir. Yanlış commit `git revert` ile düzeltilir. |

⚠️ **Bu deny listesi kaldırılarak "iş görünür kılınmaz".** Kapıya takılmak, yapılmak isteneni
yanlış yolla yapmaya çalıştığının işaretidir.

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
