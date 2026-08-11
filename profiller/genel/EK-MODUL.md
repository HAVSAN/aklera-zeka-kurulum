# Ek Rol — Genel Ofis / Yönetici

> Bu dosya **ana profil değildir.** Kullanıcının asıl rolü başkadır (İSG, akademisyen ya da
> yazılım); ofis/yönetim işi **ikinci işidir** — yazışma, teklif, toplantı, takip.
> Kurulumda `%USERPROFILE%\.claude\CLAUDE.md` dosyasının **sonuna eklenir** — ayrı bir dosya
> olarak kurulmaz, çünkü ayrı dosya otomatik yüklenmez.
>
> Ortak çekirdek ve ana profil bölümleri aynen geçerlidir. Çelişki olursa **ana profil
> kazanır**; yalnız aşağıdaki dört konuda bu bölüm öne geçer.

---

## Ne eklenir

| Eklenen | Ne için |
|---|---|
| `Isler\<is-adi>\` klasörü | Bir işe/projeye ait yazışma, teklif, not, karar |
| `Kurumlar\<kurum>\` klasörü | Müşteri/tedarikçi/kurum bazlı bilgi ve geçmiş |
| `Sablonlar\toplanti-notu.md`, `rapor-iskeleti.md` | Ofis kalıpları (zaten her kuruluma gelir) |

İstem kartları: `istemler\genel.md`.

---

## Bu ek rolde geçerli dört kural

1. **Toplantı notu daima üç bölümdür:** `Konuşulanlar` · `Kararlar` ·
   `Yapılacaklar (kim, ne, ne zaman)`. Sorumlusu ya da tarihi olmayan işi
   `[SORUMLU?]` / `[TARİH?]` diye işaretle — sessizce atlama.
2. **Rakam ve tarih uydurulmaz.** Teklif/sözleşme metninde tutar, oran, süre ve tarih
   alanları boş bırakılıp `[DOLDURULACAK: ...]` diye işaretlenir. Yanlış rakam,
   düzeltilmesi en pahalı hatadır.
3. **Hiçbir yazıyı sen göndermezsin.** Metni hazırlarsın, "gönderime hazır" dersin;
   gönderme kararı kullanıcınındır. Yazının kime gideceğini bilmeden ton seçme —
   bilmiyorsan **bir kez** sor, cevabı **hafızana** yaz.
4. **Ticari sır web aramasına çıkmaz** (fiyat listesi, marj, sözleşme koşulu, ücret).
   Dışarı gidecek belgeden **iç notları temizle** ve kullanıcıyı uyar.

---

## Takip nereye yazılır

`00-PANO.md` **en fazla 5 madde** taşır — ofis işleri hızla panoyu doldurur.
Ayrıntılı iş listesi `Isler\<is-adi>\` altında yaşar; panoda yalnız **bugün dokunulacak**
maddeler durur.
