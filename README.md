# Kişisel Zeka Kurulumu

**Bir bilgisayara, kişiyi tanıyan ve konuştukça gelişen bir asistan kurar.**
Kod bilgisi gerekmez. Kurulumu **Claude'un kendisi** yapar.

---

## ⛔ ÖNCE BUNU OKU — bu depo herkese açıktır

Bu depoya **hiçbir sır, müşteri verisi, gerçek firma/kişi adı, iç doküman ya da kurumsal
içerik girmez.** Buradaki her örnek anonimdir. Kurulan kişinin kendi kasası **ayrı ve özeldir**,
asla buraya geri gönderilmez. Katkı verecekler için ayrıntı: [`KATKI.md`](KATKI.md).

## ⛔ KURULUM YAPMADAN ÖNCE — operatör kuralı

**Bir kişiye kurulum yapmadan önce bu depo temiz bir makinede bir kez baştan sona koşmuş ve
Adım 6'daki (a)–(g) davranış testlerini geçmiş olmalıdır.** Depo değiştiyse bu prova
yeniden yapılır.

Sebep: 11.08.2026'daki ilk canlı kurulumda bütün dosyalar eksiksiz yazıldı, doğrulama listesi
baştan sona geçti ve **sistem yine de çalışmadı** — dosyalar Claude'un okumadığı bir konuma
kurulmuştu. "Dosya var mı" sorusu bunu yakalayamaz; yalnız davranış testi yakalar.
Ayrıntı: [`KURULUM-KONTROL.md`](KURULUM-KONTROL.md) → **B-03**.

---

## Nasıl kurulur (kullanıcı için tek cümle)

Editörde (Antigravity / VS Code) Claude panelini aç ve şunu yaz:

> **"Şu depoyu klonla: `https://github.com/HAVSAN/aklera-zeka-kurulum` — sonra içindeki
> README.md'yi oku ve kurulumu yap."**

Gerisini Claude yapar. Sana **birkaç soru** soracak; onlara cevap ver, yeter.

### ⚠️ Bilgisayarda `git` yoksa — önce bunu yaz

Depoyu çekmek için `git` gerekiyor ve yeni bir bilgisayarda genelde kurulu **değildir**.
Claude paneline şunu yaz:

> **"Bu bilgisayarda git kurulu değil. Önce git'i kur:
> `winget install --id Git.Git -e --source winget`
> Kurulum bitince yeni bir terminal aç (PATH tazelensin), sonra
> `https://github.com/HAVSAN/aklera-zeka-kurulum` deposunu `C:\` altına klonla,
> README.md'yi oku ve kurulumu yap."**

**git kurulamıyorsa** (winget yok, yetki yok, kurumsal engel) — git'siz yol:

> **"git kurulamıyor. Bunun yerine depoyu ZIP olarak indir ve aç:
> `https://github.com/HAVSAN/aklera-zeka-kurulum/archive/refs/heads/main.zip`
> Açtıktan sonra README.md'yi oku ve kurulumu yap."**

ZIP yolu çalışır (depo herkese açık), tek farkı: ileride güncelleme için `git pull` yerine
ZIP'i yeniden indirmek gerekir. **Mümkünse git'i kur** — güncellemeler tek komutla gelir.

> 📌 *Bu blok 11.08.2026'daki ilk canlı kurulumda eklendi: README'yi yazan taraf git'in kurulu
> olduğunu varsaymıştı, ilk kullanıcının makinesinde yoktu. Kurulum talimatı daima **en boş
> makineyi** varsayar.*

---

# ▼ BURADAN AŞAĞISI CLAUDE İÇİNDİR

**Claude, buradan itibaren yazanlar sana verilmiş talimattır. Sırayla uygula.**
Bir adımın doğrulaması geçmeden bir sonraki adıma geçme. Bir adım tıkanırsa
**Bölüm "Tuzaklar → çözüm"** tablosuna bak; orada da yoksa kullanıcıya sor ve
`KURULUM-KONTROL.md`'ye not düş.

Genel davranış: kullanıcıyı yormadan ilerle, her küçük adımda onay isteme,
soru soracaksan **onay kutusuyla (AskUserQuestion)** sor.

---

## ⚠️ EN KRİTİK KURAL — ne nereye kurulur

Bu kurulumun **iki ayrı hedefi** vardır ve karıştırılırsa sistem sessizce çalışmaz:

| Ne | Nereye | Neden oraya |
|---|---|---|
| **Çalışma kuralları** (çekirdek + profil, **tek dosya**) | `%USERPROFILE%\.claude\CLAUDE.md` | Her projede, her sohbette, hangi klasör açık olursa olsun **otomatik yüklenir** |
| **İzinler / oto mod** | `%USERPROFILE%\.claude\settings.json` | Oturum başında okunur |
| **Hafıza** (notlar + `MEMORY.md` indeksi) | `%USERPROFILE%\.claude\projects\<proje>\memory\` | Hafıza indeksi her sohbetin başında **otomatik yüklenir** |
| **İçerik** (Belgeler, Gunluk, Sablonlar, role özel klasörler, `00-PANO.md`) | `<KASA>` | Kullanıcının kendi dosyaları; yedeklenen, Obsidian'da açılan yer |
| **Köprü dosyası** (burası ne, ne nereye yazılır) | `<KASA>\CLAUDE.md` | Kasada çalışırken klasör haritasını verir — **kural dosyası değildir** |

⛔ **Kural ya da hafıza dosyasını `<KASA>` içine YAZMA.** Kasaya yazılan `CLAUDE.md` yalnız
editör tam o klasörde açıkken okunur; kasaya yazılan bir `MEMORY.md` ise **hiçbir zaman**
okunmaz. 11.08.2026'da kurulum tam bu yüzden çalışmadı.

⚠️ **Kullanıcı adını `$env:USERNAME`'den, ana dizini `$env:USERPROFILE`'dan oku.** Varsayma.

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
   → kasada **8 klasör** olur (4 ortak + 2 ana rol + 2 ek rol).
2. **Adım 2'ye ek:** `sablonlar/<EK-ROL-KARŞILIĞI>/` dosyalarını da `<KASA>\Sablonlar\`
   içine kopyala.
3. **Adım 3'e ek:** `profiller/<EK-ROL>/EK-MODUL.md` içeriğini, ürettiğin
   `%USERPROFILE%\.claude\CLAUDE.md` dosyasının **sonuna ekle** (ayrı dosya olarak kurma —
   ayrı dosya otomatik yüklenmez). Araya şu ayraç satırını koy:
   `---` + `> **Bu kullanıcının ikinci bir rolü de var. Çelişki olursa ana profil kazanır.**`
4. **Adım 4'e ek:** role özel 7. soruyu **iki rol için de** sor.
5. **Adım 6'ya ek:** klasör sayısı kontrolü **8** olur; Claude'a "kaç klasör var" diye
   sorduğunda **8** demeli ve **iki rolü de** sayabilmelidir.
   Doğrulama betiğini `-EkRol` anahtarıyla çalıştır.

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
   ⛔ `hafiza/` klasörünü **kopyalama** — orası kasaya değil, Adım 4'te kullanıcının hafıza
   dizinine gider.

4. **Role özel klasörleri kopyala:** `iskelet/<PROFİL>/` içindeki her şeyi de `<KASA>` köküne
   kopyala.

Sonuçta `<KASA>` içinde **6 klasör** olmalı:

| Profil | Ortak klasörler (4) | Role özel (2) |
|---|---|---|
| `isg-uzmani` | `Belgeler` `Sablonlar` `Arastirma` `Gunluk` | `Mevzuat` `Firmalar` |
| `akademisyen` | aynı | `Kaynakca` `Makaleler` |
| `genel` | aynı | `Isler` `Kurumlar` |
| `yazilimci` | aynı | `Projeler` `Notlar` |

⚠️ Kasada `memory\` klasörü **yoktur**. Hafıza kasanın dışındadır (Adım 4).

5. **Şablonları kopyala:** `sablonlar/<PROFİL-KARŞILIĞI>/` altındaki dosyaları
   `<KASA>\Sablonlar\` içine kopyala.
   Eşleme: `isg-uzmani`→`sablonlar/isg/` · `akademisyen`→`sablonlar/akademisyen/` ·
   `genel`→`sablonlar/genel/` · `yazilimci`→`sablonlar/yazilimci/`.
   **Genel şablonlar (`sablonlar/genel/`) her profile kopyalanır** — rapor ve toplantı notu
   herkese lazım olur.

6. `<KASA>` içindeki `[KURULUM TARİHİ]` ve `[GÜN]` yer tutucularını **bugünün tarihiyle**
   değiştir (`00-PANO.md`, `Gunluk\ORNEK-GUN.md`).

7. `Gunluk\` altına **bugünün dosyasını** aç: `YYYY-AA-GG.md` — `ORNEK-GUN.md` biçiminde.

**✅ Doğrulama:** `<KASA>` içinde 6 klasör + `00-PANO.md`, `CLAUDE.md` (köprü), `NEDIR.md`,
`ILK-GUN.md`, `SINIRLAR.md` dosyaları var; `Sablonlar\` boş değil; `memory\` **yok**.

---

## Adım 3 — Çalışma kurallarını KULLANICI DİZİNİNE kur

Bu adım **kurulumun en kritik adımıdır.** Asistan kuralları okumazsa sistemin geri kalanı
çalışmaz — ve kurallar yanlış yerdeyse **hiçbir hata mesajı almazsın**, sistem sessizce
sıradan bir asistan gibi davranır.

### 3.1 Birleşik kural dosyasını üret

`%USERPROFILE%\.claude\` klasörü yoksa oluştur, sonra **tek bir dosya** yaz:
**`%USERPROFILE%\.claude\CLAUDE.md`**

İçerik sırası:

1. `profiller/_ortak.md` — ortak çekirdek (tamamı)
2. `---` ayracı
3. `profiller/<PROFİL>/CLAUDE.md` — role özel bölüm (tamamı)
4. _(Adım 0b'de ek rol seçildiyse)_ `---` + `profiller/<EK-ROL>/EK-MODUL.md`

⛔ **İki ayrı dosya kurma.** `~\.claude\` altına konan ikinci bir dosya (eski `CEKIRDEK.md`)
**otomatik yüklenmez.** Kurallar tek dosyada birleşik durur.

Dosyayı yazdıktan sonra içindeki `[DEPO YOLU]` yer tutucusunu bu deponun **gerçek yoluyla**
değiştir (belge dönüştürme betiklerinin yeri).

### 3.2 Kasaya köprü dosyasını koy

`iskelet/_ortak/CLAUDE.md` dosyası `<KASA>\CLAUDE.md` olarak kopyalanır. Bu **kural dosyası
değildir** — kasada çalışırken "burası ne, ne nereye yazılır" sorusunu cevaplar.
Kişisel kural ya da hafıza notu buraya **yazılmaz**.

### 3.3 Klasör haritasını tamamla

`<KASA>\NEDIR.md` içindeki klasör haritası tablosuna **role özel iki klasörü ekle**
(`_(role özel klasörler)_` satırını değiştirerek). Açıklamalarını role özel
`NEDIR.md` dosyalarından al.

### 3.4 Doğrula — kuralların gerçekten yüklendiğini gör

1. Editörü `<KASA>` klasörü **açık olacak şekilde** başlat (File → Open Folder). Klasöre
   güven isteniyorsa onayla.
2. **Yeni bir Claude sohbeti aç** ve şunu yaz:

```
Calisma kurallarimi okudun mu? Okuduysan: rolumu, klasor haritasindaki klasor sayisini
ve hafizanin hangi dizinde durdugunu tek cumleyle soyle.
```

   **Beklenen cevap:** Türkçe · doğru rol · **6 klasör** (ek rol varsa 8) ·
   hafıza dizini olarak `%USERPROFILE%\.claude\projects\...` altında bir yol.

3. **İkinci test — yazma yetkisi:**

```
Gunluk klasorundeki bugunun dosyasina "Kurulum tamamlandi" diye bir satir ekle.
```

   Sonra dosyayı aç ve satırın orada olduğunu **gözünle gör.**

**✅ Doğrulama:** (a) "6 klasör" dendi, rol doğru söylendi ve hafıza dizini **kasanın dışında**
gösterildi, (b) günlük dosyasındaki satır gerçekten yazıldı.

⛔ **Bu adım geçmeden kuruluma "bitti" deme.** Asistan hafıza dizini olarak kasanın içindeki
bir yolu söylüyorsa kurulum **yanlıştır** — 3.1'e dön.

---

## Adım 3b — Oto mod ve izinler

Kullanıcı belge üreten biridir, kod yazan değil: gün boyu "izin veriyor musun" sorusuyla
karşılaşmamalı. Ama **silme ve geri alınamaz işlemler daima sorulmalı.**

1. `ayarlar/settings-sablon.json` dosyasını **`%USERPROFILE%\.claude\settings.json`** olarak
   yerleştir.
2. ⛔ **Var olan bir `settings.json` varsa EZME.** Önce oku, `permissions.allow` ve
   `permissions.deny` girdilerini **birleştir** (mevcut girdiler korunur), `defaultMode`
   yoksa ekle. Sonucun geçerli JSON olduğunu doğrula.
3. Ayar dosyası **oturum başında** okunur — değişiklik sonrası **yeni sohbet** açılmalıdır.

Neyin niye orada olduğu ve öncelik sırası (`deny` → `ask` → `allow`):
[`ayarlar/NEDIR.md`](ayarlar/NEDIR.md).

**✅ Doğrulama:** Adım 6'daki **(e)** ve **(f)** testleri. Bir `.md` dosyası düzenlendiğinde
izin sorusu **çıkmamalı**; bir dosya silinmek istendiğinde **çıkmalı**.

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

### Önce: hafıza dizinini BUL (tahmin etme)

Claude'un hafıza dizini `%USERPROFILE%\.claude\projects\<proje>\memory\` altındadır ama
`<proje>` adının nasıl türetildiği **dokümante değildir** ve Türkçe karakterli yollarda
beklenmedik sonuç verir. Bu yüzden **hesaplama, bul:**

1. Editör `<KASA>` açıkken açtığın sohbette Claude'a sor:
   > **"Hafıza dizininin tam yolunu yaz."**
   Kendi ortam bilgisinden gerçek yolu verir. Bu **birincil yöntemdir.**
2. Cevap gelmezse ölç — en son değişen proje dizini bu oturumunkidir:
   ```
   Get-ChildItem "$env:USERPROFILE\.claude\projects" | Sort-Object LastWriteTime -Descending | Select-Object -First 3 FullName, LastWriteTime
   ```
3. Bulduğun yolu `<HAFIZA>` diye anacağız. Yoksa oluştur.

⛔ **`<KASA>` içine hafıza yazma.** Kasadaki bir `MEMORY.md` hiçbir zaman yüklenmez.

### Cevaplardan ne yazacaksın (SORMADAN, hemen)

**Her cevabı aldıktan sonra — sonda toplu değil, üretir üretmez** şu dosyaları yaz:

| Dosya | İçerik |
|---|---|
| `<HAFIZA>\kullanici-profil.md` | Soru 1, 2, 4, 7 → rol, işin doğası, iletişim tercihi, yöntem tercihleri |
| `<HAFIZA>\calisilan-kurumlar.md` | Soru 3 → kurum/proje listesi, her biri tek satır |
| `<HAFIZA>\ilk-oncelikler.md` | Soru 5, 6 → yorucu bulduğu işler + ilk yardım isteyeceği iş |

Her dosyanın başına ortak çekirdek bölüm 4'teki bilgi bloğunu koy
(`ad`, `aciklama`, `tip`, `tarih`).

Sonra:
- `hafiza/MEMORY.md` şablonunu `<HAFIZA>\MEMORY.md` olarak kopyala ve **üç satır bağlantı
  ekle** — ilgili başlıkların altına. İndekse girmeyen not bulunmaz.
- **`%USERPROFILE%\.claude\CLAUDE.md` içindeki "Kullanıcı Künyesi" tablosunu doldur**
  (rol · kurumlar · çalışma tercihi · yöntem tercihi · kasa yolu · tarih).
  `[KURULUM: ...]` yer tutucusu **kalmamalı.**
  *Neden iki yer: hafıza dizini adı kasa taşınırsa değişebilir; künye kural dosyasında
  durursa kullanıcı her koşulda tanınır.*

⚠️ **Hafızaya kişisel/hassas veri yazma** (kimlik numarası, sağlık bilgisi, ücret).
Kurum adı ve rol bilgisi yazılabilir.

Ayrıca:
- Soru 6'nın cevabını **`00-PANO.md`'ye madde olarak** ekle.
- Röportajın özetini bugünün `Gunluk\` dosyasına yaz.
- `<KASA>\ILK-GUN.md` içindeki `<!-- KURULUM: ... -->` satırını, `istemler/<PROFİL>.md`
  kartlarından **kullanıcının cevaplarına en uygun 5 tanesiyle** değiştir
  (istem metinlerindeki köşeli parantezleri onun gerçek kurum/konu adlarıyla doldur).

**✅ Doğrulama:** `<HAFIZA>` altında 3 not + `MEMORY.md` var ve indeks üçüne de bağlanıyor;
kural dosyasındaki künye dolu; `ILK-GUN.md` içinde kişiye özel 5 istem duruyor.

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

## Adım 6 — Doğrulama: "yazıldı mı" değil, "çalışıyor mu"

⚠️ Eski kurulumda 12 maddelik bir liste vardı ve **hepsi geçtiği hâlde sistem çalışmıyordu.**
Sebep: liste "dosya yazıldı mı" diye soruyordu, "sistem onu okuyor mu" diye değil.
Doğrulama artık iki katmanlıdır.

### 6.1 Yapısal ön koşullar — betik ölçer

```
powershell -ExecutionPolicy Bypass -File araclar\kurulum-dogrula.ps1 -Kasa <KASA>
```
_(Adım 0b'de ek rol seçildiyse sona `-EkRol` ekle.)_

Betik şunları **ölçer**, geçmezse **çıkış kodu 1** döner: kural dosyası kullanıcı dizininde
mi · künye dolu mu · çekirdek+profil tek dosyada mı · `settings.json` geçerli ve oto mod
açık mı · silme `deny`'da mı · hafıza dizini bulundu mu · üç not + indeks bağlı mı ·
kasada 6 klasör var mı · **kasaya kural/hafıza dosyası sızmış mı** (eski hatanın
regresyon kapısı).

⛔ Betik "KALDI" diyorsa davranış testlerine **geçme**, önce onu düzelt.

### 6.2 Davranış testleri — kurulumun gerçek kanıtı

Bunları makine koşamaz; **operatör elle koşar.** Her biri geçmelidir.

| # | Test | Beklenen |
|---|---|---|
| **a** | **Yeni sohbet** aç: "beni tanıyor musun?" | Rolünü ve çalıştığı kurumları sayar |
| **b** | "Şablonlarım nerede?" | `<KASA>\Sablonlar` |
| **c** | "Nasıl cevap vermemi istiyorsun?" | Çalışma tercihini bilir (kısa/ayrıntılı, soru sorma tercihi) |
| **d** | Küçük bir iş ver | **ÖNCE** süre tahmini, **SONRA** gerçekleşen süre yazar |
| **e** | Bir dosyayı düzenlettir | İzin sorusu **ÇIKMAMALI** |
| **f** | Bir test dosyasını sildirmeye çalış | İzin sorusu **ÇIKMALI** |
| **g** | Kasanın bir **alt klasöründe** sohbet aç, (a)'yı tekrarla | Aynı sonuç |

⛔ **(a)–(g)'den herhangi biri kalırsa kurulum BAŞARISIZ sayılır.** "Çoğu çalışıyor" diye
teslim edilmez — kalan madde düzeltilir, testler baştan koşulur.

**Neden yeni sohbet:** hafızanın gerçekten yüklendiğini yalnız yeni bir sohbet kanıtlar;
aynı sohbette sorarsan bilgi zaten bağlamdadır ve cevap yanıltır.
**Neden alt klasör (g):** kuralların kullanıcı dizininde olduğunu, kasa klasörüne bağlı
olmadığını yalnız bu test gösterir. 11.08.2026'daki hata tam burada yakalanırdı.

### 6.3 Kalan elle kontroller

| # | Kontrol | Nasıl |
|---|---|---|
| 1 | Pano canlı | `00-PANO.md`'de kullanıcının gerçek ilk işi yazılı |
| 2 | Obsidian bağlı | Obsidian kasası `<KASA>`, sol panelde 6 klasör görünüyor |
| 3 | Yedekleme açık | Bulut istemcisinde `<KASA>` senkron listesinde, yeşil tik alınmış |
| 4 | Kullanıcı denedi | Kullanıcı kendi eliyle en az 1 istem yazdı ve sonucu gördü |

Sonucu [`KURULUM-KONTROL.md`](KURULUM-KONTROL.md)'ye işle.

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
  ⚠️ **Kurulumdan hemen sonra `pandoc` "tanınmıyor" diyebilir** — kurulum başarısız değildir,
  açık oturum eski `PATH`'i taşır. Sırayla dene: (1) tam yolla çağır
  (`"$env:LOCALAPPDATA\Pandoc\pandoc.exe"`), (2) `PATH`'i tazele:
  ```
  $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
  ```
  (3) editörü kapatıp yeniden aç. *(11.08.2026'da tam bu yaşandı.)*
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
| **Yeni sohbet kullanıcıyı tanımıyor** (a testi) | Kural ve/veya hafıza **kasaya** kurulmuş — Claude bunları kullanıcı dizininden yükler | Adım 3.1 ve Adım 4'ü tekrarla. `kurulum-dogrula.ps1` regresyon kapısı bunu yakalar. **En sık ve en sessiz hata budur** |
| Kasa açıkken çalışıyor, **başka klasörde çalışmıyor** (g testi) | Kurallar proje seviyesinde kalmış (`<KASA>\CLAUDE.md` içinde) | Kural dosyasını `%USERPROFILE%\.claude\CLAUDE.md` konumuna taşı; kasadakini köprüye indir (Adım 3.2) |
| Claude "6 klasör" demiyor, genel cevap veriyor | Kural dosyası yüklenmiyor | `%USERPROFILE%\.claude\CLAUDE.md` var mı bak; varsa editörü kapat–aç ve **yeni sohbet** dene |
| Claude İngilizce cevap veriyor | Aynı sebep — kurallar okunmamış | Aynı çözüm |
| Claude "CEKIRDEK.md nedir bilmiyorum" diyor | Çekirdek ayrı dosya olarak kurulmuş; ayrı dosya **otomatik yüklenmez** | Çekirdeği ve profili **tek dosyada birleştir** (Adım 3.1) |
| Klasör sayısı 6 değil | `_ortak` ya da role özel iskelet eksik/çift kopyalanmış; ya da `hafiza/` yanlışlıkla kasaya kopyalanmış | Adım 2.3–2.4'ü kontrol et; `<KASA>\_ortak\` oluştuysa içindekileri köke taşı, boşu sil; `<KASA>\memory\` ve `<KASA>\hafiza\` varsa **sil** |
| Her dosya düzenlemesinde izin soruyor (e testi) | `settings.json` yok ya da `defaultMode` ayarlanmamış | Adım 3b. Değişiklikten sonra **yeni sohbet** aç — ayar oturum başında okunur |
| Silme işlemi sormadan yapılıyor (f testi) | `deny` listesi eksik ya da `bypassPermissions` kullanılmış | `ayarlar/settings-sablon.json`'daki `deny` listesini geri koy; `bypassPermissions` **kullanma** |
| Asistan süre tahmini vermiyor (d testi) | Kural dosyası eski sürüm | Depoyu güncelle (`git pull`), Adım 3.1'i tekrarla |
| Claude paneli boş / "sign in" diyor | Eklenti oturumu yok | Panelden giriş yap, tarayıcıda doğrulamayı tamamla |
| Claude dosyaya yazamıyor, izin döngüsüne giriyor | Klasöre güven verilmemiş | Editörü kapat, tekrar aç, "Yes, I trust the authors" de |
| `C:\` altına klasör açılmıyor | Yönetici yetkisi yok | Kasayı `C:\Users\<kullanıcı>\<Ad>` yap ve **tüm dosyalardaki yol referanslarını** güncelle |
| Obsidian klasörleri göstermiyor | Yanlış klasör kasa yapılmış | Sol alt kasa adı → "Open another vault" → `<KASA>` |
| Obsidian `[[bağlantı]]`ları tıklanabilir yapmıyor | Dosya `.md` değil ya da salt-okunur | Uzantıyı kontrol et; klasördeki salt-okunur işaretini kaldır |
| Bulut istemcisinde kasa görünmüyor | Klasör "yedekle" değil "akış" modunda eklenmiş | Tercihler → Bilgisayarım → klasörü kaldır, yedekleme modunda yeniden ekle |
| Yeni sohbette hafıza hatırlanmıyor | Notlar yazıldı ama `MEMORY.md` indeksine bağlanmadı — ya da hafıza yanlış dizine yazıldı | Adım 4'ü tekrarla: önce `<HAFIZA>` dizinini **bul**, sonra notları oraya yaz ve indekse bağla |
| Kullanıcı terminal ekranı görünce takılıyor | Beklenen durum | Terminal panelini kapat. Bu sistemde terminal **gerekmiyor** |
| Türkçe karakterler bozuk görünüyor | Dosya kodlaması | Dosyaları **UTF-8** kaydet; dosya **adlarında** Türkçe karakter kullanma |
| Kullanıcı "profil yanlış seçilmiş" diyor | Adım 0'da yanlış rol | Adım 3.1'i yeni profille tekrarla (kural dosyasını yeniden üret), eksik klasörleri ekle — **hafızayı ve künyeyi silme**, ikisi de hâlâ geçerli |
| `pandoc` "tanınmıyor" diyor, oysa kuruldu | Açık oturum eski `PATH`'i taşıyor — program kurulu ama görünmez | Sırayla: (1) **tam yolla** çağır (`"$env:LOCALAPPDATA\Pandoc\pandoc.exe"`, `"$env:ProgramFiles\Pandoc\pandoc.exe"`), (2) `$env:Path`'i makine+kullanıcı değerlerinden **tazele**, (3) editörü kapat–aç. Sonra `belge-hatti-kontrol.ps1` ile ölç. **"Kurulum başarısız" deme** — 11.08'de bu yaşandı, ikinci denemede düzeldi |
| PDF üretiliyor ama Türkçe harfler kutu/soru işareti | Dosya UTF-8 değil | `.md` dosyasını **UTF-8** kaydet; dosya adlarında Türkçe karakter kullanma |
| LaTeX derlemesi "font bulunamadı" diyor | `\setmainfont` sistemde olmayan bir fontu istiyor | `makale.tex` içindeki fontu kurulu bir fontla değiştir (`Calibri`) ya da `TeX Gyre Termes` kullan |
| İlk LaTeX derlemesi çok uzun sürüyor | Tectonic TeX paketlerini ilk seferde indiriyor | Normal. Bir kereye mahsustur; sonraki derlemeler saniyeler sürer |
| Kullanıcı "Word şablonumuz var" diyor | Kurumsal biçim isteniyor | `md2docx.ps1 -Sablon <sablon.docx>` — şablonun **stilleri** kullanılır, içeriği değil |

---

## Depo haritası

```
README.md                  → bu dosya, kurulumun tek giriş noktası
KATKI.md                   → katkı kuralları + gizlilik sınırı
KURULUM-KONTROL.md         → her kurulumda doldurulan kontrol listesi + canlı kurulum bulguları
LICENSE                    → MIT

profiller/                 → ↓ BİRLEŞTİRİLİP %USERPROFILE%\.claude\CLAUDE.md olur
  _ortak.md                → her profilde aynı olan çekirdek kurallar (önce gelir)
  isg-uzmani/CLAUDE.md     + EK-MODUL.md   (ana profil + ikincil rol modülü)
  akademisyen/CLAUDE.md    + EK-MODUL.md
  genel/CLAUDE.md          + EK-MODUL.md
  yazilimci/CLAUDE.md      + EK-MODUL.md

ayarlar/                   → ↓ %USERPROFILE%\.claude\settings.json olur
  settings-sablon.json     → oto mod (acceptEdits) + allow/deny listeleri
  NEDIR.md                 → hangi anahtar ne yapar, öncelik sırası

hafiza/                    → ↓ %USERPROFILE%\.claude\projects\<proje>\memory\ olur
  MEMORY.md                → hafıza indeksi şablonu (KASAYA KOPYALANMAZ)
  NEDIR.md                 → hafıza nerede durur, neden orada durur

iskelet/                   → ↓ <KASA> olur (yalnız içerik + köprü)
  _ortak/                  → her kasaya kopyalanan ortak yapı + köprü CLAUDE.md
  isg-uzmani/  akademisyen/  genel/  yazilimci/    → role özel klasörler

sablonlar/
  isg/  genel/  akademisyen/  yazilimci/

istemler/
  isg.md  genel.md  akademisyen.md  yazilimci.md

araclar/
  kurulum-dogrula.ps1      → kurulumun ÇALIŞTIĞINI ölçer, geçmezse çıkış kodu 1
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
