# Demo del Splash Screen - Sin permisos de admin requeridos

$ErrorActionPreference = "SilentlyContinue"

# Maximizar la consola
try {
    $raw = $host.UI.RawUI
    $maxSize = $raw.MaxPhysicalWindowSize
    $raw.BufferSize = $maxSize
    $raw.WindowSize = $maxSize
}
catch {
    # Ignorar errores
}

function Show-SplashScreen {
    Clear-Host
    
    Write-Host ""
    
    # Banner personalizado "HaZ with IA" - GRANDE
    Write-Host "   " -NoNewline
    foreach ($c in "H") { Write-Host $c -ForegroundColor Yellow -NoNewline; Start-Sleep -Milliseconds 80 }
    foreach ($c in "a") { Write-Host $c -ForegroundColor Yellow -NoNewline; Start-Sleep -Milliseconds 80 }
    foreach ($c in "Z") { Write-Host $c -ForegroundColor Yellow -NoNewline; Start-Sleep -Milliseconds 80 }
    Write-Host " " -NoNewline
    foreach ($c in "with") { 
        Write-Host $c[0] -ForegroundColor Cyan -NoNewline
        Start-Sleep -Milliseconds 60
    }
    Write-Host " " -NoNewline
    foreach ($c in "I") { Write-Host $c -ForegroundColor Magenta -NoNewline; Start-Sleep -Milliseconds 80 }
    foreach ($c in "A") { Write-Host $c -ForegroundColor Magenta -NoNewline; Start-Sleep -Milliseconds 80 }
    Write-Host ""
    Write-Host ""
    
    # Logo AUTOCONFIG animado
    $autoLogo = @(
        "        #    #  #  #  #####  ####  #   #  #     #####   ####",
        "        #    #  #  #    #    #     #   # #      #      #",
        "        #    #  ####    #    ####  ### #  #     ####    ####",
        "        #    #  #  #    #    #     # ##  #      #           #",
        "        ####  #  #      #    ####  #  #  ####   ####     ####"
    )
    
    foreach ($line in $autoLogo) {
        Write-Host "   $line" -ForegroundColor Cyan
        Start-Sleep -Milliseconds 80
    }
    
    Write-Host ""
    
    # Linea inferior con animacion
    Write-Host "   " -NoNewline
    for ($i = 0; $i -lt 10; $i++) {
        Write-Host "-=" -ForegroundColor Green -NoNewline
        Start-Sleep -Milliseconds 40
    }
    Write-Host ""
    
    Write-Host ""
    
    # Version y creditos simples
    Write-Host "   WINDOWS SYSTEM AUTOMATION TOOL v1.0" -ForegroundColor Cyan
    Write-Host "   By: HaZ with GitHub Copilot (IA)" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "   > Presiona ENTER para continuar..." -ForegroundColor Yellow
    Read-Host | Out-Null
    Clear-Host
}

# Mostrar el splash screen
Show-SplashScreen

Write-Host "Splash screen completado exitosamente." -ForegroundColor Green
Write-Host ""
Write-Host "El splash screen se muestra automaticamente cuando ejecutas ConfigurarEquipo.ps1" -ForegroundColor Cyan
