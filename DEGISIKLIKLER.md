# Değişiklikler

Bu depo **sürümlüdür.** Kurulu bir makinenin sürümü, `%USERPROFILE%\.claude\CLAUDE.md`
dosyasının ilk satırındaki marker'da yazar:

```
<!-- HAVSAN-KURULUM:BASLANGIC surum=1.1.0 profil=yazilimci -->
```

Güncelleme tek komut:

```
git pull
powershell -ExecutionPolicy Bypass -File araclar\kur.ps1 -Guncelle
```

Ne değişeceğini önce görmek için `-KuruKosu` ekle. Kendi eklediğin satırlar ve künye tablosu
**korunur** — bkz. `araclar/kur.ps1` başlığı.

---

## 1.1.0 — 11.08.2026

**Sürüm kavramı ve güncelleme yolu kuruldu.** Bu sürümden önce "kimin hangi sürümde olduğu"
bilinmiyordu; güncelleme `git pull` + README adımlarını elle tekrarlamak demekti ve kullanıcının
kendi eklediği satırları eziyordu.

- **YENİ `SURUM`** dosyası — deponun tek sürüm kaynağı.
- **YENİ `araclar/kur.ps1 -Guncelle`** — kurulu dosyaları depodaki sürüme tazeler:
  - HAVSAN blokunu marker arasında değiştirir; **marker dışındaki her şeyi korur**
    (`KENDI-EKLERIN` bloku)
  - **Künye tablosunu** eski dosyadan alır, yeniden şablona düşürmez
  - `settings.json`'u **birleştirir** (mevcut `allow`/`deny` girdileri korunur), ezmez
  - İlk koşuda marker yoksa **benimseme (adopt)** turu yapar: yedek alır, karşılığı olmayan
    bölümleri silmez, `KENDI-EKLERIN`e taşır ve bunu **söyler**
  - `-KuruKosu` ile hiçbir dosyaya yazmadan ne değişeceğini gösterir
- **YENİ `ayarlar/settings-yazilimci-ek.json`** — yalnız yazılımcı profilinde kurulan izin
  katmanı: geliştirme komutları açılır (`dotnet test`, `npm`, dal işlemleri, `git push`),
  canlı sisteme elle dokunma kapatılır (`ssh`, `docker`, `psql`, `kubectl`).
- **`profiller/yazilimci/CLAUDE.md` güçlendirildi** — ekip içinde çalışan geliştirici için üç
  yeni bölüm: mimari standart (bağımlılık içe, katman atlanmaz, API-first), kapılar (pre-push,
  statik denetim, iş bitiminde kod incelemesi), yayın (tek yol = yayın betiği, kapsam sınırı,
  tek komutluk geri dönüş). Doğrulama bölümüne boru hattının çıkış kodunu maskelemesi ve
  "kabul ölçütü davranıştır" kuralı eklendi.
- **`araclar/kurulum-dogrula.ps1`** artık **sürüm kontrolü** yapıyor: kurulu sürüm ↔ depo
  sürümü. Geride ise ne koşulacağını yazar.
- `README.md` Adım 3b'ye yazılımcı ek katmanı adımı eklendi.

## 1.0.0 — 11.08.2026 (geriye dönük etiket)

İlk çalışan hâl. Bu etiket, sürüm kavramı kurulmadan önceki durumu adlandırmak için
geriye dönük verildi (`8ba18ac`). Marker taşımayan kurulumlar bu sürüm sayılır ve
`kur.ps1 -Guncelle` onları **benimseme** turuyla alır.

- 4 rol profili (`isg-uzmani`, `akademisyen`, `genel`, `yazilimci`) + ortak çekirdek + ek modül
- Kural ve hafızanın **kullanıcı dizinine** kurulması (kasaya değil) — ilk canlı kurulumun
  sessizce çalışmama sebebi buydu
- Oto mod standardı (`defaultMode=acceptEdits` + deny listesi)
- Belge çıktı hattı (LaTeX / Word / PDF)
- `araclar/kurulum-dogrula.ps1` — 20 yapısal ön koşulu ölçer, (a)-(g) davranış testlerini yazdırır
