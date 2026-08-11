# md2docx.ps1 - Markdown dosyasini Word (.docx) belgesine cevirir.
# KATMAN 1: Pandoc gerektirir.
#   winget install --id JohnMacFarlane.Pandoc
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File md2docx.ps1 -Girdi "rapor.md"
#   powershell -ExecutionPolicy Bypass -File md2docx.ps1 -Girdi "makale.md" -Kaynakca "kaynakca.bib" -AtifStili "apa.csl"
#   powershell -ExecutionPolicy Bypass -File md2docx.ps1 -Girdi "rapor.md" -Sablon "kurum-sablonu.docx"
#
# -Sablon: kurumun kendi Word sablonu (baslik stilleri, font, logo). Pandoc bunu
#          "reference doc" olarak kullanir; icerigi degil, STILLERI alinir.
# Bu dosya bilerek ASCII yazilmistir; belgenin icerigi Turkce olabilir.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Girdi,
  [string]$Cikti,
  [string]$Kaynakca,
  [string]$AtifStili,
  [string]$Sablon,
  [switch]$IcindekilerEkle
)

$ErrorActionPreference = "Stop"

function Hata($mesaj) {
  Write-Host ""
  Write-Host "HATA: $mesaj" -ForegroundColor Red
  exit 1
}

# Pandoc'u bul. Sadece PATH'e guvenme: winget ile yeni kurulduysa acik terminalin
# PATH'i henuz tazelenmemis olabilir - bilinen kurulum yollarina da bakariz.
function PandocBul {
  $k = Get-Command pandoc -ErrorAction SilentlyContinue
  if ($k) { return $k.Source }
  $adaylar = @(
    (Join-Path $env:LOCALAPPDATA "Programs\Pandoc\pandoc.exe"),
    (Join-Path $env:ProgramFiles "Pandoc\pandoc.exe"),
    (Join-Path ${env:ProgramFiles(x86)} "Pandoc\pandoc.exe")
  )
  foreach ($a in $adaylar) { if ($a -and (Test-Path -LiteralPath $a)) { return $a } }
  return $null
}

$pandoc = PandocBul
if (-not $pandoc) {
  Hata @"
Pandoc kurulu degil - Word ciktisi bu araca baglidir.
Kurulum (tek komut, yaklasik 200 MB):
  winget install --id JohnMacFarlane.Pandoc
Kurulumdan sonra terminali KAPATIP yeniden ac (PATH tazelensin), sonra dogrula:
  pandoc --version
Pandoc'suz da PDF alabilirsin: md2pdf.ps1 (hicbir kurulum gerektirmez).
"@
}

if (-not (Test-Path -LiteralPath $Girdi)) { Hata "Girdi dosyasi bulunamadi: $Girdi" }
$girdiTam = (Resolve-Path -LiteralPath $Girdi).Path
if (-not $Cikti) { $Cikti = [System.IO.Path]::ChangeExtension($girdiTam, ".docx") }
$ciktiDizin = Split-Path -Parent $Cikti
if ($ciktiDizin -and -not (Test-Path -LiteralPath $ciktiDizin)) {
  New-Item -ItemType Directory -Path $ciktiDizin -Force | Out-Null
}
$ciktiTam = [System.IO.Path]::GetFullPath($Cikti)

$argumanlar = @(
  "--from=markdown+pipe_tables+yaml_metadata_block",
  "--to=docx",
  "--standalone",
  "--resource-path=$(Split-Path -Parent $girdiTam)"
)

if ($IcindekilerEkle) { $argumanlar += @("--toc", "--toc-depth=3") }

if ($Kaynakca) {
  if (-not (Test-Path -LiteralPath $Kaynakca)) { Hata "Kaynakca dosyasi bulunamadi: $Kaynakca" }
  $argumanlar += "--citeproc"
  $argumanlar += "--bibliography=$((Resolve-Path -LiteralPath $Kaynakca).Path)"
  if ($AtifStili) {
    if (-not (Test-Path -LiteralPath $AtifStili)) {
      Hata @"
Atif stili dosyasi bulunamadi: $AtifStili
CSL stil dosyalari (APA 7, IEEE, Chicago...) buradan indirilir:
  https://github.com/citation-style-language/styles
Ornek: apa.csl dosyasini indirip belgenin yanina koy.
"@
    }
    $argumanlar += "--csl=$((Resolve-Path -LiteralPath $AtifStili).Path)"
  }
}

if ($Sablon) {
  if (-not (Test-Path -LiteralPath $Sablon)) { Hata "Word sablonu bulunamadi: $Sablon" }
  $argumanlar += "--reference-doc=$((Resolve-Path -LiteralPath $Sablon).Path)"
}

$argumanlar += @("--output=$ciktiTam", $girdiTam)

if (Test-Path -LiteralPath $ciktiTam) { Remove-Item -LiteralPath $ciktiTam -Force }
& $pandoc @argumanlar
if ($LASTEXITCODE -ne 0) { Hata "Pandoc donusturemedi (cikis kodu $LASTEXITCODE). Yukaridaki pandoc mesajini oku." }
if (-not (Test-Path -LiteralPath $ciktiTam)) { Hata "Pandoc hata vermedi ama dosya olusmadi: $ciktiTam" }

$boyut = (Get-Item -LiteralPath $ciktiTam).Length
if ($boyut -lt 1000) { Hata "Word dosyasi olustu ama bos gorunuyor ($boyut bayt): $ciktiTam" }

Write-Host ""
Write-Host "Word belgesi hazir: $ciktiTam" -ForegroundColor Green
Write-Host ("  boyut: {0:N0} bayt" -f $boyut)
exit 0
