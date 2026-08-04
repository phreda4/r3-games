# Ejecutar desde la carpeta raiz del repo r3 (donde esta la carpeta r3\)
# Uso: powershell -ExecutionPolicy Bypass -File rename-sdl2gfx.ps1

$map = [ordered]@{
    "SDLColor"    = "color"
    "SDLColorA"   = "colora"
    "SDLcls"      = "cls"
    "SDLPoint"    = "point"
    "SDLGetPixel" = "getpixel"
    "SDLLine"     = "line"
    "SDLLineH"    = "lineh"
    "SDLLineV"    = "linev"
    "SDLFRect"    = "frect"
    "SDLRect"     = "rect"
    "SDLFEllipse" = "fellipse"
    "SDLEllipse"  = "ellipse"
    "SDLTriangle" = "triangle"
    "SDLFRound"   = "fround"
    "SDLRound"    = "round"
    "SDLFCircle"  = "fcircle"
    "SDLCircle"   = "circle"
    "SDLImage"    = "image"
    "SDLImages"   = "images"
    "SDLImageb"   = "imageb"
    "SDLImagebb"  = "imagebb"
}

$files = Get-ChildItem -Path . -Filter *.r3 -Recurse

foreach ($f in $files) {
    $text = Get-Content -Path $f.FullName -Raw -Encoding UTF8
    $orig = $text
    $changed = $false

    foreach ($old in $map.Keys) {
        $new = $map[$old]
        # \b...\b = palabra completa, evita tocar substrings (ej SDLColorA no se pisa con SDLColor)
        $pattern = "\b$old\b"
        if ([regex]::IsMatch($text, $pattern)) {
            $text = [regex]::Replace($text, $pattern, $new)
            $changed = $true
        }
    }

    if ($changed) {
        Set-Content -Path $f.FullName -Value $text -Encoding UTF8 -NoNewline
        Write-Host "Modificado: $($f.FullName)"
    }
}

Write-Host "Listo."
