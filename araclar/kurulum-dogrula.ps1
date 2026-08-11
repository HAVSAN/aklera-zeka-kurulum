# kurulum-dogrula.ps1 -- kurulumun CALISIP calismadigini olcer.
#
# Bu betik "dosya yazildi mi" diye sormaz; sistemin o dosyayi OKUYACAGI konumda olup
# olmadigini olcer. 11.08.2026'daki ilk canli kurulumda dosyalarin hepsi yazilmisti ama
# hicbiri okunmuyordu (bkz. KURULUM-KONTROL.md -> B-03).
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File araclar\kurulum-dogrula.ps1 -Kasa C:\Ayse
#   powershell -ExecutionPolicy Bypass -File araclar\kurulum-dogrula.ps1 -Kasa C:\Ayse -EkRol
#
# Cikis kodu: 0 = yapisal on kosullar tamam, 1 = en az bir madde kaldi.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Kasa,

    # Adim 0b'de ikinci rol secildiyse klasor sayisi 6 yerine 8 beklenir.
    [switch]$EkRol,

    # Hafiza dizini otomatik bulunamazsa elle verilir.
    [string]$HafizaDizini = ""
)

$ErrorActionPreference = "Stop"
$script:Hata = 0
$script:Sira = 0

function Sonuc {
    param([string]$Baslik, [bool]$Gecti, [string]$Detay)
    $script:Sira++
    if ($Gecti) {
        Write-Host ("[{0}] GECTI   {1}" -f $script:Sira, $Baslik) -ForegroundColor Green
    } else {
        Write-Host ("[{0}] KALDI   {1}" -f $script:Sira, $Baslik) -ForegroundColor Red
        $script:Hata = 1
    }
    if ($Detay) { Write-Host ("           -> {0}" -f $Detay) -ForegroundColor DarkGray }
}

$Profil = $env:USERPROFILE
$ClaudeDizin = Join-Path $Profil ".claude"
$KuralDosyasi = Join-Path $ClaudeDizin "CLAUDE.md"
$AyarDosyasi = Join-Path $ClaudeDizin "settings.json"
$ProjelerDizin = Join-Path $ClaudeDizin "projects"

Write-Host ""
Write-Host "=== KURULUM DOGRULAMA ===" -ForegroundColor Cyan
Write-Host ("Kullanici : {0}" -f $env:USERNAME)
Write-Host ("Kasa      : {0}" -f $Kasa)
Write-Host ("Ayar koku : {0}" -f $ClaudeDizin)
Write-Host ""
Write-Host "--- A. Yapisal on kosullar (makine olcer) ---" -ForegroundColor Cyan

# 1 -- Kural dosyasi dogru yerde
$kuralVar = Test-Path $KuralDosyasi
Sonuc "Kural dosyasi kullanici dizininde" $kuralVar $KuralDosyasi

# 2 -- Kural dosyasi profil + kunye tasiyor
if ($kuralVar) {
    $kural = Get-Content $KuralDosyasi -Raw -Encoding UTF8
    $kunyeBasligi = ($kural -match "K.nyesi")
    $yerTutucuKaldi = ($kural -match "\[KURULUM:")
    Sonuc "Kullanici Kunyesi bolumu var" $kunyeBasligi "profil/kurum/tercih bu bolumde durur"
    Sonuc "Kunye yer tutuculari dolduruldu" ($kunyeBasligi -and -not $yerTutucuKaldi) "'[KURULUM: ...]' kalmamali"

    $cekirdekIzi = ($kural -match "Ortak .ekirdek" -or $kural -match "Sen kimsin")
    $profilIzi = ($kural -match "role .zg" -or $kural -match "Kiminle .al")
    Sonuc "Cekirdek + profil TEK dosyada birlesik" ($cekirdekIzi -and $profilIzi) "ayri CEKIRDEK.md otomatik yuklenmez"
} else {
    Sonuc "Kullanici Kunyesi bolumu var" $false "kural dosyasi yok"
    Sonuc "Kunye yer tutuculari dolduruldu" $false "kural dosyasi yok"
    Sonuc "Cekirdek + profil TEK dosyada birlesik" $false "kural dosyasi yok"
}

# 3 -- settings.json / oto mod
$ayarVar = Test-Path $AyarDosyasi
if ($ayarVar) {
    $ayarGecerli = $true
    $ayar = $null
    try {
        $ayar = Get-Content $AyarDosyasi -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        $ayarGecerli = $false
    }
    Sonuc "settings.json gecerli JSON" $ayarGecerli $AyarDosyasi

    if ($ayarGecerli -and $ayar.permissions) {
        # acceptEdits sablonun degeri; auto daha genis bir oto mod oldugu icin o da kabul edilir.
        # bypassPermissions KABUL EDILMEZ -- deny listesini de etkisiz birakir.
        $mod = $ayar.permissions.defaultMode
        Sonuc "Oto mod acik (defaultMode=acceptEdits)" ($mod -eq "acceptEdits" -or $mod -eq "auto") ("bulunan deger: " + $mod)

        $deny = @($ayar.permissions.deny)
        $silmeKapali = ($deny -join " ") -match "Remove-Item|rm:"
        Sonuc "Silme deny listesinde" $silmeKapali "oto mod silmeyi KAPSAMAZ"

        $allow = @($ayar.permissions.allow)
        Sonuc "Allow listesi dolu" ($allow.Count -ge 5) ("kural sayisi: " + $allow.Count)
    } else {
        Sonuc "Oto mod acik (defaultMode=acceptEdits)" $false "permissions bolumu yok"
        Sonuc "Silme deny listesinde" $false "permissions bolumu yok"
        Sonuc "Allow listesi dolu" $false "permissions bolumu yok"
    }
} else {
    Sonuc "settings.json gecerli JSON" $false ("bulunamadi: " + $AyarDosyasi)
    Sonuc "Oto mod acik (defaultMode=acceptEdits)" $false "ayar dosyasi yok"
    Sonuc "Silme deny listesinde" $false "ayar dosyasi yok"
    Sonuc "Allow listesi dolu" $false "ayar dosyasi yok"
}

# 4 -- Hafiza dizini (slug TAHMIN EDILMEZ, aranir)
$hafiza = ""
if ($HafizaDizini -ne "") {
    $hafiza = $HafizaDizini
} elseif (Test-Path $ProjelerDizin) {
    $adaylar = Get-ChildItem -Path $ProjelerDizin -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName "memory" } |
        Where-Object { Test-Path (Join-Path $_ "kullanici-profil.md") }
    if ($adaylar) { $hafiza = @($adaylar)[0] }
}

$hafizaVar = ($hafiza -ne "" -and (Test-Path $hafiza))
Sonuc "Hafiza dizini bulundu" $hafizaVar $(if ($hafizaVar) { $hafiza } else { "projects\<proje>\memory altinda kullanici-profil.md yok" })

if ($hafizaVar) {
    $beklenen = @("kullanici-profil.md", "calisilan-kurumlar.md", "ilk-oncelikler.md")
    $eksik = @()
    foreach ($d in $beklenen) {
        if (-not (Test-Path (Join-Path $hafiza $d))) { $eksik += $d }
    }
    Sonuc "Uc hafiza notu yazildi" ($eksik.Count -eq 0) $(if ($eksik.Count -gt 0) { "eksik: " + ($eksik -join ", ") } else { "" })

    $indeksYol = Join-Path $hafiza "MEMORY.md"
    if (Test-Path $indeksYol) {
        $indeks = Get-Content $indeksYol -Raw -Encoding UTF8
        $bagliSayi = 0
        foreach ($d in $beklenen) {
            $ad = [System.IO.Path]::GetFileNameWithoutExtension($d)
            if ($indeks -match [regex]::Escape($ad)) { $bagliSayi++ }
        }
        Sonuc "MEMORY.md uc nota da bagli" ($bagliSayi -eq 3) ("bagli not: " + $bagliSayi + "/3")
    } else {
        Sonuc "MEMORY.md uc nota da bagli" $false "MEMORY.md yok -- indekssiz not bulunamaz"
    }
} else {
    Sonuc "Uc hafiza notu yazildi" $false "hafiza dizini yok"
    Sonuc "MEMORY.md uc nota da bagli" $false "hafiza dizini yok"
}

# 5 -- Kasa yapisi
$kasaVar = Test-Path $Kasa
Sonuc "Kasa klasoru var" $kasaVar $Kasa

if ($kasaVar) {
    $beklenenKlasor = if ($EkRol) { 8 } else { 6 }
    $klasorler = @(Get-ChildItem -Path $Kasa -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch "^\." })
    Sonuc ("Kasada " + $beklenenKlasor + " klasor var") ($klasorler.Count -eq $beklenenKlasor) ("bulunan: " + $klasorler.Count + " -> " + (($klasorler | ForEach-Object { $_.Name }) -join ", "))

    $sablonDizin = Join-Path $Kasa "Sablonlar"
    $sablonDolu = $false
    if (Test-Path $sablonDizin) {
        $sablonDolu = (@(Get-ChildItem -Path $sablonDizin -File -Filter *.md -ErrorAction SilentlyContinue).Count -ge 2)
    }
    Sonuc "Sablonlar klasoru dolu" $sablonDolu "en az 2 sablon"

    # 6 -- REGRESYON KAPISI: eski hatanin geri gelmesini yakalar
    $sizanlar = @()
    foreach ($y in @("CEKIRDEK.md", "MEMORY.md", "EK-ROL.md")) {
        if (Test-Path (Join-Path $Kasa $y)) { $sizanlar += $y }
    }
    if (Test-Path (Join-Path $Kasa "memory")) { $sizanlar += "memory\" }
    Sonuc "Kasada kural/hafiza dosyasi YOK" ($sizanlar.Count -eq 0) $(if ($sizanlar.Count -gt 0) { "kasaya sizan: " + ($sizanlar -join ", ") + " -- bunlar kullanici dizinine ait" } else { "kasa yalniz icerik tasiyor" })

    $kopruYol = Join-Path $Kasa "CLAUDE.md"
    if (Test-Path $kopruYol) {
        $kopru = Get-Content $kopruYol -Raw -Encoding UTF8
        $kopruSade = ($kopru.Length -lt 3000)
        Sonuc "Kasadaki CLAUDE.md sadece kopru" $kopruSade ("boyut: " + $kopru.Length + " karakter -- kural dosyasi buraya KONMAZ")
    } else {
        Sonuc "Kasadaki CLAUDE.md sadece kopru" $false "kopru dosyasi yok"
    }
} else {
    Sonuc ("Kasada klasor sayisi") $false "kasa yok"
    Sonuc "Sablonlar klasoru dolu" $false "kasa yok"
    Sonuc "Kasada kural/hafiza dosyasi YOK" $false "kasa yok"
    Sonuc "Kasadaki CLAUDE.md sadece kopru" $false "kasa yok"
}

# --- B. Davranis testleri (makine kosamaz, operator kosar) ---
Write-Host ""
Write-Host "--- B. Davranis testleri -- ELLE kosulur, hepsi GECMELI ---" -ForegroundColor Cyan
Write-Host "Yukaridakiler yalniz ON KOSULDUR. Kurulumun calistigini bunlar kanitlar." -ForegroundColor Yellow
Write-Host ""
Write-Host "  (a) YENI sohbet ac, sor: 'beni taniyor musun?'"
Write-Host "      -> rolunu ve calistigi kurumlari saymali"
Write-Host "  (b) 'Sablonlarim nerede?'"
Write-Host ("      -> {0}\Sablonlar demeli" -f $Kasa)
Write-Host "  (c) 'Nasil cevap vermemi istiyorsun?'"
Write-Host "      -> calisma tercihini bilmeli (kisa/ayrintili, soru sorma tercihi)"
Write-Host "  (d) Kucuk bir is ver (ornek: bugunun gunluk dosyasina bir satir ekle)"
Write-Host "      -> ONCE sure tahmini, SONRA gerceklesen sure yazmali"
Write-Host "  (e) Bir dosyayi duzenlettir"
Write-Host "      -> izin sorusu CIKMAMALI"
Write-Host "  (f) Bir test dosyasini sildirmeye calis"
Write-Host "      -> izin sorusu CIKMALI (oto mod silmeyi kapsamaz)"
Write-Host "  (g) Kasanin bir ALT klasorunde sohbet ac, (a)'yi tekrarla"
Write-Host "      -> ayni sonuc gelmeli"
Write-Host ""
Write-Host "  Herhangi biri kalirsa kurulum BASARISIZ sayilir." -ForegroundColor Yellow
Write-Host "  Sonucu KURULUM-KONTROL.md dosyasina isle." -ForegroundColor Yellow
Write-Host ""

if ($script:Hata -eq 0) {
    Write-Host "YAPISAL ON KOSULLAR TAMAM -- simdi (a)-(g) testlerini kos." -ForegroundColor Green
} else {
    Write-Host "EN AZ BIR YAPISAL MADDE KALDI -- davranis testlerine gecme, once bunu duzelt." -ForegroundColor Red
}
Write-Host ""

exit $script:Hata
