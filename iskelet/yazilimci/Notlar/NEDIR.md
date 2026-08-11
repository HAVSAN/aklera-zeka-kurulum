# Notlar — bu klasör nedir

**Karar notları ve teknik araştırma sonuçları.** Üç ay sonra "neden böyle yapmıştık"
sorusunun cevabı buradan çıkar.

## Karar notu biçimi

```
---
ad: kisa-karar-adi
tarih: YYYY-AA-GG
durum: gecerli | degisti | iptal
---

## Bağlam
Neyi çözmeye çalışıyorduk.

## Seçilen yol
Ne yaptık.

## Elenen alternatifler
Neyi neden seçmedik.

## Sonuç / geri dönüş şartı
Bu karar hangi durumda yeniden açılır.
```

## Kural
- Bir karar **değiştiğinde eski not silinmez**, `durum: degisti` yapılır ve yeni nota bağlanır.
- Tuzağa düşüp çıktıysan notu buraya değil **asistanın hafızasına** ders olarak yazdır
  ("bunu ders olarak not al") — hafızayı her sohbette okur.

## Dosya adı biçimi
`YYYY-AA-GG-karar-kisa-ad.md`
