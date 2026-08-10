# md2pdf.ps1 - Markdown dosyasini PDF'e cevirir.
# KATMAN 0: hicbir ek kurulum gerektirmez. Windows'ta hazir olan Edge (ya da Chrome)
# tarayicisi "headless" (penceresiz) modda PDF basar. Pandoc kuruluysa daha iyi
# HTML uretmek icin otomatik kullanilir, ama zorunlu degildir.
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File md2pdf.ps1 -Girdi "rapor.md"
#   powershell -ExecutionPolicy Bypass -File md2pdf.ps1 -Girdi "makale.md" -Cikti "C:\Cikti\makale.pdf" -Girintili
#
# Notlar:
# - Bu dosya bilerek ASCII yazilmistir (Windows PowerShell 5.1 Turkce karakterli
#   betik dosyalarini yanlis kodlayabilir). Belgenin ICERIGI Turkce olabilir;
#   girdi dosyasi UTF-8 okunur, cikti UTF-8 yazilir.
# - Hata durumunda exit kodu 0 DEGILDIR (sessiz basarisizlik yok).

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Girdi,
  [string]$Cikti,
  [string]$Baslik,
  [switch]$Girintili,
  [switch]$HtmlKalsin
)

$ErrorActionPreference = "Stop"

function Hata($mesaj) {
  Write-Host ""
  Write-Host "HATA: $mesaj" -ForegroundColor Red
  exit 1
}

function Bilgi($mesaj) { Write-Host "  $mesaj" -ForegroundColor DarkGray }

# ---------------------------------------------------------------- girdi kontrol
if (-not (Test-Path -LiteralPath $Girdi)) { Hata "Girdi dosyasi bulunamadi: $Girdi" }
$girdiTam = (Resolve-Path -LiteralPath $Girdi).Path
if (-not $Cikti) { $Cikti = [System.IO.Path]::ChangeExtension($girdiTam, ".pdf") }
$ciktiDizin = Split-Path -Parent $Cikti
if ($ciktiDizin -and -not (Test-Path -LiteralPath $ciktiDizin)) {
  New-Item -ItemType Directory -Path $ciktiDizin -Force | Out-Null
}
if (-not $Baslik) { $Baslik = [System.IO.Path]::GetFileNameWithoutExtension($girdiTam) }

$stilYolu = Join-Path $PSScriptRoot "stil.css"
if (-not (Test-Path -LiteralPath $stilYolu)) { Hata "stil.css bulunamadi: $stilYolu" }
$stil = [System.IO.File]::ReadAllText($stilYolu, [System.Text.Encoding]::UTF8)

# ------------------------------------------------------------ tarayiciyi bul
function TarayiciBul {
  $adaylar = @(
    (Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:ProgramFiles "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:LOCALAPPDATA "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:ProgramFiles "Google\Chrome\Application\chrome.exe"),
    (Join-Path ${env:ProgramFiles(x86)} "Google\Chrome\Application\chrome.exe"),
    (Join-Path $env:LOCALAPPDATA "Google\Chrome\Application\chrome.exe")
  )
  foreach ($a in $adaylar) {
    if ($a -and (Test-Path -LiteralPath $a)) { return $a }
  }
  return $null
}

# ------------------------------------------------------- markdown -> html (basit)
# Pandoc yoksa devreye giren minimal donusturucu. Destekledigi seyler:
# baslik, paragraf, kalin/italik/kod, liste (isaretli ve numarali), tablo,
# alinti, yatay cizgi, kod blogu, bagalanti.
function HtmlKacis([string]$s) {
  $s = $s -replace '&', '&amp;'
  $s = $s -replace '<', '&lt;'
  $s = $s -replace '>', '&gt;'
  return $s
}

function SatirIci([string]$s) {
  $s = HtmlKacis $s
  $s = [regex]::Replace($s, '`([^`]+)`', '<code>$1</code>')
  $s = [regex]::Replace($s, '\*\*([^*]+)\*\*', '<strong>$1</strong>')
  $s = [regex]::Replace($s, '(?<!\*)\*([^*\s][^*]*)\*(?!\*)', '<em>$1</em>')
  $s = [regex]::Replace($s, '\[([^\]]+)\]\(([^)]+)\)', '<a href="$2">$1</a>')
  return $s
}

function BasitMarkdownHtml([string[]]$satirlar) {
  $sb = New-Object System.Text.StringBuilder
  $paragraf = New-Object System.Collections.Generic.List[string]
  $kodBloku = $false
  $listeTipi = $null      # "ul" | "ol" | $null
  $tabloAcik = $false
  $kaynakcaAcik = $false

  function ParagrafBosalt {
    if ($paragraf.Count -gt 0) {
      $metin = ($paragraf -join " ")
      [void]$sb.AppendLine("<p>" + (SatirIci $metin) + "</p>")
      $paragraf.Clear()
    }
  }

  foreach ($ham in $satirlar) {
    $satir = $ham.TrimEnd()

    # kod blogu siniri
    if ($satir -match '^\s*```') {
      if ($kodBloku) { [void]$sb.AppendLine("</code></pre>"); $kodBloku = $false }
      else {
        ParagrafBosalt
        if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>"); $listeTipi = $null }
        if ($tabloAcik) { [void]$sb.AppendLine("</tbody></table>"); $tabloAcik = $false }
        [void]$sb.AppendLine("<pre><code>"); $kodBloku = $true
      }
      continue
    }
    if ($kodBloku) { [void]$sb.AppendLine((HtmlKacis $ham)); continue }

    # tablo satiri
    if ($satir -match '^\s*\|.*\|\s*$') {
      ParagrafBosalt
      if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>"); $listeTipi = $null }
      $hucreler = ($satir.Trim() -replace '^\|', '' -replace '\|$', '') -split '\|'
      $ayirici = $true
      foreach ($h in $hucreler) { if ($h -notmatch '^[\s:-]+$') { $ayirici = $false } }
      if ($ayirici) { continue }   # |---|---| satiri atlanir
      if (-not $tabloAcik) {
        [void]$sb.AppendLine("<table><thead><tr>")
        foreach ($h in $hucreler) { [void]$sb.AppendLine("<th>" + (SatirIci $h.Trim()) + "</th>") }
        [void]$sb.AppendLine("</tr></thead><tbody>")
        $tabloAcik = $true
        continue
      }
      [void]$sb.AppendLine("<tr>")
      foreach ($h in $hucreler) { [void]$sb.AppendLine("<td>" + (SatirIci $h.Trim()) + "</td>") }
      [void]$sb.AppendLine("</tr>")
      continue
    }
    elseif ($tabloAcik) { [void]$sb.AppendLine("</tbody></table>"); $tabloAcik = $false }

    # bos satir
    if ($satir -match '^\s*$') {
      ParagrafBosalt
      if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>"); $listeTipi = $null }
      continue
    }

    # baslik
    if ($satir -match '^(#{1,6})\s+(.*)$') {
      ParagrafBosalt
      if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>"); $listeTipi = $null }
      $seviye = $matches[1].Length
      $metin = $matches[2].Trim()
      if ($kaynakcaAcik -and $seviye -le 2) { [void]$sb.AppendLine("</div>"); $kaynakcaAcik = $false }
      [void]$sb.AppendLine("<h$seviye>" + (SatirIci $metin) + "</h$seviye>")
      # kaynakca bolumu: asili girinti icin sarmalanir
      if ($metin -match '^(Kaynak|References|Bibliography)') {
        [void]$sb.AppendLine('<div class="kaynakca">'); $kaynakcaAcik = $true
      }
      continue
    }

    # yatay cizgi
    if ($satir -match '^\s*(---|\*\*\*|___)\s*$') {
      ParagrafBosalt
      if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>"); $listeTipi = $null }
      [void]$sb.AppendLine("<hr />")
      continue
    }

    # alinti
    if ($satir -match '^\s*>\s?(.*)$') {
      ParagrafBosalt
      [void]$sb.AppendLine("<blockquote>" + (SatirIci $matches[1]) + "</blockquote>")
      continue
    }

    # liste
    if ($satir -match '^\s*[-*+]\s+(.*)$') {
      ParagrafBosalt
      if ($listeTipi -ne "ul") {
        if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>") }
        [void]$sb.AppendLine("<ul>"); $listeTipi = "ul"
      }
      [void]$sb.AppendLine("<li>" + (SatirIci $matches[1]) + "</li>")
      continue
    }
    if ($satir -match '^\s*\d+[\.\)]\s+(.*)$') {
      ParagrafBosalt
      if ($listeTipi -ne "ol") {
        if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>") }
        [void]$sb.AppendLine("<ol>"); $listeTipi = "ol"
      }
      [void]$sb.AppendLine("<li>" + (SatirIci $matches[1]) + "</li>")
      continue
    }

    # duz metin -> paragraf tamponu
    $paragraf.Add($satir.Trim())
  }

  ParagrafBosalt
  if ($listeTipi) { [void]$sb.AppendLine("</$listeTipi>") }
  if ($tabloAcik) { [void]$sb.AppendLine("</tbody></table>") }
  if ($kodBloku) { [void]$sb.AppendLine("</code></pre>") }
  if ($kaynakcaAcik) { [void]$sb.AppendLine("</div>") }
  return $sb.ToString()
}

# ------------------------------------------------------------------ govde uret
$pandoc = Get-Command pandoc -ErrorAction SilentlyContinue
$govde = $null
$yontem = ""

if ($pandoc) {
  $yontem = "pandoc"
  $gecici = [System.IO.Path]::GetTempFileName()
  $geciciHtml = [System.IO.Path]::ChangeExtension($gecici, ".frag.html")
  Remove-Item -LiteralPath $gecici -Force -ErrorAction SilentlyContinue
  & $pandoc.Source --from=markdown+pipe_tables+yaml_metadata_block --to=html5 `
      --wrap=none --output="$geciciHtml" "$girdiTam"
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $geciciHtml)) {
    Hata "Pandoc HTML uretemedi (cikis kodu $LASTEXITCODE)."
  }
  $govde = [System.IO.File]::ReadAllText($geciciHtml, [System.Text.Encoding]::UTF8)
  Remove-Item -LiteralPath $geciciHtml -Force -ErrorAction SilentlyContinue
  # pandoc kaynakca basligini sarmalamaz; asili girinti icin basit bir isaret koy
  $govde = [regex]::Replace($govde,
    '(<h2[^>]*>\s*(Kaynak\w*|References|Bibliography)[^<]*</h2>)', '$1<div class="kaynakca">')
  if ($govde -match '<div class="kaynakca">') { $govde = $govde + "</div>" }
}
else {
  $yontem = "yerlesik donusturucu (pandoc kurulu degil)"
  $satirlar = [System.IO.File]::ReadAllLines($girdiTam, [System.Text.Encoding]::UTF8)
  # YAML on bilgi blogunu at
  if ($satirlar.Count -gt 0 -and $satirlar[0].Trim() -eq "---") {
    $bitis = -1
    for ($i = 1; $i -lt $satirlar.Count; $i++) { if ($satirlar[$i].Trim() -eq "---") { $bitis = $i; break } }
    if ($bitis -gt 0) { $satirlar = $satirlar[($bitis + 1)..($satirlar.Count - 1)] }
  }
  $govde = BasitMarkdownHtml $satirlar
}

# ---------------------------------------------------------------- html birlestir
$govdeSinif = ""
if ($Girintili) { $govdeSinif = ' class="girintili"' }
$baslikKacisli = HtmlKacis $Baslik
$html = @"
<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="utf-8" />
<title>$baslikKacisli</title>
<style>
$stil
</style>
</head>
<body$govdeSinif>
$govde
</body>
</html>
"@

$htmlYolu = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),
  ("md2pdf-" + [System.Guid]::NewGuid().ToString("N") + ".html"))
if ($HtmlKalsin) { $htmlYolu = [System.IO.Path]::ChangeExtension($Cikti, ".html") }
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($htmlYolu, $html, $utf8)

# ------------------------------------------------------------------- pdf'e bas
$tarayici = TarayiciBul
if (-not $tarayici) {
  Hata @"
Edge ya da Chrome bulunamadi - PDF basilamiyor.
Cozum: Microsoft Edge kurulu olmalidir (Windows'ta genelde hazir gelir).
Kurulu ise yolunu soyle kontrol et:
  where.exe msedge
HTML ciktisi burada durdu, tarayicida acip Ctrl+P ile PDF'e basabilirsin:
  $htmlYolu
"@
}

$profil = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),
  ("md2pdf-profil-" + [System.Guid]::NewGuid().ToString("N")))
$ciktiTam = [System.IO.Path]::GetFullPath($Cikti)
if (Test-Path -LiteralPath $ciktiTam) { Remove-Item -LiteralPath $ciktiTam -Force }

$argumanlar = @(
  "--headless=new",
  "--disable-gpu",
  "--no-first-run",
  "--no-default-browser-check",
  "--disable-extensions",
  "--user-data-dir=`"$profil`"",
  "--virtual-time-budget=5000",
  "--no-pdf-header-footer",
  "--print-to-pdf=`"$ciktiTam`"",
  "`"file:///$($htmlYolu -replace '\\','/')`""
)

Bilgi "Donusturucu : $yontem"
Bilgi "Tarayici    : $tarayici"
$sure = Measure-Command {
  $p = Start-Process -FilePath $tarayici -ArgumentList $argumanlar -NoNewWindow -Wait -PassThru
}
Remove-Item -LiteralPath $profil -Recurse -Force -ErrorAction SilentlyContinue
if (-not $HtmlKalsin) { Remove-Item -LiteralPath $htmlYolu -Force -ErrorAction SilentlyContinue }

if (-not (Test-Path -LiteralPath $ciktiTam)) {
  Hata @"
PDF olusmadi. Muhtemel sebepler:
 1) Tarayici surumu eski - '--headless=new' desteklemiyor olabilir. Edge'i guncelle.
 2) Cikti klasorune yazma izni yok: $ciktiDizin
 3) Antivirus penceresiz tarayiciyi engelledi.
Elle deneme komutu:
  & "$tarayici" --headless=new --print-to-pdf="$ciktiTam" "$htmlYolu"
"@
}
$boyut = (Get-Item -LiteralPath $ciktiTam).Length
if ($boyut -lt 1000) { Hata "PDF olustu ama bos gorunuyor ($boyut bayt): $ciktiTam" }

Write-Host ""
Write-Host "PDF hazir: $ciktiTam" -ForegroundColor Green
Write-Host ("  boyut: {0:N0} bayt   sure: {1:N1} sn" -f $boyut, $sure.TotalSeconds)
if ($HtmlKalsin) { Write-Host "  ara HTML: $htmlYolu" }
exit 0
