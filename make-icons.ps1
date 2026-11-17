# Draws the app icon (an ivory tile with a red dragon character on jade felt) at the sizes the app needs.
Add-Type -AssemblyName System.Drawing
function RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $p.AddArc($x, $y, $d, $d, 180, 90)
  $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
  $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure()
  return $p
}
foreach ($size in 180, 192, 512) {
  $s = $size / 100.0
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.TextRenderingHint = 'AntiAliasGridFit'
  $rect = New-Object System.Drawing.RectangleF 0, 0, $size, $size
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, ([System.Drawing.ColorTranslator]::FromHtml('#17755a')), ([System.Drawing.ColorTranslator]::FromHtml('#072a1f')), 60.0
  $g.FillRectangle($bg, $rect)
  # tile: shadow, jade back, bone edge, ivory face (edges show at the left and bottom)
  $layers = @(
    @{ dx = -7; dy = 7; c = '#04170f' },
    @{ dx = -5; dy = 5; c = '#0f5c3d' },
    @{ dx = -4; dy = 4; c = '#1f9163' },
    @{ dx = -2; dy = 2; c = '#d6cdb0' },
    @{ dx = 0;  dy = 0; c = '#fffdf4' }
  )
  foreach ($l in $layers) {
    $path = RoundRect ((25 + $l.dx) * $s) ((14 + $l.dy) * $s) (54 * $s) (70 * $s) (8 * $s)
    $br = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml($l.c))
    $g.FillPath($br, $path)
  }
  $font = New-Object System.Drawing.Font 'Microsoft YaHei', (40 * $s), ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
  $red = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml('#b8322a'))
  $face = New-Object System.Drawing.RectangleF (25 * $s), (14 * $s), (54 * $s), (70 * $s)
  $g.DrawString([string][char]0x4E2D, $font, $red, $face, $fmt)
  $g.Dispose()
  $bmp.Save((Join-Path $PSScriptRoot "icon-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}
"icons written"
