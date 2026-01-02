# DEMO DEL SCRIPT VISUAL - SIN REQUERIR ADMIN
# Este script demuestra los efectos visuales del script principal

# === FUNCIONES VISUALES ===

function Show-HaZBanner {
    Clear-Host
    $banner = @"

  _    _       ______ 
 | |  | |     |___  / 
 | |__| | __ _   / /  
 |  __  |/ _` | / /   
 | |  | | (_| |/ /__  
 |_|  |_|\__,_/_____| 
 
   AUTOMATION TOOL
"@
    Write-Host $banner -ForegroundColor Cyan
    Write-Host ""
}

function Show-Loading {
    Write-Host "Cargando modulos..." -NoNewline
    $chars = "|", "/", "-", "\"
    for ($i = 0; $i -lt 10; $i++) {
        foreach ($c in $chars) {
            Write-Host "`b$c" -NoNewline
            Start-Sleep -Milliseconds 100
        }
    }
    Write-Host "`b Listo." -ForegroundColor Green
    Start-Sleep -Seconds 1
}

function Log-Status {
    param(
        [string]$Message,
        [string]$Level = "INFO",
        [string]$Color = "White"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    $colorMap = @{
        "INFO"    = "White"
        "ERROR"   = "Red"
        "WARNING" = "Yellow"
        "SUCCESS" = "Green"
    }
    
    $displayColor = if ($colorMap.ContainsKey($Level)) { $colorMap[$Level] } else { $Color }
    Write-Host $logMessage -ForegroundColor $displayColor
}

# === INICIO DE LA DEMO ===

Show-Loading
Show-HaZBanner

# Demo del sistema de logging con status
Write-Host "`n=== DEMO DE FUNCIONALIDADES VISUALES ===" -ForegroundColor Cyan
Write-Host ""

Log-Status "Iniciando sistema de configuracion" "INFO"
Start-Sleep -Seconds 1

Log-Status "Verificando permisos del usuario" "INFO"
Start-Sleep -Seconds 1

Log-Status "Sistema inicializado correctamente" "SUCCESS"
Start-Sleep -Seconds 1

Log-Status "Conectando con adaptador de red..." "INFO"
Start-Sleep -Seconds 2

Log-Status "Adaptador Ethernet encontrado" "SUCCESS"
Start-Sleep -Seconds 1

Log-Status "Iniciando instalacion de programas" "INFO"
Start-Sleep -Seconds 1

$programas = @("Chrome", "Firefox", "7Zip", "WinRAR")
$total = $programas.Count
$contador = 0

foreach ($prog in $programas) {
    $contador++
    Log-Status "Instalando $prog ($contador/$total)..." "INFO"
    Start-Sleep -Seconds 1
    Log-Status "$prog instalado correctamente" "SUCCESS"
    Start-Sleep -Seconds 0.5
}

Log-Status "Instalacion completada" "SUCCESS"
Start-Sleep -Seconds 1

Log-Status "Personalizando escritorio..." "INFO"
Start-Sleep -Seconds 1.5

Log-Status "Escritorio personalizado" "SUCCESS"
Start-Sleep -Seconds 1

Log-Status "Limpiando archivos temporales..." "INFO"
Start-Sleep -Seconds 2

Log-Status "Limpieza completada" "SUCCESS"

Write-Host "`n=== DEMO FINALIZADA ===" -ForegroundColor Cyan
Write-Host "El script ConfigurarEquipo.ps1 ya tiene estos efectos visuales integrados." -ForegroundColor Green
Write-Host "Ejecutalo con permisos de administrador para ver la experiencia completa." -ForegroundColor Green
Write-Host ""
Read-Host "Presiona ENTER para finalizar"
