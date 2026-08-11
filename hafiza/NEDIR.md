# hafiza/ — hafıza nerede durur, neden orada durur

Bu klasör **kasaya kopyalanmaz.** İçindeki `MEMORY.md`, kurulum sırasında kullanıcının
**Claude hafıza dizinine** yerleştirilir:

```
%USERPROFILE%\.claude\projects\<proje>\memory\
    MEMORY.md                 ← indeks (her sohbetin başında otomatik yüklenir)
    kullanici-profil.md       ← tanışma röportajı: rol, işin doğası, çalışma tercihi
    calisilan-kurumlar.md     ← kurum / firma / proje listesi
    ilk-oncelikler.md         ← yorucu bulduğu işler + ilk yardım isteyeceği iş
```

## Neden kasada değil

Claude Code hafızayı **kullanıcı dizininden** yükler. Kasanın içine yazılan bir `MEMORY.md`
dosyası hiçbir zaman otomatik okunmaz — dosya diskte durur ama sistem onu görmez.

📌 *11.08.2026'daki ilk canlı kurulumda tam bu oldu: dosyalar eksiksiz oluştu, doğrulama
listesi "yazıldı mı?" diye sorduğu için hepsi geçti, ama yeni sohbet kullanıcıyı tanımadı.
Ayrıntı: `KURULUM-KONTROL.md` → B-03.*

## ⚠️ Dizin adı (`<proje>`) tahmin edilmez

Claude Code proje dizininin adını çalışma klasörünün yolundan türetir, **ama bu türetme
kuralı dokümante değildir** ve Türkçe karakterlerde beklenmedik sonuç verir
(`…Isletim-Sistemi` gibi). Kurulum bu adı **hesaplamaz, ölçer** — README Adım 4'e bak.

## Not biçimi

```
---
ad: kisa-dosya-adi
aciklama: "Tek cümlede bu not neyi anlatıyor"
tip: tercih | kisi | kurum | yontem | ders
tarih: YYYY-AA-GG
---
```

Sonra 3–10 satır düz Türkçe. Uzun yazma — hatırlatıcı yeter.
Yazdıktan sonra `MEMORY.md`'ye tek satır bağlantı ekle.

## Kullanıcı hafızayı nasıl büyütür

> **"Beni şu konuda hatırla: …"** · **"Bunu not al: …"**

Yanlış öğrenilmişse:

> **"Bunu unut / şöyle düzelt: …"**

## ⚠️ Buraya yazılmayanlar

Kişisel/hassas veri (kimlik numarası, sağlık bilgisi, ücret, özel hayat) hafızaya **yazılmaz.**
"X kurumunda 40 çalışan var" olur; kişiye ait özel bilgi olmaz.

## İkinci katman — künye kurallara da yazılır

Hafıza dizini adı kasa taşınırsa değişir. Bu yüzden kurulum, kullanıcının **künyesini**
(rol · kurumlar · çalışma tercihi) ayrıca `%USERPROFILE%\.claude\CLAUDE.md` içindeki
**"Kullanıcı Künyesi"** bölümüne de yazar. O dosya her klasörde, her sohbette yüklenir —
hafıza dizini bulunamasa bile kullanıcı tanınır.
