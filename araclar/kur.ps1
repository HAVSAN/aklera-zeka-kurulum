# kur.ps1 -- kurulu bir HAVSAN/AKLERA zeka kurulumunu DEPODAKI surume tazeler.
#
# NEDEN VAR: "ben kendimde bir gelistirme yaptim, ekibe nasil verecegim?" sorusunun cevabi.
# Once yalniz `git pull` + README adimlarini elle tekrarlamak vardi; bu (a) kimin hangi
# surumde oldugunu soyleyemiyordu, (b) kullanicinin kendi ekledigi satirlari eziyordu.
#
# TASARIM (talep-cek.mjs icindeki icerikBirlestir deseni):
#   makine uretimi bolum = DEPO (tek dogruluk kaynagi)   ->  her guncellemede yenilenir
#   insan yazimi bolum   = KULLANICI                     ->  aynen korunur
#
# Korunanlar:
#   1. "Kullanici Kunyesi" bolumu (tanisma roportajinin doldurdugu tablo)
#   2. HAVSAN blogunun DISINDA yazilmis her sey (KENDI-EKLERIN blogu)
#   3. settings.json icindeki mevcut allow/deny girdileri (birlestirilir, ezilmez)
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File araclar\kur.ps1 -Guncelle
#   powershell -ExecutionPolicy Bypass -File araclar\kur.ps1 -Guncelle -KuruKosu
#   powershell -ExecutionPolicy Bypass -File araclar\kur.ps1 -Guncelle -Profil yazilimci
#
# Cikis kodu: 0 = tamam, 1 = hata (hicbir dosya degismedi).

[CmdletBinding()]
param(
    # Kurulu dosyalari depodaki surume tazeler. Su an tek eylem; ilk kurulum README ile yapilir.
    [switch]$Guncelle,

    # Profil adi. Verilmezse kurulu dosyadaki HAVSAN marker'indan okunur.
    [string]$Profil = "",

    # Ikinci rol (EK-MODUL.md). Verilmezse marker'dan okunur.
    [string]$EkRol = "",

    # Hicbir dosyaya yazmaz; ne degisecegini yazdirir.
    [switch]$KuruKosu,

    # Hedef ayar dizini. Varsayilan: %USERPROFILE%\.claude
    # Sahte bir kurulum uzerinde deneme yapmak icin baska bir dizine yonlendirilir
    # (kanit koserken gercek kurulumu bozmamak icin sart).
    [string]$HedefDizin = ""
)

$ErrorActionPreference = "Stop"

$DepoKok = Split-Path -Parent $PSScriptRoot
$SurumDosyasi = Join-Path $DepoKok "SURUM"
$ProfillerDizin = Join-Path $DepoKok "profiller"
$AyarSablon = Join-Path $DepoKok "ayarlar\settings-sablon.json"
$AyarYazilimciEk = Join-Path $DepoKok "ayarlar\settings-yazilimci-ek.json"

$ClaudeDizin = if ($HedefDizin -ne "") { $HedefDizin } else { Join-Path $env:USERPROFILE ".claude" }
$KuralDosyasi = Join-Path $ClaudeDizin "CLAUDE.md"
$AyarDosyasi = Join-Path $ClaudeDizin "settings.json"

$MarkerBas = "<!-- HAVSAN-KURULUM:BASLANGIC"
$MarkerBit = "<!-- HAVSAN-KURULUM:BITIS -->"
$EkBas = "<!-- KENDI-EKLERIN:BASLANGIC (bu satirin altindaki her sey guncellemede KORUNUR) -->"
$EkBit = "<!-- KENDI-EKLERIN:BITIS -->"

$script:Degisen = @()
$script:Uyari = @()

function Bilgi { param([string]$m) Write-Host $m }
function Basarili { param([string]$m) Write-Host $m -ForegroundColor Green }
function Dikkat { param([string]$m) Write-Host $m -ForegroundColor Yellow; $script:Uyari += $m }
function Hata { param([string]$m) Write-Host $m -ForegroundColor Red }

function Oku-Metin {
    param([string]$Yol)
    return [System.IO.File]::ReadAllText($Yol, [System.Text.Encoding]::UTF8)
}

function Yaz-Metin {
    param([string]$Yol, [string]$Icerik)
    # BOM'suz UTF-8: BOM'lu dosya bazi araclarda ilk satiri bozuk gosteriyor.
    $kodlama = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Yol, $Icerik, $kodlama)
}

function Satir-Sonu-Esitle {
    # Karma satir sonu diff'i sisirir: yeni metni eski dosyanin bicimine cevirir.
    param([string]$Metin, [bool]$Crlf)
    $lf = $Metin -replace "`r`n", "`n"
    if ($Crlf) { return ($lf -replace "`n", "`r`n") }
    return $lf
}

function Kunye-Cikar {
    # "## 10. Kullanici Kunyesi" basligindan bir sonraki '---' ya da '## ' satirina kadar.
    # Turkce karakter yerine '.' kullanilir -- bu betik ASCII kalmali.
    param([string]$Metin)
    $satirlar = $Metin -split "`r?`n"
    $bas = -1
    for ($i = 0; $i -lt $satirlar.Count; $i++) {
        if ($satirlar[$i] -match '^#{1,3}\s+\d*\.?\s*Kullan.c.\s+K.nyesi') { $bas = $i; break }
    }
    if ($bas -lt 0) { return "" }
    $son = $satirlar.Count
    for ($j = $bas + 1; $j -lt $satirlar.Count; $j++) {
        if ($satirlar[$j] -match '^---\s*$' -or $satirlar[$j] -match '^#{1,3}\s') { $son = $j; break }
    }
    return (($satirlar[$bas..($son - 1)]) -join "`n")
}

function Kunye-Degistir {
    param([string]$Metin, [string]$YeniKunye)
    if ($YeniKunye -eq "") { return $Metin }
    $satirlar = $Metin -split "`r?`n"
    $bas = -1
    for ($i = 0; $i -lt $satirlar.Count; $i++) {
        if ($satirlar[$i] -match '^#{1,3}\s+\d*\.?\s*Kullan.c.\s+K.nyesi') { $bas = $i; break }
    }
    if ($bas -lt 0) { return $Metin }
    $son = $satirlar.Count
    for ($j = $bas + 1; $j -lt $satirlar.Count; $j++) {
        if ($satirlar[$j] -match '^---\s*$' -or $satirlar[$j] -match '^#{1,3}\s') { $son = $j; break }
    }
    $once = if ($bas -gt 0) { ($satirlar[0..($bas - 1)] -join "`n") + "`n" } else { "" }
    $sonra = if ($son -lt $satirlar.Count) { "`n" + ($satirlar[$son..($satirlar.Count - 1)] -join "`n") } else { "" }
    return $once + $YeniKunye + $sonra
}

function Blok-Cikar {
    # Iki marker arasindaki metni dondurur (marker'lar HARIC). Yoksa bos dizge.
    param([string]$Metin, [string]$BasIz, [string]$BitIz)
    $b = $Metin.IndexOf($BasIz)
    if ($b -lt 0) { return "" }
    $satirSonu = $Metin.IndexOf("`n", $b)
    if ($satirSonu -lt 0) { return "" }
    $s = $Metin.IndexOf($BitIz, $satirSonu)
    if ($s -lt 0) { return "" }
    return $Metin.Substring($satirSonu + 1, $s - $satirSonu - 1)
}

function Marker-Alan-Oku {
    # "<!-- HAVSAN-KURULUM:BASLANGIC surum=1.1.0 profil=yazilimci ekrol=genel -->" -> deger
    param([string]$Metin, [string]$Alan)
    $desen = "HAVSAN-KURULUM:BASLANGIC[^>]*" + $Alan + "=([^\s>]+)"
    $m = [regex]::Match($Metin, $desen)
    if ($m.Success) { return $m.Groups[1].Value }
    return ""
}

function Ust-Basliklar {
    param([string]$Metin)
    $ad = @()
    foreach ($s in ($Metin -split "`r?`n")) {
        if ($s -match '^##\s+(.+?)\s*$') { $ad += ($matches[1].ToLower() -replace '[^a-z0-9]', '') }
    }
    return $ad
}

function Yabanci-Bolumler {
    # Eski dosyada olup yeni blokta OLMAYAN '## ' bolumleri -- silinmez, korunur.
    param([string]$Eski, [string]$Yeni)
    $yeniAdlar = Ust-Basliklar $Yeni
    $satirlar = $Eski -split "`r?`n"
    $cikti = @()
    $topluyor = $false
    foreach ($s in $satirlar) {
        if ($s -match '^##\s+(.+?)\s*$') {
            $ad = ($matches[1].ToLower() -replace '[^a-z0-9]', '')
            $topluyor = (-not ($yeniAdlar -contains $ad))
            if ($topluyor) { $cikti += $s }
            continue
        }
        if ($topluyor) { $cikti += $s }
    }
    return ($cikti -join "`n").Trim()
}

# ---------------------------------------------------------------- baslangic denetimleri

if (-not $Guncelle) {
    Hata "Bir eylem verilmedi. Kullanim: kur.ps1 -Guncelle [-KuruKosu] [-Profil <ad>]"
    Bilgi "Ilk kurulum bu betikle YAPILMAZ -- README'yi izleyen Claude yapar (Adim 0-7)."
    exit 1
}

if (-not (Test-Path $SurumDosyasi)) {
    Hata ("SURUM dosyasi yok: " + $SurumDosyasi + " -- depo bozuk ya da eski.")
    exit 1
}
$DepoSurum = (Oku-Metin $SurumDosyasi).Trim()

if (-not (Test-Path $KuralDosyasi)) {
    Hata ("Kurulu kural dosyasi yok: " + $KuralDosyasi)
    Bilgi "Bu makinede henuz kurulum yok. Once README ile ilk kurulumu yaptir, sonra -Guncelle kos."
    exit 1
}

$Eski = Oku-Metin $KuralDosyasi
$Crlf = ($Eski -match "`r`n")
$KuruluSurum = Marker-Alan-Oku $Eski "surum"
$Benimseme = ($KuruluSurum -eq "")

if ($Profil -eq "") { $Profil = Marker-Alan-Oku $Eski "profil" }
if ($EkRol -eq "") { $EkRol = Marker-Alan-Oku $Eski "ekrol" }

Write-Host ""
Write-Host "=== HAVSAN ZEKA KURULUMU -- GUNCELLEME ===" -ForegroundColor Cyan
Bilgi ("Hedef dizin   : " + $ClaudeDizin + $(if ($HedefDizin -ne "") { "   (DENEME -- gercek kurulum degil)" } else { "" }))
Bilgi ("Depo surumu   : " + $DepoSurum)
Bilgi ("Kurulu surum  : " + $(if ($Benimseme) { "(marker yok -- BENIMSEME turu)" } else { $KuruluSurum }))
Bilgi ("Profil        : " + $(if ($Profil -eq "") { "(bilinmiyor)" } else { $Profil }))
if ($EkRol -ne "") { Bilgi ("Ek rol        : " + $EkRol) }
if ($KuruKosu) { Dikkat "KURU KOSU -- hicbir dosyaya yazilmayacak." }
Write-Host ""

if ($Profil -eq "") {
    Hata "Profil belirlenemedi. Ilk guncellemede elle ver: -Profil yazilimci|isg-uzmani|akademisyen|genel"
    exit 1
}

$ProfilDosyasi = Join-Path $ProfillerDizin ($Profil + "\CLAUDE.md")
$OrtakDosyasi = Join-Path $ProfillerDizin "_ortak.md"
foreach ($y in @($ProfilDosyasi, $OrtakDosyasi)) {
    if (-not (Test-Path $y)) { Hata ("Depoda bulunamadi: " + $y); exit 1 }
}

if ((-not $Benimseme) -and ($KuruluSurum -eq $DepoSurum)) {
    Basarili ("Zaten guncel (surum " + $DepoSurum + "). Yapilacak bir sey yok.")
    Bilgi "Yeni bir surum bekliyorsan once `git pull` kos."
    exit 0
}

# ---------------------------------------------------------------- 1) kural dosyasi

# Yeni HAVSAN blogu: cekirdek + profil (+ ek modul) -- README Adim 3.1 ile ayni sira.
$yeniBlok = (Oku-Metin $OrtakDosyasi).TrimEnd() + "`n`n---`n`n" + (Oku-Metin $ProfilDosyasi).TrimEnd()
if ($EkRol -ne "") {
    $ekDosya = Join-Path $ProfillerDizin ($EkRol + "\EK-MODUL.md")
    if (Test-Path $ekDosya) {
        $yeniBlok = $yeniBlok + "`n`n---`n`n" + (Oku-Metin $ekDosya).TrimEnd()
    } else {
        Dikkat ("Ek rol modulu bulunamadi, atlaniyor: " + $ekDosya)
    }
}
# Duz metin degistirme: yol icindeki ters bolu regex'te kacis karakteri oldugu icin -replace KULLANILMAZ.
$yeniBlok = $yeniBlok.Replace('[DEPO YOLU]', $DepoKok)

# KORUNAN 1: kunye (doldurulmus tablo) eski dosyadan alinir, sablonun yerine konur.
$eskiKunye = Kunye-Cikar $Eski
if ($eskiKunye -eq "") {
    Dikkat "Eski dosyada 'Kullanici Kunyesi' bolumu bulunamadi -- sablon hali yazilacak, yer tutucular ELLE doldurulmali."
} else {
    if ($eskiKunye -match '\[KURULUM:') {
        Dikkat "Kunye tablosunda doldurulmamis yer tutucu var (kurulum yarim kalmis olabilir) -- oldugu gibi korunuyor."
    }
    $yeniBlok = Kunye-Degistir $yeniBlok $eskiKunye
}

# KORUNAN 2: kullanicinin kendi ekleri.
$eskiEkler = Blok-Cikar $Eski $EkBas $EkBit
if ($Benimseme) {
    # Marker yok: eski dosyada olup yeni blokta olmayan bolumler kullanicinin eki sayilir.
    $yabanci = Yabanci-Bolumler $Eski $yeniBlok
    if ($yabanci -ne "") {
        Dikkat ("Benimseme: yeni blokta karsiligi olmayan " + (($yabanci -split "`r?`n" | Where-Object { $_ -match '^##\s' }).Count) + " bolum KENDI-EKLERIN'e tasindi (silinmedi).")
        if ($eskiEkler -eq "") { $eskiEkler = $yabanci } else { $eskiEkler = $eskiEkler.Trim() + "`n`n" + $yabanci }
    }
}

$markerSatiri = $MarkerBas + " surum=" + $DepoSurum + " profil=" + $Profil
if ($EkRol -ne "") { $markerSatiri = $markerSatiri + " ekrol=" + $EkRol }
$markerSatiri = $markerSatiri + " -->"

$yeni = $markerSatiri + "`n" + $yeniBlok.Trim() + "`n" + $MarkerBit + "`n`n" + $EkBas + "`n"
if ($eskiEkler.Trim() -ne "") { $yeni = $yeni + $eskiEkler.Trim() + "`n" }
$yeni = $yeni + $EkBit + "`n"
$yeni = Satir-Sonu-Esitle $yeni $Crlf

if ($yeni -eq $Eski) {
    Bilgi "CLAUDE.md: fark yok."
} else {
    $yedek = $KuralDosyasi + ".yedek-" + $(if ($Benimseme) { "benimseme" } else { $KuruluSurum })
    if ($KuruKosu) {
        Bilgi ("CLAUDE.md: GUNCELLENECEK  (yedek: " + $yedek + ")")
        Bilgi ("           eski " + ($Eski -split "`r?`n").Count + " satir -> yeni " + ($yeni -split "`r?`n").Count + " satir")
    } else {
        Copy-Item -Path $KuralDosyasi -Destination $yedek -Force
        Yaz-Metin $KuralDosyasi $yeni
        Basarili ("CLAUDE.md guncellendi  (yedek: " + (Split-Path -Leaf $yedek) + ")")
    }
    $script:Degisen += "CLAUDE.md"
}

# ---------------------------------------------------------------- 2) settings.json

function Ayar-Birlestir {
    param($Hedef, $Kaynak)
    # allow/deny BIRLESIR (mevcut girdiler korunur), defaultMode yoksa eklenir.
    if (-not $Hedef.permissions) {
        $Hedef | Add-Member -NotePropertyName permissions -NotePropertyValue (New-Object PSObject) -Force
    }
    $h = $Hedef.permissions
    $k = $Kaynak.permissions
    if ($k.defaultMode -and -not $h.defaultMode) {
        $h | Add-Member -NotePropertyName defaultMode -NotePropertyValue $k.defaultMode -Force
    }
    foreach ($alan in @("allow", "deny")) {
        $mevcut = @()
        if ($h.$alan) { $mevcut = @($h.$alan) }
        $gelen = @()
        if ($k.$alan) { $gelen = @($k.$alan) }
        $birlesik = @($mevcut)
        foreach ($g in $gelen) { if ($birlesik -notcontains $g) { $birlesik += $g } }
        $h | Add-Member -NotePropertyName $alan -NotePropertyValue $birlesik -Force
    }
    return $Hedef
}

if (-not (Test-Path $AyarSablon)) {
    Dikkat ("Ayar sablonu yok, atlaniyor: " + $AyarSablon)
} else {
    $sablon = (Oku-Metin $AyarSablon) | ConvertFrom-Json
    $hedef = $null
    $eskiAyarMetin = ""
    if (Test-Path $AyarDosyasi) {
        $eskiAyarMetin = Oku-Metin $AyarDosyasi
        try {
            $hedef = $eskiAyarMetin | ConvertFrom-Json
        } catch {
            Hata ("settings.json gecerli JSON degil -- ELLE duzeltilmeli, dokunulmadi: " + $AyarDosyasi)
            $hedef = $null
        }
    } else {
        $hedef = New-Object PSObject
    }

    if ($hedef -ne $null) {
        $onceAllow = 0; $onceDeny = 0
        if ($hedef.permissions) {
            if ($hedef.permissions.allow) { $onceAllow = @($hedef.permissions.allow).Count }
            if ($hedef.permissions.deny) { $onceDeny = @($hedef.permissions.deny).Count }
        }
        $hedef = Ayar-Birlestir $hedef $sablon
        if ($Profil -eq "yazilimci") {
            if (Test-Path $AyarYazilimciEk) {
                $ek = (Oku-Metin $AyarYazilimciEk) | ConvertFrom-Json
                $hedef = Ayar-Birlestir $hedef $ek
            } else {
                Dikkat ("Yazilimci ek katmani bulunamadi: " + $AyarYazilimciEk)
            }
        }
        $sonraAllow = @($hedef.permissions.allow).Count
        $sonraDeny = @($hedef.permissions.deny).Count
        $yeniAyarMetin = ($hedef | ConvertTo-Json -Depth 10)

        if ($yeniAyarMetin.Trim() -eq $eskiAyarMetin.Trim()) {
            Bilgi "settings.json: fark yok."
        } elseif ($KuruKosu) {
            Bilgi ("settings.json: GUNCELLENECEK  allow " + $onceAllow + " -> " + $sonraAllow + " , deny " + $onceDeny + " -> " + $sonraDeny)
        } else {
            if ($eskiAyarMetin -ne "") {
                Copy-Item -Path $AyarDosyasi -Destination ($AyarDosyasi + ".yedek") -Force
            }
            Yaz-Metin $AyarDosyasi $yeniAyarMetin
            Basarili ("settings.json guncellendi  allow " + $onceAllow + " -> " + $sonraAllow + " , deny " + $onceDeny + " -> " + $sonraDeny + "  (mevcut girdiler korundu)")
            $script:Degisen += "settings.json"
        }
    }
}

# ---------------------------------------------------------------- ozet

Write-Host ""
if ($KuruKosu) {
    Basarili ("KURU KOSU bitti -- hicbir dosya degismedi. Gerceklestirmek icin -KuruKosu'yu kaldir.")
} elseif ($script:Degisen.Count -eq 0) {
    Basarili ("Surum " + $DepoSurum + " -- degisen dosya yok, kendi ayarlarin korundu.")
} else {
    Basarili ("Surum " + $(if ($Benimseme) { "(benimseme)" } else { $KuruluSurum }) + " -> " + $DepoSurum + " , " + $script:Degisen.Count + " dosya guncellendi, kendi ayarlarin korundu.")
    Bilgi ("Guncellenenler: " + ($script:Degisen -join ", "))
    Bilgi "Degisiklikler oturum basinda okunur -- YENI bir sohbet ac."
}
if ($script:Uyari.Count -gt 0) {
    Write-Host ""
    Dikkat ("Uyari sayisi: " + $script:Uyari.Count + " -- yukaridaki satirlari oku.")
}
Write-Host ""
Bilgi "Kurulumun CALISTIGINI dogrula:  araclar\kurulum-dogrula.ps1 -Kasa <kasa-yolu>"
Write-Host ""

exit 0
