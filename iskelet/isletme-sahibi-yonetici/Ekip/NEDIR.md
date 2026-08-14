# Ekip — bu klasör nedir

Yönettiğin **her kişi, alt-ekip ya da proje için bir alt klasör.** Amaç: "şu an kimde ne var,
hangi durumda" sorusunun cevabı tek yerde ve tek bakışta olsun.

```
Ekip\
  <kisi-veya-proje-adi>\
    00-KUNYE.md        → rol/sorumluluk, durum (yeşil/sarı/kırmızı), son güncelleme
                          + açık delegasyonlar (kime · ne · ne zamana kadar · nerede)
```

## Kural
- `00-KUNYE.md` **her** yeni kişi/proje için ilk açılan dosyadır.
- Durum güncel tutmak **asistanın işidir**: konuşma sırasında yeni bilgi geçtikçe dosya
  **o an** güncellenir, sohbet sonuna bırakılmaz.
- Bir dosya uzun süredir güncellenmediyse (ör. üç haftadır dokunulmamış) asistan bunu
  **kendiliğinden** hatırlatır.
- Delegasyon süresi geçtiyse "gecikti" diye işaretlenir — kullanıcı sormadan önce.

## Yeni kayıt açmak
Asistana **"X için/kişisi için klasör aç"** demek yeterli — künyeyle birlikte kurar.
