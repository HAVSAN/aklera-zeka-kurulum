# tectonic-kur.ps1 - LaTeX derleyicisini (Tectonic) kurar.
# KATMAN 2 - yalnizca gercek LaTeX derlemesi gerekiyorsa kurulur.
#
# NEDEN TECTONIC: MiKTeX/TeX Live 1-5 GB'lik dagitimlardir; Tectonic tek bir
# .exe dosyasidir (~25 MB) ve yalnizca belgenin ihtiyac duydugu TeX paketlerini
# ilk derlemede internetten ceker (~200-300 MB onbellek, kullanici klasorunde).
# XeTeX tabanlidir - Turkce icin dogru motor.
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File tectonic-kur.ps1
#   powershell -ExecutionPolicy Bypass -File tectonic-kur.ps1 -Surum "0.17.0"
#
# Kaldirmak icin: kurulum klasorunu sil + PATH'ten satiri cikar (asagida yazili).
# Bu dosya bilerek ASCII yazilmistir.

[CmdletBinding()]
param(
  [string]$Surum,
  [string]$Hedef = (Join-Path $env:LOCALAPPDATA "Programs\Tectonic"),
  [switch]$OnbellegiIsit
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Hata($mesaj) {
  Write-Host ""
  Write-Host "HATA: $mesaj" -ForegroundColor Red
  exit 1
}
function Adim($mesaj) { Write-Host "> $mesaj" -ForegroundColor Cyan }

$exeYolu = Join-Path $Hedef "tectonic.exe"
if (Test-Path -LiteralPath $exeYolu) {
  Adim "Tectonic zaten kurulu: $exeYolu"
  & $exeYolu --version
  exit 0
}

# --------------------------------------------------- surumu belirle
if (-not $Surum) {
  Adim "Son surum soruluyor (GitHub)..."
  try {
    $bilgi = Invoke-RestMethod -Uri "https://api.github.com/repos/tectonic-typesetting/tectonic/releases/latest" `
             -Headers @{ "User-Agent" = "kisisel-zeka-kurulumu" } -TimeoutSec 60
    $Surum = ($bilgi.tag_name -replace '^tectonic@', '')
  } catch {
    $Surum = "0.17.0"
    Write-Host "  GitHub'a ulasilamadi, bilinen surume dusuluyor: $Surum" -ForegroundColor Yellow
  }
}
Adim "Surum: $Surum"

$dosyaAdi = "tectonic-$Surum-x86_64-pc-windows-msvc.zip"
$adres = "https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%40$Surum/$dosyaAdi"
$gecici = Join-Path $env:TEMP $dosyaAdi

# --------------------------------------------------- indir
Adim "Indiriliyor (~25 MB): $adres"
try {
  $eskiIlerleme = $ProgressPreference
  $ProgressPreference = "SilentlyContinue"   # indirme cubugu PowerShell 5.1'de cok yavaslatir
  Invoke-WebRequest -Uri $adres -OutFile $gecici -UseBasicParsing -TimeoutSec 600
  $ProgressPreference = $eskiIlerleme
} catch {
  Hata @"
Indirme basarisiz: $($_.Exception.Message)
Elle kurulum:
  1) Su adresi tarayicida ac: https://github.com/tectonic-typesetting/tectonic/releases
  2) '$dosyaAdi' dosyasini indir.
  3) Icindeki tectonic.exe dosyasini su klasore koy: $Hedef
  4) Bu betigi tekrar calistir - kurulu oldugunu gorecek ve PATH'i ayarlayacaktir.
"@
}
if (-not (Test-Path -LiteralPath $gecici)) { Hata "Indirilen dosya bulunamadi: $gecici" }
$boyutMB = [math]::Round((Get-Item -LiteralPath $gecici).Length / 1MB, 1)
if ($boyutMB -lt 5) { Hata "Indirilen dosya beklenenden kucuk ($boyutMB MB) - indirme yarim kalmis olabilir." }

# --------------------------------------------------- ac
Adim "Aciliyor: $Hedef"
if (-not (Test-Path -LiteralPath $Hedef)) { New-Item -ItemType Directory -Path $Hedef -Force | Out-Null }
try {
  Expand-Archive -LiteralPath $gecici -DestinationPath $Hedef -Force
} catch {
  Hata "Zip acilamadi: $($_.Exception.Message)"
}
Remove-Item -LiteralPath $gecici -Force -ErrorAction SilentlyContinue

if (-not (Test-Path -LiteralPath $exeYolu)) {
  # bazi surumler alt klasore acilir
  $bulunan = Get-ChildItem -LiteralPath $Hedef -Recurse -Filter "tectonic.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($bulunan) { Move-Item -LiteralPath $bulunan.FullName -Destination $exeYolu -Force }
}
if (-not (Test-Path -LiteralPath $exeYolu)) { Hata "tectonic.exe zip icinde bulunamadi: $Hedef" }

# --------------------------------------------------- PATH'e ekle (kullanici duzeyinde)
$kullaniciPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($kullaniciPath -notlike "*$Hedef*") {
  Adim "PATH'e ekleniyor (yalniz bu kullanici icin)"
  $yeni = if ([string]::IsNullOrWhiteSpace($kullaniciPath)) { $Hedef } else { $kullaniciPath.TrimEnd(';') + ";" + $Hedef }
  [Environment]::SetEnvironmentVariable("Path", $yeni, "User")
  Write-Host "  Not: acik terminaller eski PATH'i tasir. Yeni terminal ac." -ForegroundColor Yellow
  Write-Host "  Geri almak icin: Ayarlar > Ortam Degiskenleri > Path > su satiri sil: $Hedef" -ForegroundColor DarkGray
}
$env:Path = $env:Path.TrimEnd(';') + ";" + $Hedef

# --------------------------------------------------- dogrula
Adim "Dogrulaniyor"
& $exeYolu --version
if ($LASTEXITCODE -ne 0) { Hata "tectonic.exe calisti ama hata dondurdu (cikis kodu $LASTEXITCODE)." }

if ($OnbellegiIsit) {
  Adim "TeX paket onbellegi isitiliyor (ilk derleme birkac dakika surebilir)"
  $ornek = Join-Path $PSScriptRoot "..\..\sablonlar\akademisyen\latex\makale.tex"
  if (Test-Path -LiteralPath $ornek) {
    $gecDizin = Join-Path $env:TEMP ("tectonic-isit-" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $gecDizin -Force | Out-Null
    Copy-Item -LiteralPath (Resolve-Path $ornek).Path -Destination $gecDizin
    & $exeYolu (Join-Path $gecDizin "makale.tex") --outdir $gecDizin
    if ($LASTEXITCODE -ne 0) { Write-Host "  Onbellek isitma derlemesi basarisiz oldu - yukaridaki mesaji oku." -ForegroundColor Yellow }
    Remove-Item -LiteralPath $gecDizin -Recurse -Force -ErrorAction SilentlyContinue
  }
}

Write-Host ""
Write-Host "Tectonic hazir: $exeYolu" -ForegroundColor Green
Write-Host "  Derleme:  powershell -File araclar\belge\tex2pdf.ps1 -Girdi makale.tex"
Write-Host "  Ilk derlemede TeX paketleri indirilir (bir kereye mahsus, birkac dakika)."
exit 0
