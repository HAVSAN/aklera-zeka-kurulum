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

## A — Yapısal ön koşullar (betik ölçer)

```
powershell -ExecutionPolicy Bypass -File araclar\kurulum-dogrula.ps1 -Kasa <KASA>
```

| Sonuç | Değer |
|---|---|
| Çıkış kodu (0 olmalı) | |
| Kalan madde varsa hangileri | |

⚠️ Betik "KALDI" diyorsa **B bölümüne geçme.**

---

## B — Davranış testleri (kurulumun gerçek kanıtı)

⛔ **Bu tablo eski 12 maddelik listenin yerine geçti.** Eski liste "dosya yazıldı mı" diye
soruyordu ve 11.08.2026'da çalışmayan bir kurulumu **baştan sona geçirdi** (bkz. B-03).

| # | Test | Beklenen | Durum |
|---|---|---|---|
| **a** | **Yeni sohbet:** "beni tanıyor musun?" | Rol + çalıştığı kurumlar sayıldı | ☐ |
| **b** | "Şablonlarım nerede?" | `<KASA>\Sablonlar` dedi | ☐ |
| **c** | "Nasıl cevap vermemi istiyorsun?" | Çalışma tercihini bildi | ☐ |
| **d** | Küçük bir iş verildi | ÖNCE süre tahmini, SONRA gerçekleşen süre yazdı | ☐ |
| **e** | Bir dosya düzenlendi | İzin sorusu **çıkmadı** | ☐ |
| **f** | Bir test dosyası silinmek istendi | İzin sorusu **çıktı** | ☐ |
| **g** | Kasanın **alt klasöründe** sohbet, (a) tekrar | Aynı sonuç geldi | ☐ |

⛔ **(a)–(g)'den biri kalırsa kurulum BAŞARISIZ sayılır.** "Çoğu çalışıyor" teslim edilmez.

**Neden yeni sohbet (a):** hafızanın yüklendiğini yalnız yeni sohbet kanıtlar; aynı sohbette
bilgi zaten bağlamdadır.
**Neden alt klasör (g):** kuralların kullanıcı dizininde olduğunu, kasa klasörüne bağlı
olmadığını yalnız bu test gösterir.

---

## C — Kalan elle kontroller

| # | Kontrol | Durum |
|---|---|---|
| 1 | Ön koşullar tam (Claude eklentisi + editör + git) | ☐ |
| 2 | İlk gerçek iş yapıldı, kullanıcı dosyayı gördü | ☐ |
| 3 | Pano canlı (`00-PANO.md`'de kullanıcının gerçek işi) | ☐ |
| 4 | Obsidian bağlı, sol panelde **6 klasör** (ek rol varsa 8) | ☐ |
| 5 | Yedekleme açık, kasa bulutta senkron | ☐ |
| 6 | Kullanıcı kendi eliyle en az 1 istem yazdı | ☐ |
| 7 | `SINIRLAR.md` gösterildi | ☐ |

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
| 1. hafta | Hafıza dizinine bak (`%USERPROFILE%\.claude\projects\<proje>\memory\`) — **büyümüş mü?** (büyümüyorsa sistem kullanılmıyor) | |
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
| B-03 | **Kurulum calisti, sistem calismadi** — kural ve hafiza kasaya yazildi, Claude ise bunlari kullanici dizininden yukler. Yeni sohbet kullaniciyi tanimadi. | 🔴 **Kurulumun tamami islevsiz** — dosyalar var, sistem gormuyor | ✅ **Duzeltildi** — asagida |

### B-03 ayrintili — kok sebep analizi

**Ne oldu.** 11.08.2026 sabahi ilk gercek kurulum yapildi. Butun dosyalar eksiksiz olustu,
12 maddelik dogrulama listesi bastan sona gecti. Ama yeni bir sohbet acildiginda asistan
kullaniciyi tanimadi, kurallari bilmedi. Operator musteri basinda elle duzeltmek zorunda kaldi.

**Kok sebep.** Depo her seyi kasaya yaziyordu:

| Ne | Nereye yaziliyordu | Claude bunu okur mu |
|---|---|---|
| Ortak cekirdek kurallar | `<KASA>\CEKIRDEK.md` | ❌ Hicbir zaman otomatik yuklenmez |
| Profil kurallari | `<KASA>\CLAUDE.md` | ⚠️ **Yalniz** editor tam o klasorde acikken |
| Hafiza indeksi | `<KASA>\MEMORY.md` | ❌ Auto-memory bu yolu bilmez |
| Hafiza notlari | `<KASA>\memory\*.md` | ❌ Ayni |

Yani butun sistem **tek bir kirilgan kosula** bagliydi: editorun kasa klasorunde acilmis
olmasi. Baska bir klasorde acilan sohbette sifir. Hafiza ise hicbir kosulda yuklenmiyordu.

**Cozum.** Kural ve hafiza kullanici dizinine tasindi; kasa yalniz icerik tasiyor:

```
%USERPROFILE%\.claude\CLAUDE.md               → cekirdek + profil, TEK dosya birlesik
%USERPROFILE%\.claude\settings.json           → oto mod + izinler
%USERPROFILE%\.claude\projects\<proje>\memory\ → hafiza notlari + MEMORY.md
<KASA>\                                        → YALNIZ icerik + kopru CLAUDE.md
```

Kunye ayrica kural dosyasinin **"Kullanici Kunyesi"** bolumune de yaziliyor — hafiza dizini
adi (`<proje>` slug'i) **dokumante degil** ve kasa tasinirsa degisebilir; kunye orada
durursa kullanici her kosulda taniniyor.

**Nasil yakalanabilirdi.** Eski liste "dosya yazildi mi?" diye soruyordu — hepsi yazilmisti,
hepsi gecti. Sorulmasi gereken **"sistem onu okuyor mu?"** idi. Ozellikle:

- **(a) testi** — yeni sohbette "beni taniyor musun": hafizayi kanitlar.
- **(g) testi** — kasanin ALT klasorunde ayni soru: kurallarin klasore bagli olmadigini
  kanitlar. Bu tek test hatayi dakikalar icinde yakalardi.
- **Regresyon kapisi** — `kurulum-dogrula.ps1` artik kasada `CEKIRDEK.md` / `MEMORY.md` /
  `memory\` bulursa **KALDI** der. Eski hatanin geri gelmesi imkansizlasti.

**Kural.** Bir dogrulama maddesi ancak **gozlemlenebilir bir davranisi** olcuyorsa gecerlidir.
"Dosya var" bir davranis degildir.

