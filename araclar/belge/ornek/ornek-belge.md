---
baslik: "Belge Çıktı Hattı — Örnek Belge"
yazar: "Kişisel Zeka Kurulumu"
tarih: "2026"
---

# Belge Çıktı Hattı — Örnek Belge

Bu dosya bir **deneme belgesidir.** Amacı tek şey: kurduğun belge hattının gerçekten
çalıştığını, üstelik Türkçe karakterleri bozmadan çalıştığını kanıtlamak. Doğrulama betiği
(`belge-hatti-kontrol.ps1`) bu dosyayı PDF'e çevirir ve içindeki denetim satırını arar.

## Türkçe karakter denetimi

Aşağıdaki satır bozulmadan görünmelidir:

> DENETIM: ığüşöçİĞÜŞÖÇ — Pijamalı hasta yağız şoföre çabucak güvendi.

Sık karşılaşılan üç tuzak: büyük **İ** ile küçük **ı** ayrımı, yumuşak **ğ** harfinin
tireli hâli, ve *şapkalı* harfler (â, î, û). Hepsi bu paragrafta geçiyor.

## Biçimlendirme denetimi

Bir belge hattı yalnız harfleri değil, yapıyı da taşımalıdır:

1. Numaralı liste
2. İkinci madde
3. Üçüncü madde

- İşaretli liste
- `satır içi kod` ve **kalın** ile *italik*
- Bağlantı: [örnek adres](https://example.org)

### Tablo

| Katman | Araç | Ne verir |
|---|---|---|
| 0 | Tarayıcı (Edge) | Markdown → PDF |
| 1 | Pandoc | Word (.docx), LaTeX (.tex) |
| 2 | Tectonic | .tex → PDF |

### Kod bloğu

```
ozet = "Bu blok olduğu gibi korunmalıdır: ışıklı ağaç, şöyle böyle."
```

## Kaynakça

Kaynakça bölümü asılı girintiyle biçimlenir (ikinci satır içeri kayar):

- Yılmaz, A. (2024). *Belge üretim hatlarında biçim tutarlılığı.* Örnek Yayınevi. Bu künye
  bilerek uzun tutulmuştur ki ikinci satırın girintisi PDF'te gözle görülebilsin.
- Öztürk, B., & Şahin, C. (2023). Çok yazarlı bir çalışma başlığı. *Örnek Dergi, 12*(3), 45-67.
