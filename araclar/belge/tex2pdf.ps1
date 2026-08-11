# tex2pdf.ps1 - LaTeX (.tex) kaynagini PDF'e derler.
# KATMAN 2: Tectonic gerektirir (kurulum: tectonic-kur.ps1).
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File tex2pdf.ps1 -Girdi "makale.tex"
#   powershell -ExecutionPolicy Bypass -File tex2pdf.ps1 -Girdi "makale.tex" -CiktiDizin "C:\Cikti" -LogTut
#
# NOT: ilk derleme TeX paketlerini internetten ceker (birkac dakika surebilir,
# bir kereye mahsustur). Sonraki derlemeler saniyeler surer.
# Bu dosya bilerek ASCII yazilmistir; belgenin icerigi Turkce olabilir.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Girdi,
  [string]$CiktiDizin,
  [switch]$LogTut
)

$ErrorActionPreference = "Stop"

function Hata($mesaj) {
  Write-Host ""
  Write-Host "HATA: $mesaj" -ForegroundColor Red
  exit 1
}

function TectonicBul {
  $k = Get-Command tectonic -ErrorAction SilentlyContinue
  if ($k) { return $k.Source }
  $adaylar = @(
    (Join-Path $env:LOCALAPPDATA "Programs\Tectonic\tectonic.exe"),
    (Join-Path $env:ProgramFiles "Tectonic\tectonic.exe")
  )
  foreach ($a in $adaylar) { if ($a -and (Test-Path -LiteralPath $a)) { return $a } }
  return $null
}

$tectonic = TectonicBul
if (-not $tectonic) {
  Hata @"
Tectonic (LaTeX derleyicisi) kurulu degil.
Kurulum (tek komut, ~25 MB):
  powershell -ExecutionPolicy Bypass -File "$PSScriptRoot\tectonic-kur.ps1"
LaTeX derlemesi ZORUNLU DEGILDIR:
  - Word ciktisi icin  : md2docx.ps1 (yalniz Pandoc yeter)
  - PDF ciktisi icin   : md2pdf.ps1  (hicbir kurulum gerektirmez)
LaTeX yalniz dergi sablonu (.cls) derlemek gerektiginde sarttir.
"@
}

if (-not (Test-Path -LiteralPath $Girdi)) { Hata "Girdi dosyasi bulunamadi: $Girdi" }
$girdiTam = (Resolve-Path -LiteralPath $Girdi).Path
if ([System.IO.Path]::GetExtension($girdiTam) -ne ".tex") {
  Hata "Girdi bir .tex dosyasi olmalidir: $girdiTam`nMarkdown'dan .tex uretmek icin: md2tex.ps1"
}
if (-not $CiktiDizin) { $CiktiDizin = Split-Path -Parent $girdiTam }
if (-not (Test-Path -LiteralPath $CiktiDizin)) { New-Item -ItemType Directory -Path $CiktiDizin -Force | Out-Null }
$ciktiDizinTam = (Resolve-Path -LiteralPath $CiktiDizin).Path
$pdfYolu = Join-Path $ciktiDizinTam ([System.IO.Path]::GetFileNameWithoutExtension($girdiTam) + ".pdf")

if (Test-Path -LiteralPath $pdfYolu) { Remove-Item -LiteralPath $pdfYolu -Force }

$argumanlar = @("--outdir", $ciktiDizinTam)
if ($LogTut) { $argumanlar += "--keep-logs" }
$argumanlar += $girdiTam

Write-Host "> Derleniyor: $girdiTam" -ForegroundColor Cyan
Write-Host "  (ilk derlemede TeX paketleri indirilir - sabir)" -ForegroundColor DarkGray

# TUZAK: Tectonic ilerleme mesajlarini stderr'e yazar. $ErrorActionPreference="Stop"
# altinda PowerShell bunlari NativeCommandError'a cevirip betigi DURDURUR - derleme
# basarili olsa bile. Bu yuzden dis komut boyunca "Continue"a gecilir ve cikti
# dosyaya toplanir.
$gunlukYolu = Join-Path $env:TEMP ("tex2pdf-" + [Guid]::NewGuid().ToString("N") + ".log")
$eskiTercih = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$sure = Measure-Command {
  & $tectonic @argumanlar > $gunlukYolu 2>&1
}
$derlemeKodu = $LASTEXITCODE
$ErrorActionPreference = $eskiTercih
$metin = if (Test-Path -LiteralPath $gunlukYolu) { Get-Content -LiteralPath $gunlukYolu -Raw } else { "" }
Get-Content -LiteralPath $gunlukYolu -Tail 15 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }

if ($derlemeKodu -ne 0 -or -not (Test-Path -LiteralPath $pdfYolu)) {
  $ipucu = ""
  if ($metin -match "Undefined control sequence") { $ipucu = "Kaynakta tanimsiz bir komut var - yazim hatasi ya da eksik \usepackage." }
  elseif ($metin -match "font.*not found|Cannot find font|fontspec") { $ipucu = "Font bulunamadi. makale.tex icindeki \setmainfont satirini sistemde KURULU bir fontla degistir (or. 'Calibri' ya da 'TeX Gyre Termes')." }
  elseif ($metin -match "connect|network|resolve|timed out|SSL") { $ipucu = "Paketler indirilemedi - internet baglantisini kontrol et. Tectonic ilk derlemede paket ceker." }
  elseif ($metin -match "inputenc|utf8") { $ipucu = "pdflatex uyumlu paket kullanilmis. Turkce icin XeLaTeX gerekir: \usepackage[utf8]{inputenc} satirini SIL, fontspec kullan." }
  Hata @"
LaTeX derlemesi basarisiz (cikis kodu $derlemeKodu).
$ipucu
Tam gunluk: $gunlukYolu
Derlenmis dosya beklenen yer: $pdfYolu
"@
}
Remove-Item -LiteralPath $gunlukYolu -Force -ErrorAction SilentlyContinue

$boyut = (Get-Item -LiteralPath $pdfYolu).Length
if ($boyut -lt 1000) { Hata "PDF olustu ama bos gorunuyor ($boyut bayt): $pdfYolu" }

Write-Host ""
Write-Host "PDF hazir: $pdfYolu" -ForegroundColor Green
Write-Host ("  boyut: {0:N0} bayt   sure: {1:N1} sn" -f $boyut, $sure.TotalSeconds)
exit 0
