# Bu klasör ne

Burası **kişisel bilgi kasan.** Bilgisayardaki tüm iş bilgisi burada toplanır, yedeklenir ve
asistan (Claude) yalnız burayı okuyup buraya yazar.

> ℹ️ Kurulum sırasında asistan bu dosyayı **senin profiline göre** günceller: aşağıdaki
> tabloya role özel klasörleri ekler. Tablo eksikse asistana
> "klasör haritasını güncelle" demen yeterli.

## Klasör haritası

| Klasör / dosya | Ne işe yarar |
|---|---|
| `00-PANO.md` | Bugün ne var — en fazla 5 madde. Sohbete başlarken buraya bakılır. |
| `MEMORY.md` | Asistanın hafıza indeksi. Senin hakkında öğrendiği her şeyin listesi. |
| `memory\` | Hafıza notlarının kendisi (tercih, kişi, kurum, yöntem, ders). |
| `Belgeler\` | Bitmiş çıktılar: rapor, resmi yazı, sunum, materyal. |
| `Sablonlar\` | Tekrar kullanılan boş kalıplar. Doldurulmuş belge buraya konmaz. |
| `Arastirma\` | Devam eden işin ham notları. Emin olunmayan her şey önce buraya. |
| `Gunluk\` | Tarih adıyla günlük notlar, Obsidian bağlantılarıyla. |
| `CLAUDE.md` | Asistanın çalışma kuralları (rolüne özel). Her sohbette otomatik okunur. |
| `CEKIRDEK.md` | Asistanın ortak çalışma kuralları — her profilde aynı. |
| `ILK-GUN.md` | Kullanım kılavuzun — tek sayfa, örnek istemler. |
| `SINIRLAR.md` | Asistan neyi yapmaz, gizlilik kuralları, ne zaman durup sorar. |
| _(role özel klasörler)_ | _(kurulumda asistan buraya ekleyecek)_ |

Her klasörün içinde bir `NEDIR.md` var — o klasörün kuralını anlatır.

## Neden bu yapı (ve neden daha fazlası değil)

Yedi-sekiz klasörden fazlası akılda kalmaz. Ayrım şu mantığa dayanıyor:

- **Ham → işlenmiş → bitmiş** akışı: `Arastirma\` → konu klasörleri → `Belgeler\`
- **Kalıp ile içerik ayrı:** `Sablonlar\` boş kalıp, geri kalanı içerik
- **Gizlilik sınırı tek yerde:** hassas veri yalnız role özel konu klasöründe durur —
  bir belgeyi paylaşırken tek soru kalır: "bu oradan mı geliyor?"
- **Zaman ekseni ayrı:** `Gunluk\` konudan bağımsız, kronolojik iz
- **Hafıza ayrı:** `memory\` asistanın işi, senin her gün açman gerekmez

Klasör eklemek gerekirse asistana söylemek yeterli.
