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
    
    # ASCII Art del splash screen
    $splash = @(
        "",
        "   ========================================================================",
        "   |                                                                      |",
        "   |     AUTOCONFIG - WINDOWS SYSTEM AUTOMATION TOOL v1.0                |",
        "   |                                                                      |",
        "   |                 Asistida por: GitHub Copilot (IA)                   |",
        "   |                                                                      |",
        "   ========================================================================",
        ""
    )
    
    # Mostrar splash con animacion
    foreach ($line in $splash) {
        Write-Host $line -ForegroundColor Cyan
        Start-Sleep -Milliseconds 50
    }
    
    # Linea de inicio con animacion de puntos
    Write-Host "   " -NoNewline
    Write-Host "[" -ForegroundColor White -NoNewline
    for ($i = 0; $i -lt 3; $i++) {
        Write-Host "o" -ForegroundColor DarkGreen -NoNewline
        Start-Sleep -Milliseconds 300
    }
    Write-Host "]" -ForegroundColor White
    
    # Texto de inicializacion
    $initLines = @(
        "   [+] Verificando permisos administrativos...",
        "   [+] Analizando configuracion del sistema...",
        "   [+] Preparando herramientas...",
        "   [+] Listo para ejecutar operaciones."
    )
    
    foreach ($line in $initLines) {
        foreach ($c in $line.ToCharArray()) {
            Write-Host -NoNewline $c -ForegroundColor Green
            Start-Sleep -Milliseconds (Get-Random -Minimum 5 -Maximum 20)
        }
        Write-Host ""
        Start-Sleep -Milliseconds 200
    }
    
    Write-Host ""
    Write-Host "   Presiona ENTER para continuar..." -ForegroundColor Yellow
    Read-Host | Out-Null
    Clear-Host
}

# Mostrar el splash screen
Show-SplashScreen

Write-Host "Splash screen completado exitosamente." -ForegroundColor Green
Write-Host ""
Write-Host "El splash screen se muestra automaticamente cuando ejecutas ConfigurarEquipo.ps1" -ForegroundColor Cyan
