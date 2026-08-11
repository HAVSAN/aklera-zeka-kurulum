# belge-hatti-kontrol.ps1 - Belge cikti hattinin GERCEKTEN calistigini olcer.
#
# Ne yapar: her katman icin ornek bir belgeyi gercekten uretir ve ciktinin icinde
# Turkce denetim dizesini arar. "Kurulu gorunuyor" demez - URETIR ve BAKAR.
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File belge-hatti-kontrol.ps1
#   powershell -ExecutionPolicy Bypass -File belge-hatti-kontrol.ps1 -CiktiDizin "C:\Kontrol" -Ayrintili
#
# Cikis kodu:
#   0 = en az Katman 0 calisiyor, kurulu olan hicbir katman bozuk degil
#   1 = kurulu bir katman CALISMIYOR ya da hicbir katman calismiyor
# Kurulu OLMAYAN katman hata degildir - "atlandi" diye raporlanir.
# Bu dosya bilerek ASCII yazilmistir.

[CmdletBinding()]
param(
  [string]$CiktiDizin,
  [switch]$Ayrintili
)

$eskiTercih = $ErrorActionPreference
$ErrorActionPreference = "Continue"

# Konsol Turkce karakterleri bozuk basmasin (Windows varsayilan kod sayfasi 857/437).
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

# Turkce denetim dizesi (betik ASCII kalsin diye kod noktalarindan uretilir): igusoc
$TR = -join ([int[]](0x0131, 0x011F, 0x00FC, 0x015F, 0x00F6, 0x00E7) | ForEach-Object { [char]$_ })

$betikDizin = $PSScriptRoot
$ornekMd = Join-Path $betikDizin "ornek\ornek-belge.md"
$ornekAtifliMd = Join-Path $betikDizin "ornek\ornek-atifli.md"
$bibYolu = Join-Path $betikDizin "..\..\sablonlar\akademisyen\latex\kaynakca.bib"
$texYolu = Join-Path $betikDizin "..\..\sablonlar\akademisyen\latex\makale.tex"

if (-not $CiktiDizin) { $CiktiDizin = Join-Path $env:TEMP ("belge-hatti-kontrol-" + (Get-Date -Format "yyyyMMdd-HHmmss")) }
if (-not (Test-Path -LiteralPath $CiktiDizin)) { New-Item -ItemType Directory -Path $CiktiDizin -Force | Out-Null }
$CiktiDizin = (Resolve-Path -LiteralPath $CiktiDizin).Path

$sonuclar = @()
function Sonuc($katman, $durum, $not) {
  $script:sonuclar += [pscustomobject]@{ Katman = $katman; Durum = $durum; Not = $not }
  $renk = switch ($durum) { "CALISIYOR" { "Green" } "ATLANDI" { "DarkGray" } default { "Red" } }
  Write-Host ("  [{0,-9}] {1} - {2}" -f $durum, $katman, $not) -ForegroundColor $renk
}

function AraclarBul($ad, $adaylar) {
  $k = Get-Command $ad -ErrorAction SilentlyContinue
  if ($k) { return $k.Source }
  foreach ($a in $adaylar) { if ($a -and (Test-Path -LiteralPath $a)) { return $a } }
  return $null
}

Write-Host ""
Write-Host "BELGE CIKTI HATTI - KONTROL" -ForegroundColor Cyan
Write-Host "Cikti klasoru: $CiktiDizin"
Write-Host ""

# on kosul: ornek dosyalar yerinde mi
foreach ($d in @($ornekMd, $ornekAtifliMd)) {
  if (-not (Test-Path -LiteralPath $d)) {
    Write-Host "HATA: ornek dosya eksik: $d" -ForegroundColor Red
    Write-Host "Depo tam kopyalanmamis olabilir. 'araclar\belge\ornek\' klasorunu kontrol et."
    exit 1
  }
}

# ---------------------------------------------------------------- KATMAN 0
Write-Host "Katman 0 - tarayici ile PDF (kurulum gerektirmez)" -ForegroundColor White
$tarayici = AraclarBul "msedge" @(
  (Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe"),
  (Join-Path $env:ProgramFiles "Microsoft\Edge\Application\msedge.exe"),
  (Join-Path $env:ProgramFiles "Google\Chrome\Application\chrome.exe"),
  (Join-Path ${env:ProgramFiles(x86)} "Google\Chrome\Application\chrome.exe")
)
if (-not $tarayici) {
  Sonuc "Katman 0 (PDF)" "BOZUK" "Edge/Chrome bulunamadi - PDF uretilemez. Edge kurulu olmali."
} else {
  $pdf0 = Join-Path $CiktiDizin "kontrol-katman0.pdf"
  $cikti = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $betikDizin "md2pdf.ps1") `
             -Girdi $ornekMd -Cikti $pdf0 -HtmlKalsin 2>&1
  if ($Ayrintili) { $cikti | ForEach-Object { Write-Host "      $_" -ForegroundColor DarkGray } }
  $html0 = [System.IO.Path]::ChangeExtension($pdf0, ".html")
  $trTamam = $false
  if (Test-Path -LiteralPath $html0) {
    $icerik = [System.IO.File]::ReadAllText($html0, [System.Text.Encoding]::UTF8)
    $trTamam = $icerik.Contains($TR)
  }
  if (-not (Test-Path -LiteralPath $pdf0)) {
    Sonuc "Katman 0 (PDF)" "BOZUK" "PDF uretilemedi. Ayrinti icin: -Ayrintili ile tekrar calistir."
  } elseif ((Get-Item -LiteralPath $pdf0).Length -lt 1000) {
    Sonuc "Katman 0 (PDF)" "BOZUK" "PDF olustu ama bos gorunuyor."
  } elseif (-not $trTamam) {
    Sonuc "Katman 0 (PDF)" "BOZUK" "PDF uretildi ama Turkce denetim dizesi ara HTML'de yok - kodlama bozuk."
  } else {
    Sonuc "Katman 0 (PDF)" "CALISIYOR" ("PDF uretildi + Turkce saglam: " + (Split-Path -Leaf $pdf0))
  }
}

# ---------------------------------------------------------------- KATMAN 1
Write-Host ""
Write-Host "Katman 1 - Pandoc ile Word/LaTeX kaynagi" -ForegroundColor White
$pandoc = AraclarBul "pandoc" @(
  (Join-Path $env:LOCALAPPDATA "Programs\Pandoc\pandoc.exe"),
  (Join-Path $env:ProgramFiles "Pandoc\pandoc.exe")
)
if (-not $pandoc) {
  Sonuc "Katman 1 (Word)" "ATLANDI" "Pandoc kurulu degil. Kurmak icin: winget install --id JohnMacFarlane.Pandoc"
} else {
  $docx = Join-Path $CiktiDizin "kontrol-katman1.docx"
  $argv = @("-Girdi", $ornekAtifliMd, "-Cikti", $docx)
  if (Test-Path -LiteralPath $bibYolu) { $argv += @("-Kaynakca", (Resolve-Path -LiteralPath $bibYolu).Path) }
  $cikti = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $betikDizin "md2docx.ps1") @argv 2>&1
  if ($Ayrintili) { $cikti | ForEach-Object { Write-Host "      $_" -ForegroundColor DarkGray } }

  if (-not (Test-Path -LiteralPath $docx)) {
    Sonuc "Katman 1 (Word)" "BOZUK" "Pandoc kurulu ama .docx uretilemedi. -Ayrintili ile tekrar calistir."
  } else {
    # docx bir zip'tir: icindeki metni acip denetim dizesini ve kaynakcayi ara
    $ac = Join-Path $CiktiDizin "docx-ic"
    if (Test-Path -LiteralPath $ac) { Remove-Item -LiteralPath $ac -Recurse -Force }
    $zip = Join-Path $CiktiDizin "kontrol-katman1.zip"
    Copy-Item -LiteralPath $docx -Destination $zip -Force
    try { Expand-Archive -LiteralPath $zip -DestinationPath $ac -Force } catch { }
    $belgeXml = Join-Path $ac "word\document.xml"
    if (-not (Test-Path -LiteralPath $belgeXml)) {
      Sonuc "Katman 1 (Word)" "BOZUK" ".docx acilamadi - dosya bozuk olabilir."
    } else {
      $xml = [System.IO.File]::ReadAllText($belgeXml, [System.Text.Encoding]::UTF8)
      $trVar = $xml.Contains($TR)
      $kaynakcaVar = $xml -match "2024"      # citeproc kaynakcayi yazdiysa yil gorunur
      if (-not $trVar) {
        Sonuc "Katman 1 (Word)" "BOZUK" ".docx uretildi ama Turkce denetim dizesi icinde yok."
      } elseif ((Test-Path -LiteralPath $bibYolu) -and -not $kaynakcaVar) {
        Sonuc "Katman 1 (Word)" "BOZUK" ".docx uretildi ama kaynakca cozulmemis (--citeproc calismadi)."
      } else {
        Sonuc "Katman 1 (Word)" "CALISIYOR" ("Word + otomatik kaynakca uretildi: " + (Split-Path -Leaf $docx))
      }
    }
    Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  }

  # .tex kaynagi ayrica denenir (LaTeX kurulumu GEREKMEZ)
  $tex = Join-Path $CiktiDizin "kontrol-katman1.tex"
  $cikti2 = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $betikDizin "md2tex.ps1") `
              -Girdi $ornekMd -Cikti $tex 2>&1
  if ($Ayrintili) { $cikti2 | ForEach-Object { Write-Host "      $_" -ForegroundColor DarkGray } }
  if (Test-Path -LiteralPath $tex) {
    Sonuc "Katman 1 (.tex)" "CALISIYOR" "LaTeX kaynagi uretildi (derlemek icin Katman 2 gerekir)."
  } else {
    Sonuc "Katman 1 (.tex)" "BOZUK" "Pandoc kurulu ama .tex uretilemedi."
  }
}

# ---------------------------------------------------------------- KATMAN 2
Write-Host ""
Write-Host "Katman 2 - Tectonic ile LaTeX derlemesi" -ForegroundColor White
$tectonic = AraclarBul "tectonic" @(
  (Join-Path $env:LOCALAPPDATA "Programs\Tectonic\tectonic.exe"),
  (Join-Path $env:ProgramFiles "Tectonic\tectonic.exe")
)
if (-not $tectonic) {
  Sonuc "Katman 2 (LaTeX)" "ATLANDI" "Tectonic kurulu degil. Kurmak icin: araclar\belge\tectonic-kur.ps1"
} elseif (-not (Test-Path -LiteralPath $texYolu)) {
  Sonuc "Katman 2 (LaTeX)" "BOZUK" "Ornek sablon bulunamadi: sablonlar\akademisyen\latex\makale.tex"
} else {
  $texDizin = Join-Path $CiktiDizin "latex"
  if (-not (Test-Path -LiteralPath $texDizin)) { New-Item -ItemType Directory -Path $texDizin -Force | Out-Null }
  Copy-Item -LiteralPath (Resolve-Path -LiteralPath $texYolu).Path -Destination $texDizin -Force
  $hedefTex = Join-Path $texDizin "makale.tex"
  $cikti3 = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $betikDizin "tex2pdf.ps1") `
              -Girdi $hedefTex 2>&1
  if ($Ayrintili) { $cikti3 | ForEach-Object { Write-Host "      $_" -ForegroundColor DarkGray } }
  $pdf2 = Join-Path $texDizin "makale.pdf"
  if (-not (Test-Path -LiteralPath $pdf2)) {
    Sonuc "Katman 2 (LaTeX)" "BOZUK" "Tectonic kurulu ama derleme basarisiz. -Ayrintili ile tekrar calistir."
  } elseif ((Get-Item -LiteralPath $pdf2).Length -lt 1000) {
    Sonuc "Katman 2 (LaTeX)" "BOZUK" "PDF olustu ama bos gorunuyor."
  } else {
    Sonuc "Katman 2 (LaTeX)" "CALISIYOR" ("makale.tex derlendi: " + (Split-Path -Leaf $pdf2))
  }
}

# ---------------------------------------------------------------- ozet
Write-Host ""
Write-Host "OZET" -ForegroundColor Cyan
$bozuk = @($sonuclar | Where-Object { $_.Durum -eq "BOZUK" })
$calisan = @($sonuclar | Where-Object { $_.Durum -eq "CALISIYOR" })
Write-Host ("  calisan: {0}   bozuk: {1}   atlanan: {2}" -f $calisan.Count, $bozuk.Count,
  @($sonuclar | Where-Object { $_.Durum -eq "ATLANDI" }).Count)
Write-Host "  Uretilen dosyalar: $CiktiDizin"
Write-Host ""

$ErrorActionPreference = $eskiTercih

if ($bozuk.Count -gt 0) {
  Write-Host "SONUC: hatta BOZUK katman var - yukaridaki notlari oku." -ForegroundColor Red
  Write-Host "Gozle dogrulama: uretilen PDF'i ac ve su satiri ara:" -ForegroundColor Yellow
  Write-Host ("  DENETIM: " + $TR)
  exit 1
}
if ($calisan.Count -eq 0) {
  Write-Host "SONUC: hicbir katman calismiyor." -ForegroundColor Red
  exit 1
}
Write-Host "SONUC: belge hatti calisiyor." -ForegroundColor Green
Write-Host "Son adim SENDE: uretilen PDF'i ac ve su satirin bozulmadigini GOZLE gor:" -ForegroundColor Yellow
Write-Host ("  DENETIM: " + $TR)
exit 0
