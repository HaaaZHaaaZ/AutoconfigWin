# DEMO DEL SCRIPT VISUAL - SIN REQUERIR ADMIN
# Este script demuestra los efectos visuales del script principal

function Enable-FullscreenVisuals {
    try {
        $raw = $host.UI.RawUI
        $maxSize = $raw.MaxPhysicalWindowSize
        $raw.BufferSize = $maxSize
        $raw.WindowSize = $maxSize
        Write-Host "Consola maximizada." -ForegroundColor Green
    }
    catch {
        Write-Host "No se pudo maximizar la consola (normal en algunos terminales)." -ForegroundColor Yellow
    }
}

function Render-Status {
    param(
        [string]$Message = "",
        [string]$Level = "INFO"
    )
    try {
        $raw = $host.UI.RawUI
        $width = $raw.WindowSize.Width
        $height = $raw.WindowSize.Height
        
        $statusLine = "[$(Get-Date -Format 'HH:mm:ss')] [$Level] $Message"
        if ($statusLine.Length -gt ($width - 2)) {
            $statusLine = $statusLine.Substring(0, $width - 5) + "..."
        }
        
        $origPos = $raw.CursorPosition
        $raw.CursorPosition = @{X=0;Y=($height - 2)}
        Write-Host ((" " * $width)) -NoNewline
        $raw.CursorPosition = @{X=0;Y=($height - 2)}
        Write-Host $statusLine -ForegroundColor Green -BackgroundColor Black -NoNewline
        $raw.CursorPosition = $origPos
    }
    catch {
        # Ignorar errores
    }
}

function Show-HackerBanner {
    $lines = @(
        "Iniciando modulos...",
        "Analizando sistema...",
        "Aplicando politicas...",
        "Preparando herramientas...",
        "Listo. Presiona ENTER para continuar."
    )
    
    Clear-Host
    foreach ($line in $lines) {
        $out = ""
        foreach ($c in $line.ToCharArray()) {
            $out += $c
            Write-Host -NoNewline $c -ForegroundColor DarkGreen
            Start-Sleep -Milliseconds (Get-Random -Minimum 10 -Maximum 40)
        }
        Write-Host ""
    }
    Write-Host ""
    Read-Host -Prompt "Pulsa ENTER para iniciar"
    Clear-Host
}

function Show-Banner {
    $banner = @"
                              
@@@  @@@   @@@@@@   @@@@@@@@  
@@@  @@@  @@@@@@@@  @@@@@@@@  
@@!  @@@  @@!  @@@       @@!  
!@!  @!@  !@!  @!@      !@!   
@!@!@!@!  @!@!@!@!     @!!    
!!!@!!!!  !!!@!!!!    !!!     
!!:  !!!  !!:  !!!   !!:      
:!:  !:!  :!:  !:!  :!:       
::   :::  ::   :::   :: ::::  
 :   : :   :   : :  : :: : :  
                              
"@
    Write-Host $banner -ForegroundColor Cyan
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
    
    try {
        Render-Status -Message $Message -Level $Level
    }
    catch {
        # Ignorar errores
    }
}

# === INICIO DE LA DEMO ===

Enable-FullscreenVisuals
Show-HackerBanner
Show-Banner

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
