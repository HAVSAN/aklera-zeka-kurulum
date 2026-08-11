# Firmalar — bu klasör nedir

Çalışılan **her firma için bir alt klasör** açılır. O firmaya ait ne varsa orada durur:
saha ziyaret notları, personel/birim bilgisi, geçmiş raporlar, yazışmalar, ölçüm sonuçları.

```
Firmalar\
  <Firma-Adi>\
    00-FIRMA-KUNYE.md      → firma kimliği, NACE kodu, tehlike sınıfı, iletişim
    Saha-Notlari\          → ziyaret tarihli gözlem notları
    Raporlar\              → o firmaya kesilen raporların kopyası
    Olcumler\              → ortam ölçümü, gürültü, toz, aydınlatma sonuçları
```

## ⚠️ Gizlilik
Kişisel veri (ad-soyad, TC, sağlık raporu, muayene sonucu, telefon, adres) **yalnız bu klasörde**
durur. `Belgeler\` gibi paylaşıma açık olabilecek yerlere kopyalanmaz.
Asistan web araması yaparken bu klasördeki gerçek kişi bilgisini **dışarı çıkarmaz** —
`[ÇALIŞAN-1]` gibi maskeleyerek çalışır.

## Yeni firma açmak
Asistana şunu demek yeterli: **"X firması için klasör aç"** — künye dosyasıyla birlikte kurar
ve hafızasına firmayı tanıtan bir not düşer.
