# md2tex.ps1 - Markdown dosyasindan LaTeX (.tex) KAYNAGI uretir.
# KATMAN 1: Pandoc gerektirir. LaTeX kurulumu GEREKMEZ - bu betik yalniz kaynak uretir,
# derlemez. Derlemek icin: tex2pdf.ps1 (Katman 2, Tectonic).
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File md2tex.ps1 -Girdi "makale.md"
#   powershell -ExecutionPolicy Bypass -File md2tex.ps1 -Girdi "makale.md" -Kaynakca "kaynakca.bib"
#   powershell -ExecutionPolicy Bypass -File md2tex.ps1 -Girdi "bolum.md" -Parca
#
# -Parca : sadece govde uretir (\documentclass yok). Derginin kendi .cls sablonuna
#          yapistirmak icin kullanilir - sablonun sinif dosyasi BOZULMAZ.
# Uretilen kaynak XeLaTeX/LuaLaTeX icindir (Turkce icin dogru secim).
# Bu dosya bilerek ASCII yazilmistir; belgenin icerigi Turkce olabilir.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Girdi,
  [string]$Cikti,
  [string]$Kaynakca,
  [string]$Sinif = "article",
  [string]$Font = "Times New Roman",
  [switch]$Parca,
  [switch]$IcindekilerEkle
)

$ErrorActionPreference = "Stop"

function Hata($mesaj) {
  Write-Host ""
  Write-Host "HATA: $mesaj" -ForegroundColor Red
  exit 1
}

# Pandoc'u bul (PATH tazelenmemis olabilir - bilinen kurulum yollarina da bak)
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
Pandoc kurulu degil - LaTeX kaynagi bu araca baglidir.
Kurulum (tek komut):
  winget install --id JohnMacFarlane.Pandoc
Kurulumdan sonra terminali KAPATIP yeniden ac, sonra dogrula:
  pandoc --version
"@
}

if (-not (Test-Path -LiteralPath $Girdi)) { Hata "Girdi dosyasi bulunamadi: $Girdi" }
$girdiTam = (Resolve-Path -LiteralPath $Girdi).Path
if (-not $Cikti) { $Cikti = [System.IO.Path]::ChangeExtension($girdiTam, ".tex") }
$ciktiDizin = Split-Path -Parent $Cikti
if ($ciktiDizin -and -not (Test-Path -LiteralPath $ciktiDizin)) {
  New-Item -ItemType Directory -Path $ciktiDizin -Force | Out-Null
}
$ciktiTam = [System.IO.Path]::GetFullPath($Cikti)

$argumanlar = @(
  "--from=markdown+pipe_tables+yaml_metadata_block",
  "--to=latex",
  "--wrap=preserve"
)

if (-not $Parca) {
  $argumanlar += @(
    "--standalone",
    "--pdf-engine=xelatex",          # sablonun fontspec dalini acar (Turkce icin gerekli)
    "-V", "documentclass=$Sinif",
    "-V", "lang=tr",
    "-V", "mainfont=$Font",
    "-V", "geometry:a4paper",
    "-V", "geometry:margin=2.5cm",
    "-V", "fontsize=12pt",
    "-V", "linestretch=1.5"
  )
  if ($IcindekilerEkle) { $argumanlar += @("--toc", "--toc-depth=3") }
}

if ($Kaynakca) {
  if (-not (Test-Path -LiteralPath $Kaynakca)) { Hata "Kaynakca (.bib) bulunamadi: $Kaynakca" }
  # LaTeX tarafinda kaynakcayi biblatex isler (pandoc atiflari cozmez, .tex icinde \cite kalir)
  $argumanlar += @("--biblatex", "--bibliography=$((Resolve-Path -LiteralPath $Kaynakca).Path)")
}

$argumanlar += @("--output=$ciktiTam", $girdiTam)

if (Test-Path -LiteralPath $ciktiTam) { Remove-Item -LiteralPath $ciktiTam -Force }
& $pandoc @argumanlar
if ($LASTEXITCODE -ne 0) { Hata "Pandoc donusturemedi (cikis kodu $LASTEXITCODE)." }
if (-not (Test-Path -LiteralPath $ciktiTam)) { Hata "Pandoc hata vermedi ama .tex olusmadi: $ciktiTam" }

$boyut = (Get-Item -LiteralPath $ciktiTam).Length
if ($boyut -lt 100) { Hata ".tex olustu ama bos gorunuyor ($boyut bayt): $ciktiTam" }

Write-Host ""
Write-Host "LaTeX kaynagi hazir: $ciktiTam" -ForegroundColor Green
Write-Host ("  boyut: {0:N0} bayt" -f $boyut)
if ($Parca) {
  Write-Host "  (parca modu: yalniz govde - derginin .cls sablonuna yapistirilabilir)"
} else {
  Write-Host "  Derlemek icin (Katman 2): tex2pdf.ps1 -Girdi `"$ciktiTam`""
}
exit 0
