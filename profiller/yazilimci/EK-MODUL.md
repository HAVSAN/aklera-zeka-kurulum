# Ek Rol — Yazılım Geliştiren

> Bu dosya **ana profil değildir.** Kullanıcının asıl rolü başkadır (akademisyen, İSG ya da
> ofis); kod yazmak **ikinci işidir** — analiz betiği, küçük araç, kişisel proje.
> Kurulumda `<KASA>\EK-ROL.md` adıyla durur.
>
> Ana `CLAUDE.md` ve `CEKIRDEK.md` aynen geçerlidir. Çelişki olursa **ana profil kazanır**;
> yalnız aşağıdaki dört konuda bu dosya öne geçer.

---

## Ne eklenir

| Eklenen | Ne için |
|---|---|
| `Projeler\<proje>\` klasörü | Proje künyesi, kararlar, yapılacaklar (kod kendi deposunda) |
| `Notlar\` klasörü | Projeden bağımsız teknik notlar ve araştırma sonuçları |
| `Sablonlar\karar-notu.md`, `proje-kunyesi.md` | Karar ve künye kalıpları |

İstem kartları: `istemler\yazilimci.md`.

---

## Bu ek rolde geçerli dört kural

1. **"Çalışıyor" demeden önce çalıştır.** Test/komut çıktısını boruya sokma, **çıkış kodunu**
   ayrıca kontrol et: "hepsi geçti" yazarken süreç hata koduyla dönebilir.
2. **Sır koda girmez.** Parola, API anahtarı, bağlantı dizesi `.env` dosyasında durur ve
   `.gitignore`'a eklenir. Bir sır gördüğünde uyar. ⚠️ **Kod deposu bu kasanın içine konmaz** —
   kasa notu ve kararı tutar, kod kendi git deposunda yaşar.
3. **`git add` daima yol bazlı** (`-A` / `.` kullanma). Ana dalda doğrudan çalışma, dal aç.
   **Commit ve push kullanıcı istemeden yapılmaz.**
4. **Karar üç ay sonrası için yazılır:** `bağlam · seçilen yol · elenen alternatif · sonuç`.
   Bir projeye aitse `Projeler\<proje>\kararlar.md`, projeden bağımsızsa `Notlar\` altına.
   Elenen alternatifleri **uydurma** — kullanıcı söylemediyse `[DOLDURULACAK: ...]` bırak.

---

## Ana rolle kesişme

Ana rolün "bu senin işin değil" listesi aynen geçerlidir. Buna ek olarak: **production'a
deploy**, zorlamalı git işlemleri (`push --force`, geçmiş yeniden yazma), veri/şema silme
ve büyük sürüm atlatan bağımlılık yükseltmesi senin işin değildir.
