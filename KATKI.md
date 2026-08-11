# Katkı Kuralları

Bu depo **herkese açık olabilir.** Katkı vermeden önce tek bir şeyi bil:

---

## ⛔ Buraya asla girmeyecek olanlar

| Girmez | Neden |
|---|---|
| Parola, API anahtarı, token, bağlantı dizesi | Açık depo = herkes görür |
| Gerçek firma, kurum, müşteri adı | Ticari gizlilik |
| Gerçek kişi adı, kimlik/iletişim bilgisi, sağlık verisi | KVKK |
| Kurum içi doküman, rapor, teklif, sözleşme | Bunlar kişinin kendi kasasına ait |
| Bir kişinin kurulmuş kasasının içeriği | Kasa **özeldir**, depoya geri gönderilmez |
| Ekran görüntüsü içinde görünen gerçek veri | En sık gözden kaçan sızıntı yolu |

**Örnekler daima anonim olur:** `Ornek Metal A.S.`, `[KİŞİ-1]`, `ornek-kurum`.

Bir dosyayı eklemeden önce içinde ara: firma adı, kişi adı, `@` işareti, telefon deseni,
`sk-` / `ghp_` gibi anahtar önekleri.

---

## Ne katkı verilebilir

- **Yeni profil** (`profiller/<rol>/CLAUDE.md` + `iskelet/<rol>/` + `istemler/<rol>.md` +
  `sablonlar/<rol>/`) — dördü birlikte gelmeli, yarım profil kurulumu bozar.
- **Yeni şablon** — boş kalıp, doldurulmuş belge değil.
- **Yeni istem kartı** — "ne işe yarar" + kopyalanabilir istem metni biçiminde.
- **README düzeltmesi** — özellikle bir kurulumda tökezlenen bir adım varsa.
  Tökezleme `KURULUM-KONTROL.md`'ye not düşülür, sonra README'ye yansır.

---

## Yapı kuralları

1. **Ortak kural tek yerde durur.** Her profilde geçerli bir kural `profiller/_ortak.md`
   dosyasına yazılır; profil dosyalarına **kopyalanmaz.** Profil dosyası yalnız
   role özgü kuralı taşır ve çekirdeğe atıf yapar.
2. **README uygulanabilir kalmalı.** Her adım: ne yapılacak + **nasıl doğrulanacak.**
   "Gerekirse ayarlayın" gibi belirsiz cümle yazma — kurulum orada kırılır.
3. Her role özel iskelet **tam 2 klasör** ekler (ortak 5 + role özel 2 = 7).
   Doğrulama sorusu ("kaç klasör var" → 7) buna dayanır; değiştirirsen README'yi de değiştir.
4. Dosyalar **UTF-8**, dosya adlarında Türkçe karakter yok (ı→i, ş→s, ğ→g, ç→c, ö→o, ü→u).
5. Metin dili **Türkçe.**

---

## Değişiklik önerirken

Değişikliğin **hangi kurulum deneyiminden** çıktığını tek cümleyle yaz. Bu depo teoriden
değil, gerçek kurulumlardan büyür.

---

## Kendi kurulumunda geliştirdiğin bir şeyi depoya taşımak

Bu deponun kaynağı, **bakımını yapan kişinin kendi `~/.claude` kurulumudur.** Orada bir kural,
bir alışkanlık ya da bir betik olgunlaşınca depoya süzülür. Elle kopyalama değil, **süzme**:
her şey genel değildir.

### Neyin genel olduğuna karar verme tablosu

| Kaynak | Depoya girer mi | Neden |
|---|---|---|
| Davranış kuralı ("testi koşmadan iş bitmez", "boru hattı çıkış kodunu maskeler") | ✅ **evet** — `profiller/_ortak.md` ya da ilgili profil | Kişiden bağımsız, herkeste aynı işe yarar |
| İzin listesi girdisi (yeni bir komutun `allow`/`deny` karşılığı) | ✅ evet — `ayarlar/settings-sablon.json` ya da profil ek katmanı | Aynı sorun herkeste çıkar |
| Yeni bir araç betiği (genel amaçlı) | ✅ evet — `araclar/` | Tek makineye özel değilse |
| Şablon / istem kartı | ✅ evet | Boş kalıp olmak şartıyla |
| **Kişisel hafıza notları** (`memory/*.md`) | ⛔ **asla** | Kişinin kendi bilgisi; çoğu kez kurum/kişi adı taşır |
| **Künye tablosu** (rol, kurum, kasa yolu) | ⛔ asla | Kişiye özel; kurulumda röportajla dolar |
| İş takip dosyaları (gol/pas, kokpit, plan durumu) | ⛔ asla | Bir ekibin iç işleyişi; depo kullanıcısını ilgilendirmez |
| Firma/müşteri adı geçen her satır | ⛔ asla | Depo public olabilir (yukarıdaki tablo) |
| Tek makineye özel yollar (`C:\Repos\...`) | ⛔ asla | `[DEPO YOLU]` gibi yer tutucuya çevir |

### Sıra

1. **Ayıkla:** kuralı kendi dosyandan al, kişiye/kuruma ait her izi çıkar, örnekleri anonimleştir.
2. **Doğru katmana koy:** her profilde geçerliyse `_ortak.md`, tek role özgüyse profil dosyası.
   Aynı kuralı iki yere yazma — ikincisi bayatlar.
3. **`DEGISIKLIKLER.md`'ye satır ekle** ve `SURUM` dosyasını yükselt
   (davranış değişiyorsa ikinci hane, yalnız düzeltmeyse üçüncü hane).
4. **Kendi makinende dene:** sahte bir kurulum dizini aç ve
   `araclar\kur.ps1 -Guncelle -HedefDizin <sahte-dizin> -KuruKosu` koş — gerçek kurulumunu
   bozmadan ne değişeceğini görürsün.
5. Commit + push. Ekipteki herkes `git pull` + `kur.ps1 -Guncelle` ile aynı sürüme gelir.

⚠️ **Depoya yazıp kendi kurulumunu güncellemeyi unutma** (ya da tersi): iki taraf ayrışırsa
"bende çalışıyor" sınıfı hatalar başlar. `kurulum-dogrula.ps1` sürüm karşılaştırmasıyla bunu
söyler.
