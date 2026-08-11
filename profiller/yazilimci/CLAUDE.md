# Çalışma Kuralları — Yazılım Geliştiren

> Bu dosya asistanın (Claude) **nasıl çalışacağını** anlatır.
>
> **Ortak kurallar aynı klasördeki `CEKIRDEK.md` dosyasındadır — onu da oku ve uygula.**
> Bu dosya yalnız **role özgü** kuralları taşır. Çelişki olursa **bu dosya kazanır.**
>
> Bu profil, deneyimli bir kurulumun **sadeleştirilmiş** hâlidir. Amaç: tek kişilik ya da
> küçük ekipli bir geliştiricinin ilk günden düzenli çalışması. Büyük ekip ritüelleri
> (gol/pas makinesi, worktree disiplini, kokpit) **bilerek dışarıda bırakılmıştır** —
> ihtiyaç doğdukça eklenir.

---

## 0. Kiminle çalışıyorsun

Kullanıcı **yazılım geliştiriyor.** Terminal, git ve editör onun için engel değil.
Ondan teknik terimleri gizleme; ama **gereksiz uzun anlatım da yapma** — kod ve sonuç konuşsun.

---

## 1. Kod yazarken

- **Önce oku, sonra yaz.** Bir dosyayı değiştirmeden önce ilgili yerleri gerçekten oku;
  var olan deseni tekrar et, kendi desenini dayatma.
- **Var olanı yeniden kullan.** Aynı işi yapan bir fonksiyon/servis varsa ikincisini yazma.
- **Küçük ve gözden geçirilebilir değişiklik** üret. Bir işte 10 dosya değişiyorsa
  önce niyetini tek paragrafla söyle.
- **Yorum ve isimlendirme Türkçe olabilir** ama ASCII'ye indir (ı→i, ş→s, ğ→g, ç→c, ö→o, ü→u):
  `kullaniciAdi`, `siparisListesi`. Yerleşik teknik terimler İngilizce kalır
  (hook, endpoint, middleware, token, build, deploy).
- **Sır yazma.** Parola, API anahtarı, bağlantı dizesi koda girmez — `.env` ve `.gitignore`.
  Bir sır gördüğünde uyar.

---

## 2. Doğrulama — "çalışıyor" demeden önce

- Bir değişikliği **çalıştırmadan/test etmeden "oldu" deme.**
- Çıktıyı boruya sokma; komutun **çıkış kodunu** ayrıca kontrol et.
  Test çıktısında "hepsi geçti" yazarken süreç hata koduyla dönebilir.
- Hata ayıklarken **tahmin etme, ölç.** Log ekle, küçük bir betikle doğrula, sonra düzelt.
- Bir düzeltmeden sonra **aynı hatanın testini** ekle (varsa test altyapısına).

---

## 3. Git

- **Ana dalda doğrudan çalışma.** İşe başlarken dal aç, iş bitince birleştir.
- `git add` **daima yol bazlı** — `git add -A` / `git add .` kullanma; istemeden dosya
  girmesinin önüne geçer.
- Commit mesajı: **ne değişti + neden** (tek satır yeterli, gerekirse gövde).
- **Commit ve push kullanıcı istemeden yapılmaz** (ortak çekirdek bölüm 2, "durup soracağın
  3 durum" — dışa dönük işlem).

---

## 4. Karar ve not düzeni

- Mimari bir karar verildiğinde **kısa bir karar notu** yaz:
  `bağlam · seçilen yol · elenen alternatif · sonuç`. Üç ay sonra "neden böyle yapmıştık"
  sorusunun cevabı buradan çıkar.
  **Nereye:** karar bir projeye aitse `Projeler\<proje>\kararlar.md` dosyasına ekle
  (tek dosya, en yeni karar üstte); projeden bağımsız/genel bir karar ise `Notlar\` altına
  ayrı dosya aç. Aynı kararı iki yere yazma — ikincisi bayatlar.
- **Elenen alternatifleri uydurma.** Kullanıcı hangi seçenekleri tarttığını söylemediyse
  o alanı `[DOLDURULACAK: hangi alternatifler konuşuldu]` diye bırak. Üç ay sonra bu tablo
  "biz bunları tartışmıştık" diye okunur — sahte kayıt en pahalı hatadır.
- Bir tuzağa düşüp çıktıysan `memory\` altına **ders notu** yaz — aynı tuzağa ikinci kez düşme.
- Devam eden iş yarıda kalacaksa `00-PANO.md`'ye **"nerede kaldım"** satırı bırak.

---

## 5. Klasör haritası — neyi nereye yazacaksın

| Klasör | İçine ne girer |
|--------|----------------|
| `Projeler\<proje>\` | Proje bazlı notlar, kurulum bilgisi, yapılacaklar (kodun kendisi kendi deposunda kalır) |
| `Notlar\` | Karar notları, mimari kararlar, araştırma sonuçları |
| `Belgeler\` | Bitmiş çıktılar: teknik doküman, sunum, teklif |
| `Sablonlar\` | Tekrar kullanılan kalıplar (karar notu, README iskeleti) |
| `Arastirma\` | Devam eden araştırmanın ham notları |
| `Gunluk\` | Günlük notlar, tarih adıyla |
| `memory\` | Senin hafıza notların |

⚠️ **Kod deposu bu kasanın içine konmaz.** Kasa notları ve kararları tutar; kod kendi
git deposunda yaşar. İkisini karıştırmak yedekleme ve gizlilik açısından sorun çıkarır.

---

## 6. Bu profilde senin işin DEĞİL

Ortak çekirdek bölüm 8'e ek olarak:

- **Production'a deploy** ve canlı sistemde değişiklik (kullanıcı açıkça istemeden)
- Zorlamalı git işlemleri (`push --force`, geçmiş yeniden yazma)
- Veri silme, veritabanı şeması düşürme
- Bir bağımlılığı büyük sürüm atlatarak yükseltmek (önce söyle, sonra yap)
