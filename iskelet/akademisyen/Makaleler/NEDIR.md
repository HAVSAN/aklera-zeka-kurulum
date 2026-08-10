# Makaleler — bu klasör nedir

Yürütülen **her çalışma için bir alt klasör** açılır. O çalışmaya ait ne varsa orada durur.

```
Makaleler\
  <calisma-kisa-adi>\
    00-KUNYE.md          → hedef dergi, ortak yazarlar, son tarihler, durum
    taslak.md            → çalışan metin
    taslak.tex           → LaTeX gövdesi (gerekiyorsa)
    sekiller\            → şekil ve tablolar
    veri-notlari\        → analiz notları (ham veri burada tutulmaz)
    hakem-yanitlari\     → hakem raporları ve yanıt taslakları
```

## Kural
- Metnin **çalışan tek bir kopyası** olur. Sürümleme için dosya çoğaltma yerine tarih notu
  düşülür; kesin sürüm gerektiğinde `-v2` eki kullanılır.
- `00-KUNYE.md` her çalışmada **ilk açılan** dosyadır — son tarih ve durum oradan izlenir.
- Ortak yazarlara gidecek hâl `Belgeler\` altına **tarihli** kopyalanır.

## ⚠️ Etik ve gizlilik
İnsan katılımcı verisi, izin belgeleri ve kişiye ait ham veri **bu klasörde tutulmaz** ya da
tutuluyorsa dışarı çıkarılmaz. Asistan web araması yaparken katılımcı bilgisini kullanmaz.
