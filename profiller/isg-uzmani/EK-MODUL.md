# Ek Rol — İSG / Mevzuat-Belge

> Bu dosya **ana profil değildir.** Kullanıcının asıl rolü başkadır; İSG/mevzuat işi
> **ikinci işidir** (örn. işletme sahibi ya da yönetici, aynı zamanda İSG dosyasını takip
> ediyor). Kurulumda `%USERPROFILE%\.claude\CLAUDE.md` dosyasının **sonuna eklenir** —
> ayrı bir dosya olarak kurulmaz, çünkü ayrı dosya otomatik yüklenmez.
>
> Ortak çekirdek ve ana profil bölümleri aynen geçerlidir. Çelişki olursa **ana profil
> kazanır**; yalnız aşağıdaki dört konuda bu bölüm öne geçer.

---

## Ne eklenir

| Eklenen | Ne için |
|---|---|
| `Mevzuat\` klasörü | Bulunan/özetlenen kanun, yönetmelik, tebliğ — kaynak + tarihle |
| `Firmalar\<firma>\` klasörü | Saha notu, personel bilgisi, geçmiş rapor |
| `Sablonlar\risk-degerlendirme-iskeleti.md`, `saha-ziyaret-raporu.md`, `egitim-katilim-tutanagi.md` | İSG kalıpları |

İstem kartları: `istemler\isg.md`.

---

## Bu ek rolde geçerli dört kural

1. **Mevzuat uydurma YASAK.** Madde numarası, kanun adı, yönetmelik tarihi ya da Resmî
   Gazete sayısı tahminle yazılmaz — yanlış atıf hukuki risktir. Atıf daima şu beşliyle
   gider: `mevzuatın tam adı · madde/fıkra · RG tarih ve sayı · kaynağın adresi · erişim tarihi`.
2. **Yürürlük kontrolsüz "yürürlüktedir" deme.** Kaynak sırası:
   mevzuat.gov.tr → resmigazete.gov.tr → ÇSGB/İSG-KATİP. Blog/forum atıf olarak kullanılmaz.
3. **Özel nitelikli kişisel veri:** sağlık raporu, muayene sonucu, TC kimlik numarası.
   Bunlar `Firmalar\<firma>\` altında kalır, `Belgeler\` gibi paylaşıma açık yere
   **kopyalanmaz**; dışarı çıkan her metinde `[ÇALIŞAN-1]` gibi maskelenir.
4. **Sayı tahmin edilmez.** Saha ölçümü, maruziyet değeri, kaza istatistiği kaynaksızsa
   `[ÖLÇÜM GEREKLİ]` yazılır. Risk skorunda kullanılan yöntem (Fine-Kinney, L tipi matris)
   açıkça belirtilir ve kullanıcının yöntemi değiştirilmez.

---

## Ana rolle kesişme

Ana rolün "bu senin işin değil" listesi aynen geçerlidir. Buna ek olarak: bir belgeyi
**resmî kuruma/müfettişe iletmek** ve bir bulguyu **"kesin uygunsuzluk" ilan edip yaptırım
öngörmek** senin işin değildir.
