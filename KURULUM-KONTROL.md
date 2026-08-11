# Kurulum Kontrol Listesi — Operatör İçin

Her yeni kurulumda **bu sayfanın bir kopyası doldurulur.** Amaç iki türlü:
kurulumun eksiksiz bittiğini garantilemek ve **README'yi iyileştirmek.**

> 📌 Kural: kurulum sırasında **tökezlenen her adım** aşağıdaki "Tökezlemeler" bölümüne yazılır.
> Kurulum bitince o notlar README'nin ilgili adımına ya da tuzak tablosuna yansıtılır.
> Bu döngü olmazsa aynı hata her kişide tekrar eder.

---

## Kurulum künyesi

| Alan | Değer |
|---|---|
| Kurulan kişi | |
| Tarih | |
| Seçilen profil | ☐ isg-uzmani ☐ akademisyen ☐ genel ☐ yazilimci |
| Kasa yolu | |
| Editör | ☐ Antigravity ☐ VS Code ☐ diğer: |
| Yedekleme | ☐ Google Drive ☐ OneDrive ☐ yok |
| Kurulumu yapan | |
| **Başlangıç saati** | |
| **Bitiş saati** | |
| **Toplam süre** | |

---

## 10 maddelik kontrol

| # | Kontrol | Nasıl ölçülür | Durum |
|---|---|---|---|
| 1 | Ön koşullar tam | Claude eklentisi + editör + git doğrulandı | ☐ |
| 2 | Kasa doğru yerde | `<KASA>\CLAUDE.md` kökte, alt klasörde değil | ☐ |
| 3 | Klasör yapısı tam | Kasada tam **7 klasör** | ☐ |
| 4 | Kurallar okunuyor | Claude "kaç klasör var" → **"7"** dedi | ☐ |
| 5 | Rol doğru | Claude "rolüm ne" → doğru rolü söyledi | ☐ |
| 6 | Yazma çalışıyor | Claude'un yazdığı satır diskte görüldü | ☐ |
| 7 | Tanışma röportajı yapıldı | `memory\` altında **3 dosya**, `MEMORY.md` bağlantılı | ☐ |
| 8 | **Hafıza yeni sohbette okunuyor** | Yeni sohbet açıldı, "beni tanıyor musun" → rol + kurumlar sayıldı | ☐ |
| 9 | İlk gerçek iş yapıldı | Kişinin gerçek işi üzerinden bir çıktı üretildi, kullanıcı dosyayı gördü | ☐ |
| 10 | Yedekleme + Obsidian | Kasa bulutta senkron, Obsidian'da 7 klasör görünüyor | ☐ |

**Ek:** ☐ Kullanıcı kendi eliyle en az 1 istem yazdı ☐ `SINIRLAR.md` gösterildi

⛔ **8. madde geçmeden kurulum "bitti" sayılmaz.** Hafızanın gerçekten okunduğunu yalnız
**yeni bir sohbet** kanıtlar — aynı sohbette sormak yanıltır.

---

## Tökezlemeler (kurulum sırasında doldurulur)

| Adım | Ne oldu | Nasıl çözüldü | README'ye yansıtıldı mı |
|---|---|---|---|
| | | | ☐ |
| | | | ☐ |
| | | | ☐ |

---

## Kurulum sonrası — 1. hafta takibi

Kurulum tek başına yetmez; sistem **kullanılmazsa ölür.**

| Ne zaman | Ne sorulacak | Sonuç |
|---|---|---|
| 2. gün | "Denedin mi? Ne yaptırdın?" | |
| 1. hafta | "Neyi yaptıramadın / nerede tıkandın?" | |
| 1. hafta | `memory\` klasörüne bak — **büyümüş mü?** (büyümüyorsa sistem kullanılmıyor) | |
| 1. ay | "Bu olmadan çalışmak nasıl olurdu?" — değer testi | |

---

## Geçmiş kurulumlar

| Tarih | Kişi | Profil | Süre | Not |
|---|---|---|---|---|
| | | | | |

---

## Canli kurulum bulgulari

### 11.08.2026 — 1. kurulum (ISG uzmani profili)

| # | Bulgu | Etki | Durum |
|---|---|---|---|
| B-01 | **git kurulu degildi** — README "depoyu klonla" ile basliyordu ama git yoksa depoya hic ulasilamiyor (tavuk-yumurta). | Kurulum ilk komutta durur | ✅ **Duzeltildi** — README basina "git yoksa once bunu yaz" blogu + ZIP alternatifi eklendi |
| B-02 | `<DEPO ADRESI>` yer tutucusu README icinde doldurulmamisti. | Kullanici hangi adresi yazacagini bilemez | ✅ **Duzeltildi** — gercek URL yazildi |

