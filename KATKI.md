# Katkı Kuralları

Bu depo **herkese açık olabilir.** Katkı vermeden önce tek bir şeyi bil:

---

## ⛔ Buraya asla girmeyecek olanlar

| Girmez | Neden |
|---|---|
| Parola, API anahtarı, token, bağlantı dizesi | Açık depo = herkes görür |
| Gerçek firma, kurum, müşteri adı | Ticari gizlilik |
| Gerçek kişi adı, kimlik/iletişim bilgisi, sağlık verisi | KVKK |
| Kurum içi doküman, rapor, teklif, sözleşme | Bunlar kişinin kendi kasasına ait |
| Bir kişinin kurulmuş kasasının içeriği | Kasa **özeldir**, depoya geri gönderilmez |
| Ekran görüntüsü içinde görünen gerçek veri | En sık gözden kaçan sızıntı yolu |

**Örnekler daima anonim olur:** `Ornek Metal A.S.`, `[KİŞİ-1]`, `ornek-kurum`.

Bir dosyayı eklemeden önce içinde ara: firma adı, kişi adı, `@` işareti, telefon deseni,
`sk-` / `ghp_` gibi anahtar önekleri.

---

## Ne katkı verilebilir

- **Yeni profil** (`profiller/<rol>/CLAUDE.md` + `iskelet/<rol>/` + `istemler/<rol>.md` +
  `sablonlar/<rol>/`) — dördü birlikte gelmeli, yarım profil kurulumu bozar.
- **Yeni şablon** — boş kalıp, doldurulmuş belge değil.
- **Yeni istem kartı** — "ne işe yarar" + kopyalanabilir istem metni biçiminde.
- **README düzeltmesi** — özellikle bir kurulumda tökezlenen bir adım varsa.
  Tökezleme `KURULUM-KONTROL.md`'ye not düşülür, sonra README'ye yansır.

---

## Yapı kuralları

1. **Ortak kural tek yerde durur.** Her profilde geçerli bir kural `profiller/_ortak.md`
   dosyasına yazılır; profil dosyalarına **kopyalanmaz.** Profil dosyası yalnız
   role özgü kuralı taşır ve çekirdeğe atıf yapar.
2. **README uygulanabilir kalmalı.** Her adım: ne yapılacak + **nasıl doğrulanacak.**
   "Gerekirse ayarlayın" gibi belirsiz cümle yazma — kurulum orada kırılır.
3. Her role özel iskelet **tam 2 klasör** ekler (ortak 5 + role özel 2 = 7).
   Doğrulama sorusu ("kaç klasör var" → 7) buna dayanır; değiştirirsen README'yi de değiştir.
4. Dosyalar **UTF-8**, dosya adlarında Türkçe karakter yok (ı→i, ş→s, ğ→g, ç→c, ö→o, ü→u).
5. Metin dili **Türkçe.**

---

## Değişiklik önerirken

Değişikliğin **hangi kurulum deneyiminden** çıktığını tek cümleyle yaz. Bu depo teoriden
değil, gerçek kurulumlardan büyür.
