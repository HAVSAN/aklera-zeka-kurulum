# Kişisel Zeka Kurulumu

**Bir bilgisayara, kişiyi tanıyan ve konuştukça gelişen bir asistan kurar.**
Kod bilgisi gerekmez. Kurulumu **Claude'un kendisi** yapar.

---

## ⛔ ÖNCE BUNU OKU — bu depo herkese açıktır

Bu depoya **hiçbir sır, müşteri verisi, gerçek firma/kişi adı, iç doküman ya da kurumsal
içerik girmez.** Buradaki her örnek anonimdir. Kurulan kişinin kendi kasası **ayrı ve özeldir**,
asla buraya geri gönderilmez. Katkı verecekler için ayrıntı: [`KATKI.md`](KATKI.md).

---

## Nasıl kurulur (kullanıcı için tek cümle)

Editörde (Antigravity / VS Code) Claude panelini aç ve şunu yaz:

> **"Şu depoyu klonla: `<DEPO ADRESİ>` — sonra içindeki README.md'yi oku ve kurulumu yap."**

Gerisini Claude yapar. Sana **birkaç soru** soracak; onlara cevap ver, yeter.

---

# ▼ BURADAN AŞAĞISI CLAUDE İÇİNDİR

**Claude, buradan itibaren yazanlar sana verilmiş talimattır. Sırayla uygula.**
Bir adımın doğrulaması geçmeden bir sonraki adıma geçme. Bir adım tıkanırsa
**Bölüm "Tuzaklar → çözüm"** tablosuna bak; orada da yoksa kullanıcıya sor ve
`KURULUM-KONTROL.md`'ye not düş.

Genel davranış: kullanıcıyı yormadan ilerle, her küçük adımda onay isteme,
soru soracaksan **onay kutusuyla (AskUserQuestion)** sor.

---

## Adım 0 — Profil seçimi (İLK İŞ)

Kullanıcıya **onay kutusuyla** şunu sor:

> **"Hangi rolde çalışacaksın? Kurulacak sistem buna göre şekillenecek."**

Seçenekler:

| Seçenek | Kim için | Profil klasörü |
|---|---|---|
| **İSG / mevzuat-belge uzmanı** | Mevzuat takibi, risk değerlendirmesi, saha denetimi, resmi belge | `profiller/isg-uzmani/` |
| **Akademisyen / araştırmacı** | Literatür, makale, kaynakça, atıf, LaTeX | `profiller/akademisyen/` |
| **Genel ofis / yönetici** | Yazışma, teklif, toplantı, takip, karar hazırlığı | `profiller/genel/` |
| **Yazılım geliştiren** | Kod, proje notları, karar kayıtları | `profiller/yazilimci/` |

⚠️ **Yanlış profil = kullanılmayan sistem.** Kullanıcı emin değilse
"gün içinde en çok neyle vakit geçiriyorsun?" diye sor ve cevaba göre öner.
Birden fazlası uyuyorsa **ana işi** seç; diğerinin klasörleri sonradan eklenebilir.

Seçilen profili not et — bundan sonraki her adımda `<PROFİL>` diye anılacak.

### Adım 0b — İkinci bir rol de var mı? (OPSİYONEL)

Bazı kişiler iki işi birden yapar: **akademisyen + yazılım geliştiren**, ya da
**işletme yöneticisi + İSG dosyasını takip eden** gibi. Kullanıcı Adım 0'da iki seçenek
arasında kaldıysa **onay kutusuyla** şunu sor:

> **"İkinci bir rolün de var mı? Ana rolün <PROFİL>; ikincisi için ek klasör ve kurallar
> ekleyebilirim."**

⚠️ **Karma bir profil ÜRETME.** İki `CLAUDE.md`'yi birleştirmek kuralları çelişkiye sokar.
Doğru yol: **ana profil + ek modül.**

İkinci rol seçilirse (`<EK-ROL>`), Adım 2 ve 3'te şunları **ilave** yap:

1. **Adım 2'ye ek:** `iskelet/<EK-ROL>/` içindeki klasörleri de `<KASA>` köküne kopyala
   → kasada **9 klasör** olur (5 ortak + 2 ana rol + 2 ek rol).
2. **Adım 2'ye ek:** `sablonlar/<EK-ROL-KARŞILIĞI>/` dosyalarını da `<KASA>\Sablonlar\`
   içine kopyala.
3. **Adım 3'e ek:** `profiller/<EK-ROL>/EK-MODUL.md` dosyasını `<KASA>\EK-ROL.md` olarak
   kopyala ve `<KASA>\CLAUDE.md` dosyasının **en üstündeki alıntı bloğuna** şu satırı ekle:
   > **Bu kullanıcının bir de ikinci rolü var — `EK-ROL.md` dosyasını da oku ve uygula.**
   > Çelişki olursa bu dosya (ana profil) kazanır.
4. **Adım 4'e ek:** role özel 7. soruyu **iki rol için de** sor.
5. **Adım 6'ya ek:** klasör sayısı kontrolü **9** olur; Claude'a "kaç klasör var" diye
   sorduğunda **9** demeli ve **iki rolü de** sayabilmelidir.

Ek rol **sonradan da** eklenebilir: bu beş maddeyi uygulamak yeter, kurulumu baştan yapmak
gerekmez. Hafıza ve mevcut dosyalar **silinmez.**

---

## Adım 1 — Ön koşul kontrolü

Şunların kurulu olup olmadığını **kontrol et** (sürüm sorgusu çalıştır, tahmin etme):

| # | Gerekli | Neden | Zorunlu mu |
|---|---|---|---|
| 1 | **Claude eklentisi / CLI** (editör içinde) | Asistanın kendisi | ✅ Zorunlu |
| 2 | **Bir editör** — Antigravity ya da VS Code | Asistanla konuşulan yer | ✅ Zorunlu |
| 3 | **git** | Bu deponun çekilmesi | ✅ Zorunlu |
| 4 | **Obsidian** | Üretilen notların okunduğu/düzenlendiği yer | ⭕ Şiddetle önerilir |
| 5 | **Bulut yedekleme** (Google Drive Desktop / OneDrive) | Kasa yedeği | ⭕ Şiddetle önerilir |
| 6 | Docker, LaTeX, Pandoc | Belge dönüştürme hattı | ❌ **Zorunlu değil** — bkz. Adım 7 (opsiyonel) |

**Eksik olan için:**
- Kendin kurabiliyorsan (paket yöneticisi varsa) **kurulum komutunu çalıştırmayı öner**,
  onay kutusuyla sor, onay gelirse kur.
- Kuramıyorsan **indirme adresini ve adımları numaralı** yaz, kullanıcı kursun, sonra devam et.
- 4 ve 5 yoksa kuruluma **devam et** ama `KURULUM-KONTROL.md`'ye "eksik" diye not düş
  ve kullanıcıya bir cümleyle söyle.

⛔ **Docker'ı zorunlu tutma.** Bu kurulumda kullanılmıyor.

**✅ Doğrulama:** 1–3 maddesinin üçü de doğrulandı (komut çalıştı, sürüm göründü).

---

## Adım 2 — Kasa klasörünü kur

1. Kullanıcıya **onay kutusuyla** sor:
   > **"Çalışma klasörün nerede olsun?"**
   > Önerilen: `C:\<Adı>` (örn. kullanıcının adı `Ayse` ise `C:\Ayse`) — kısa, bulunması kolay.
   > Alternatif: `C:\Users\<kullanıcı>\<Adı>` (yönetici yetkisi gerekmez).

   Bu klasör bundan sonra **`<KASA>`** diye anılacak.

2. `<KASA>` klasörünü oluştur.

3. **Ortak iskeleti kopyala:** `iskelet/_ortak/` içindeki **her şeyi** `<KASA>` köküne kopyala.
   (`_ortak` klasörünün *kendisini* değil, *içindekileri*.)

4. **Role özel klasörleri kopyala:** `iskelet/<PROFİL>/` içindeki her şeyi de `<KASA>` köküne
   kopyala.

Sonuçta `<KASA>` içinde **7 klasör** olmalı:

| Profil | Ortak klasörler (5) | Role özel (2) |
|---|---|---|
| `isg-uzmani` | `memory` `Belgeler` `Sablonlar` `Arastirma` `Gunluk` | `Mevzuat` `Firmalar` |
| `akademisyen` | aynı | `Kaynakca` `Makaleler` |
| `genel` | aynı | `Isler` `Kurumlar` |
| `yazilimci` | aynı | `Projeler` `Notlar` |

5. **Şablonları kopyala:** `sablonlar/<PROFİL-KARŞILIĞI>/` altındaki dosyaları
   `<KASA>\Sablonlar\` içine kopyala.
   Eşleme: `isg-uzmani`→`sablonlar/isg/` · `akademisyen`→`sablonlar/akademisyen/` ·
   `genel`→`sablonlar/genel/` · `yazilimci`→`sablonlar/yazilimci/`.
   **Genel şablonlar (`sablonlar/genel/`) her profile kopyalanır** — rapor ve toplantı notu
   herkese lazım olur.

6. `<KASA>` içindeki `[KURULUM TARİHİ]` ve `[GÜN]` yer tutucularını **bugünün tarihiyle**
   değiştir (`00-PANO.md`, `MEMORY.md`, `Gunluk\ORNEK-GUN.md`).

7. `Gunluk\` altına **bugünün dosyasını** aç: `YYYY-AA-GG.md` — `ORNEK-GUN.md` biçiminde.

**✅ Doğrulama:** `<KASA>` içinde 7 klasör + `00-PANO.md`, `MEMORY.md`, `NEDIR.md`,
`ILK-GUN.md`, `SINIRLAR.md` dosyaları var; `Sablonlar\` boş değil.

---

## Adım 3 — CLAUDE.md yerleştirme ve okunduğunun doğrulanması

Bu adım **kurulumun en kritik adımıdır.** Asistan kuralları okumazsa sistemin geri kalanı çalışmaz.

1. `profiller/_ortak.md` dosyasını `<KASA>\CEKIRDEK.md` olarak kopyala.
2. `profiller/<PROFİL>/CLAUDE.md` dosyasını `<KASA>\CLAUDE.md` olarak kopyala.
   → **Proje seviyesine** kurulur, kullanıcı seviyesine (`~/.claude/CLAUDE.md`) değil.
   Sebep: kişinin başka klasörlerde çalışması bu kurallardan etkilenmesin, kasa açıldığında
   kurallar kendiliğinden yüklensin.
3. `<KASA>\NEDIR.md` içindeki klasör haritası tablosuna **role özel iki klasörü ekle**
   (`_(role özel klasörler)_` satırını değiştirerek). Açıklamalarını role özel
   `NEDIR.md` dosyalarından al.
4. Editörü `<KASA>` klasörü **açık olacak şekilde** başlat (File → Open Folder). Klasöre
   güven isteniyorsa onayla.
5. **Yeni bir Claude sohbeti aç** ve şunu yaz:

```
Çalışma kurallarımı okudun mu? Okuduysan: hafıza indeks dosyasının adını,
klasör haritasındaki klasör sayısını ve rolümü tek cümleyle söyle.
```

   **Beklenen cevap:** Türkçe · `MEMORY.md` · **7 klasör** · doğru rol.

6. **İkinci test — yazma yetkisi:**

```
Gunluk klasorundeki bugunun dosyasina "Kurulum tamamlandi" diye bir satir ekle.
```

   İzin istenirse onayla, sonra dosyayı aç ve satırın orada olduğunu **gözünle gör.**

**✅ Doğrulama:** (a) "7 klasör" dendi ve rol doğru söylendi, (b) günlük dosyasındaki satır
gerçekten yazıldı.

⛔ **Bu adım geçmeden kuruluma "bitti" deme.**

---

## Adım 4 — TANIŞMA RÖPORTAJI (bu kurulumun kalbi)

Kullanıcıya şunu söyle:

> "Şimdi seni biraz tanıyacağım — 6 kısa soru. Cevaplarını hafızama yazacağım, böylece
> bir daha anlatmana gerek kalmayacak. Bilmediğin ya da atlamak istediğin soruyu 'geç' de."

Soruları **tek tek, sırayla** sor (hepsini bir anda yığma). Kısa cevap yeterli; kullanıcıyı
uzun uzun yazdırma, gerekirse sen toparla ve teyit et.

### Sorular — birebir

1. **"Ne iş yapıyorsun? Unvanını ve çalıştığın kurumu/alanı tek cümleyle anlatır mısın?"**
2. **"Sıradan bir iş günün neye benziyor? En çok vaktini ne alıyor?"**
3. **"Hangi kurumlarla / firmalarla / projelerle çalışıyorsun? İlk akla gelen 3-5 tanesi yeter."**
4. **"Nasıl çalışmayı seversin: kısa ve sonuç odaklı cevaplar mı, ayrıntılı açıklama mı?
   Sana bir şey sormamı mı istersin, yoksa makul olanı seçip ilerlememi mi?"**
5. **"Seni işinde en çok ne yoruyor? Hangi işi devretmek isterdin?"**
6. **"İlk olarak hangi işte yardım istersin? Bugün masanda ne var?"**
7. _(Role özel — profile göre birini sor)_
   - **İSG:** "Hangi risk değerlendirme yöntemini kullanıyorsun (Fine-Kinney, L tipi matris,
     başka)? Raporlarını hangi biçimde teslim ediyorsun?"
   - **Akademisyen:** "Hangi atıf stilini kullanıyorsun (APA 7, IEEE, Chicago…)? LaTeX mi
     Word mü çalışıyorsun? Şu an devam eden çalışmaların ve son tarihleri neler?"
   - **Genel:** "Yazışmalarında ton nasıl olmalı — resmî mi, samimi mi? Takip etmen gereken
     düzenli işler var mı (aylık rapor, periyodik toplantı)?"
   - **Yazılımcı:** "Hangi teknolojilerle çalışıyorsun? Kod depoların nerede duruyor?"

### Cevaplardan ne yazacaksın (SORMADAN, hemen)

**Her cevabı aldıktan sonra — sonda toplu değil, üretir üretmez** şu dosyaları yaz:

| Dosya | İçerik |
|---|---|
| `<KASA>\memory\kullanici-profil.md` | Soru 1, 2, 4, 7 → rol, işin doğası, iletişim tercihi, yöntem tercihleri |
| `<KASA>\memory\calisilan-kurumlar.md` | Soru 3 → kurum/proje listesi, her biri tek satır |
| `<KASA>\memory\ilk-oncelikler.md` | Soru 5, 6 → yorucu bulduğu işler + ilk yardım isteyeceği iş |

Her dosyanın başına `CEKIRDEK.md` bölüm 4'teki bilgi bloğunu koy
(`ad`, `aciklama`, `tip`, `tarih`).

Sonra **`<KASA>\MEMORY.md`'ye üç satır bağlantı ekle** — ilgili başlıkların altına.

⚠️ **Hafızaya kişisel/hassas veri yazma** (kimlik numarası, sağlık bilgisi, ücret).
Kurum adı ve rol bilgisi yazılabilir.

Ayrıca:
- Soru 6'nın cevabını **`00-PANO.md`'ye madde olarak** ekle.
- Röportajın özetini bugünün `Gunluk\` dosyasına yaz.
- `<KASA>\ILK-GUN.md` içindeki `<!-- KURULUM: ... -->` satırını, `istemler/<PROFİL>.md`
  kartlarından **kullanıcının cevaplarına en uygun 5 tanesiyle** değiştir
  (istem metinlerindeki köşeli parantezleri onun gerçek kurum/konu adlarıyla doldur).

**✅ Doğrulama:** `memory\` altında 3 dosya var, `MEMORY.md` bunlara bağlanıyor,
`ILK-GUN.md` içinde kişiye özel 5 istem duruyor.

---

## Adım 5 — İlk gerçek iş

Kullanıcıya, **Adım 4 soru 6'da söylediği işi** hemen yaptır. Kendin bir örnek uydurma —
onun gerçek işini kullan. Uygun bir iş çıkmadıysa profiline göre şunu öner:

| Profil | Önerilen ilk iş |
|---|---|
| `isg-uzmani` | "Sık kullandığın bir yönetmeliği bulup kaynağıyla `Mevzuat\` altına özetleyeyim." |
| `akademisyen` | "Şu an okuduğun bir makalenin künyesini ve okuma notunu `Kaynakca\` altına çıkarayım." |
| `genel` | "Bu haftaki işlerini panoya dökeyim, eksik sorumlusu/tarihi olanları işaretleyeyim." |
| `yazilimci` | "Bir projenin künyesini ve mimari haritasını `Projeler\` altına çıkarayım." |

İşi bitirdikten sonra:
1. Ürettiğin dosyanın **tam yolunu** söyle.
2. Kullanıcıdan **Obsidian'da o dosyayı açmasını** iste — "yazdığım şey burada duruyor,
   kaybolmuyor" deneyimi kurulumun en ikna edici anıdır.

**✅ Doğrulama:** Kullanıcı, asistanın ürettiği dosyayı Obsidian'da (ya da editörde) gördü.

---

## Adım 6 — Kurulum doğrulama listesi

Her maddeyi **fiilen kontrol et**, tahmin etme. Sonucu `KURULUM-KONTROL.md`'ye işle.

| # | Kontrol | Nasıl ölçülür |
|---|---|---|
| 1 | Kasa doğru yerde | `<KASA>\CLAUDE.md` var (alt klasörde değil, **kökte**) |
| 2 | Klasör yapısı tam | `<KASA>` içinde tam **7 klasör** var (Adım 0b'de ek rol seçildiyse **9**) |
| 3 | Kurallar okunuyor | Claude'a "klasör haritasında kaç klasör var" → **"7"** demeli |
| 4 | Rol doğru yüklü | Claude'a "benim rolüm ne" → doğru rolü söylemeli |
| 5 | Yazma çalışıyor | Claude bir dosya yazdı, dosya diskte görüldü |
| 6 | Hafıza kuruldu | `memory\` altında **3 dosya** var, `MEMORY.md` üçüne de bağlanıyor |
| 7 | Hafıza okunuyor | **Yeni bir sohbette** "beni tanıyor musun" → rolünü ve kurumlarını saymalı |
| 8 | Şablonlar yerinde | `<KASA>\Sablonlar\` içinde en az 2 şablon var |
| 9 | Pano canlı | `00-PANO.md`'de kullanıcının gerçek ilk işi yazılı |
| 10 | Obsidian bağlı | Obsidian kasası `<KASA>`, sol panelde 7 klasör görünüyor |
| 11 | Yedekleme açık | Bulut istemcisinde `<KASA>` senkron listesinde, yeşil tik alınmış |
| 12 | Kullanıcı denedi | Kullanıcı kendi eliyle en az 1 istem yazdı ve sonucu gördü |

**7. madde en kritik olanıdır** — hafızanın gerçekten okunduğunu yalnız **yeni bir sohbet**
kanıtlar. Aynı sohbette sorarsan zaten bağlamda olduğu için yanıltıcı olur.

Hepsi geçtiyse kullanıcıya şunu söyle:

> "Kurulum tamam. Takıldığında `ILK-GUN.md` dosyasına bak — tek sayfa.
> Neyi yapıp neyi yapmadığım `SINIRLAR.md`'de yazılı, bir kez okumanı öneririm."

Kurulum burada **biter.** Aşağıdaki Adım 7 isteğe bağlıdır; kullanıcı belge çıktısı
(PDF/Word/LaTeX) isteyecekse şimdi ya da ileride uygulanır.

---

## Adım 7 (OPSİYONEL) — Belge çıktı hattı: PDF · Word · LaTeX

⛔ **Bu adım zorunlu değildir.** Adım 6 geçtiyse sistem çalışıyor demektir. Buradaki
kurulum yalnız "bunu PDF yap", "Word'e çevir", "makale formatına dök" denecekse gerekir.

Kullanıcıya **onay kutusuyla** sor:

> **"Yazdıklarını dosyaya (PDF/Word) çevirmem gerekecek mi?"**

| Seçenek | Kurulacak | Boyut | Ne verir |
|---|---|---|---|
| **Sadece PDF yeter** | *hiçbir şey* | 0 | Markdown → **PDF** (tarayıcı basar) |
| **Word ve kaynakça da lazım** | Pandoc | ~200 MB | + **.docx**, + `.bib`'ten **otomatik kaynakça**, + `.tex` kaynağı |
| **LaTeX derlemem gerekiyor** (dergi şablonu) | Pandoc + Tectonic | +~25 MB | + `.tex` → **PDF** derleme |
| **Şimdilik hayır** | — | — | Sonradan bu adım tek başına uygulanabilir |

**Katman 0 zaten kuruludur** — Windows'ta Edge varsa PDF üretilir, kurulum gerekmez.

### 7.1 Kurulum (seçime göre)

- **Word/kaynakça seçildiyse:**
  ```
  winget install --id JohnMacFarlane.Pandoc
  ```
  Kurulumdan sonra **terminali kapatıp yeniden aç** (PATH tazelensin).
- **LaTeX seçildiyse** (Pandoc'a ek olarak):
  ```
  powershell -ExecutionPolicy Bypass -File araclar\belge\tectonic-kur.ps1
  ```
  Tek `.exe` indirir (~25 MB), PATH'e ekler. ⛔ **MiKTeX / TeX Live kurma** — 1-5 GB'lık
  dağıtımlara bu iş için gerek yok.

### 7.2 Doğrulama — ZORUNLU

Kurulum bitince şunu çalıştır ve çıktısını kullanıcıya göster:

```
powershell -ExecutionPolicy Bypass -File araclar\belge\belge-hatti-kontrol.ps1
```

Bu betik "kurulu görünüyor" demez: her katman için **örnek bir belgeyi gerçekten üretir**
ve içindeki Türkçe denetim satırını arar. Kurulmamış katman `ATLANDI` yazar (hata değil),
kurulu ama çalışmayan katman `BOZUK` yazar ve **çıkış kodu 1** döner.

Son adım kullanıcıdadır: üretilen PDF'i açsın ve şu satırın bozulmadığını **gözüyle görsün**:

> DENETIM: ığüşöçİĞÜŞÖÇ — Pijamalı hasta yağız şoföre çabucak güvendi.

### 7.3 Bundan sonra hangi komutu ne zaman çalıştıracaksın

| Kullanıcı ne derse | Sen ne çalıştırırsın |
|---|---|
| "bunu PDF yap" | `araclar\belge\md2pdf.ps1 -Girdi <dosya.md>` |
| "akademik biçimde PDF yap" (ilk satır girintili) | `md2pdf.ps1 -Girdi <dosya.md> -Girintili` |
| "Word'e çevir" | `araclar\belge\md2docx.ps1 -Girdi <dosya.md>` |
| "kaynakçayı otomatik yaz" | `md2docx.ps1 -Girdi <dosya.md> -Kaynakca <kaynakca.bib> -AtifStili <apa.csl>` |
| "kurumun şablonuyla Word ver" | `md2docx.ps1 -Girdi <dosya.md> -Sablon <sablon.docx>` |
| "LaTeX'e çevir" | `araclar\belge\md2tex.ps1 -Girdi <dosya.md>` |
| "derginin şablonuna gövde lazım" | `md2tex.ps1 -Girdi <dosya.md> -Parca` (derginin `.cls` dosyasını **bozma**) |
| "LaTeX'i derle / PDF'ini gör" | `araclar\belge\tex2pdf.ps1 -Girdi <dosya.tex>` |

Hazır şablonlar: `sablonlar\akademisyen\latex\makale.tex` (Türkçe, XeLaTeX) ve
`kaynakca.bib`. Kurulumda akademisyen profili seçildiyse bu ikisini `<KASA>\Sablonlar\`
altına da kopyala.

**✅ Doğrulama:** `belge-hatti-kontrol.ps1` çıkış kodu 0 döndü ve kullanıcı üretilen PDF'i
açıp Türkçe denetim satırını gördü.

---

## Tuzaklar → çözüm

| Belirti | Sebep | Ne yapacaksın |
|---|---|---|
| Claude "7 klasör" demiyor, genel cevap veriyor | `CLAUDE.md` yanlış yerde (alt klasörde kalmış) | Adım 3'ü tekrarla — dosya **doğrudan** `<KASA>` kökünde olmalı |
| Claude İngilizce cevap veriyor | Kurallar okunmamış | Aynı sebep. Klasörü kapat, `File → Open Folder` ile `<KASA>`'yı **yeniden** aç |
| Claude "CEKIRDEK.md nedir bilmiyorum" diyor | Ortak çekirdek kopyalanmamış | `profiller/_ortak.md` → `<KASA>\CEKIRDEK.md` kopyasını yap |
| Klasör sayısı 7 değil | `_ortak` ya da role özel iskelet eksik/çift kopyalanmış | Adım 2.3–2.4'ü kontrol et; `<KASA>\_ortak\` diye bir klasör oluştuysa içindekileri köke taşı, boşu sil |
| Claude paneli boş / "sign in" diyor | Eklenti oturumu yok | Panelden giriş yap, tarayıcıda doğrulamayı tamamla |
| Claude dosyaya yazamıyor, izin döngüsüne giriyor | Klasöre güven verilmemiş | Editörü kapat, tekrar aç, "Yes, I trust the authors" de |
| `C:\` altına klasör açılmıyor | Yönetici yetkisi yok | Kasayı `C:\Users\<kullanıcı>\<Ad>` yap ve **tüm dosyalardaki yol referanslarını** güncelle |
| Obsidian klasörleri göstermiyor | Yanlış klasör kasa yapılmış | Sol alt kasa adı → "Open another vault" → `<KASA>` |
| Obsidian `[[bağlantı]]`ları tıklanabilir yapmıyor | Dosya `.md` değil ya da salt-okunur | Uzantıyı kontrol et; klasördeki salt-okunur işaretini kaldır |
| Bulut istemcisinde kasa görünmüyor | Klasör "yedekle" değil "akış" modunda eklenmiş | Tercihler → Bilgisayarım → klasörü kaldır, yedekleme modunda yeniden ekle |
| Yeni sohbette hafıza hatırlanmıyor | `MEMORY.md` bağlantıları yazılmamış | Adım 4'ün son maddesini tekrarla — `memory\` dosyaları indekse bağlanmalı |
| Kullanıcı terminal ekranı görünce takılıyor | Beklenen durum | Terminal panelini kapat. Bu sistemde terminal **gerekmiyor** |
| Türkçe karakterler bozuk görünüyor | Dosya kodlaması | Dosyaları **UTF-8** kaydet; dosya **adlarında** Türkçe karakter kullanma |
| Kullanıcı "profil yanlış seçilmiş" diyor | Adım 0'da yanlış rol | Yeni profilin `CLAUDE.md`'sini kopyala, eksik klasörleri ekle — **hafızayı silme**, o hâlâ geçerli |
| `pandoc` "tanınmıyor" diyor, oysa kuruldu | Açık terminal eski PATH'i taşıyor | Terminali kapat–aç. Betikler kurulum klasörüne de bakar; yine olmazsa `belge-hatti-kontrol.ps1` çalıştır |
| PDF üretiliyor ama Türkçe harfler kutu/soru işareti | Dosya UTF-8 değil | `.md` dosyasını **UTF-8** kaydet; dosya adlarında Türkçe karakter kullanma |
| LaTeX derlemesi "font bulunamadı" diyor | `\setmainfont` sistemde olmayan bir fontu istiyor | `makale.tex` içindeki fontu kurulu bir fontla değiştir (`Calibri`) ya da `TeX Gyre Termes` kullan |
| İlk LaTeX derlemesi çok uzun sürüyor | Tectonic TeX paketlerini ilk seferde indiriyor | Normal. Bir kereye mahsustur; sonraki derlemeler saniyeler sürer |
| Kullanıcı "Word şablonumuz var" diyor | Kurumsal biçim isteniyor | `md2docx.ps1 -Sablon <sablon.docx>` — şablonun **stilleri** kullanılır, içeriği değil |

---

## Depo haritası

```
README.md                  → bu dosya, kurulumun tek giriş noktası
KATKI.md                   → katkı kuralları + gizlilik sınırı
KURULUM-KONTROL.md         → her kurulumda doldurulan kontrol listesi
LICENSE                    → MIT

profiller/
  _ortak.md                → her profilde aynı olan çekirdek kurallar → kasada CEKIRDEK.md
  isg-uzmani/CLAUDE.md     + EK-MODUL.md   (ana profil + ikincil rol modülü)
  akademisyen/CLAUDE.md    + EK-MODUL.md
  genel/CLAUDE.md          + EK-MODUL.md
  yazilimci/CLAUDE.md      + EK-MODUL.md

iskelet/
  _ortak/                  → her kasaya kopyalanan ortak yapı
  isg-uzmani/  akademisyen/  genel/  yazilimci/    → role özel klasörler

sablonlar/
  isg/  genel/  akademisyen/  yazilimci/

istemler/
  isg.md  genel.md  akademisyen.md  yazilimci.md

araclar/
  belge/                   → Adım 7'nin (opsiyonel) belge çıktı hattı
    md2pdf.ps1             → Markdown → PDF   (kurulum gerektirmez)
    md2docx.ps1            → Markdown → Word  (Pandoc)
    md2tex.ps1             → Markdown → LaTeX kaynağı (Pandoc)
    tex2pdf.ps1            → LaTeX → PDF      (Tectonic)
    tectonic-kur.ps1       → LaTeX derleyicisini kurar (~25 MB)
    belge-hatti-kontrol.ps1→ hattın çalıştığını ÜRETEREK ölçer
    stil.css               → PDF sayfa düzeni (A4, Türkçe tipografi)
    ornek/                 → örnek belgeler + derlenmiş kanıt çıktıları
```

---

## Bu sistem ne DEĞİLDİR

- Bir yazılım ürünü değil — **çalışma düzeni.** Kurulum sonrası değeri, kişinin onu
  kullanmasından gelir.
- Bir yedekleme çözümü değil — yedeklemeyi bulut istemcisi yapar.
- Kurulunca "biten" bir şey değil — hafıza konuştukça büyür. İlk hafta zayıf, üçüncü ay güçlüdür.
