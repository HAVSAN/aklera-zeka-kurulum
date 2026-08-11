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
| `Belgeler\` | Bitmiş çıktılar: rapor, resmi yazı, sunum, materyal. |
| `Sablonlar\` | Tekrar kullanılan boş kalıplar. Doldurulmuş belge buraya konmaz. |
| `Arastirma\` | Devam eden işin ham notları. Emin olunmayan her şey önce buraya. |
| `Gunluk\` | Tarih adıyla günlük notlar, Obsidian bağlantılarıyla. |
| `CLAUDE.md` | Bu klasörün köprü dosyası — burası ne, ne nereye yazılır. Kural dosyası **değil**. |
| `ILK-GUN.md` | Kullanım kılavuzun — tek sayfa, örnek istemler. |
| `SINIRLAR.md` | Asistan neyi yapmaz, gizlilik kuralları, ne zaman durup sorar. |
| _(role özel klasörler)_ | _(kurulumda asistan buraya ekleyecek)_ |

## Burada olmayan iki şey — ve nerede oldukları

| Ne | Nerede | Neden burada değil |
|---|---|---|
| Asistanın **çalışma kuralları** | `%USERPROFILE%\.claude\CLAUDE.md` | Claude kuralları kullanıcı dizininden yükler. Orada durunca **her klasörde, her sohbette** geçerli olur; burada dursa yalnız bu klasör açıkken çalışırdı. |
| Asistanın **hafızası** | `%USERPROFILE%\.claude\projects\<proje>\memory\` | Aynı sebep — hafıza indeksi her sohbetin başında oradan otomatik yüklenir. |

Bu iki dosyayı açman gerekmez; asistanın işidir. "Kurallarım nerede yazıyor?" diye sorman
yeterli, tam yolu söyler.

Her klasörün içinde bir `NEDIR.md` var — o klasörün kuralını anlatır.

## Neden bu yapı (ve neden daha fazlası değil)

Altı-yedi klasörden fazlası akılda kalmaz. Ayrım şu mantığa dayanıyor:

- **Ham → işlenmiş → bitmiş** akışı: `Arastirma\` → konu klasörleri → `Belgeler\`
- **Kalıp ile içerik ayrı:** `Sablonlar\` boş kalıp, geri kalanı içerik
- **Gizlilik sınırı tek yerde:** hassas veri yalnız role özel konu klasöründe durur —
  bir belgeyi paylaşırken tek soru kalır: "bu oradan mı geliyor?"
- **Zaman ekseni ayrı:** `Gunluk\` konudan bağımsız, kronolojik iz
- **Sistem dosyası burada yok:** kural ve hafıza kullanıcı dizininde durur (yukarıdaki
  tablo) — bu klasör baştan sona **senin içeriğin**

Klasör eklemek gerekirse asistana söylemek yeterli.
