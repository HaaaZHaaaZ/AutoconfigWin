# Verificar si el script se esta ejecutando con permisos de administrador
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script debe ejecutarse con permisos de administrador." -ForegroundColor Red
        Read-Host -Prompt "Presione ENTER para cerrar esta ventana"
        exit
    }
}

# Ejecutar la verificacion de permisos de administrador
Test-Admin

# === FUNCIONES VISUALES TIPO HACKER ===

function Enable-FullscreenVisuals {
    try {
        $raw = $host.UI.RawUI
        $maxSize = $raw.MaxPhysicalWindowSize
        $raw.BufferSize = $maxSize
        $raw.WindowSize = $maxSize
    }
    catch {
        # Si no se puede maximizar, continuar sin error
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

function Show-SplashScreen {
    Clear-Host
    
    Write-Host ""
    
    # Linea superior animada
    Write-Host "   " -NoNewline
    for ($i = 0; $i -lt 10; $i++) {
        Write-Host "-=" -ForegroundColor Green -NoNewline
        Start-Sleep -Milliseconds 40
    }
    Write-Host ""
    
    Write-Host ""
    
    # Banner personalizado "HaZ with IA"
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
    
    # Linea inferior animada
    Write-Host "   " -NoNewline
    for ($i = 0; $i -lt 10; $i++) {
        Write-Host "-=" -ForegroundColor Green -NoNewline
        Start-Sleep -Milliseconds 40
    }
    Write-Host ""
    
    Write-Host ""
    
    # Version y creditos
    Write-Host "   WINDOWS SYSTEM AUTOMATION TOOL v1.0" -ForegroundColor Cyan
    Write-Host "   By: HaZ with GitHub Copilot (IA)" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "   > Presiona ENTER para continuar..." -ForegroundColor Yellow
    Read-Host | Out-Null
    Clear-Host
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

# Activar visuales y mostrar splash screen + banner animado
Enable-FullscreenVisuals
Show-SplashScreen
Show-HackerBanner
Show-Banner

# Funcion mejorada de logging con status visual
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
    
    # Actualizar barra de estado
    try {
        Render-Status -Message $Message -Level $Level
    }
    catch {
        # Ignorar errores de rendering
    }
}

# Alias para compatibilidad
function Write-StatusLog {
    param([string]$Message, [string]$Level = "INFO", [string]$Color = "White")
    Log-Status -Message $Message -Level $Level -Color $Color
}

# =======================================
# FUNCIONES PARA CADA ACCION
# =======================================

function Get-ActiveNetworkAdapter {
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    foreach ($adapter in $adapters) {
        $ipAddresses = (Get-NetIPAddress -InterfaceAlias $adapter.Name -AddressFamily IPv4).IPAddress
        foreach ($ip in $ipAddresses) {
            if (Test-Connection -ComputerName google.com -Count 1 -Quiet) {
                return $adapter.Name
            }
        }
    }
    return $null
}

function Configurar-IP {
    Log-Status "Iniciando configuracion de red" "INFO" "Cyan"
    $adapterName = Get-ActiveNetworkAdapter
    if ($null -eq $adapterName) {
        Log-Status "No se encontro adaptador con conexion a Internet" "ERROR"
        return
    }
    Log-Status "Adaptador activo: $adapterName" "SUCCESS" "Cyan"

    $optionIP = Read-Host "Deseas configurar la direccion IP por DHCP? (s/n)"
    if ($optionIP -eq "s") {
        Log-Status "Configurando IP por DHCP..." "INFO" "Yellow"
        Invoke-Expression "netsh interface ip set address name='$adapterName' source=dhcp"
        Log-Status "IP DHCP configurada" "SUCCESS"
    }
    else {
        $ip = Read-Host "Ingresa la direccion IP (e.g., 192.168.1.100)"
        $subnet = Read-Host "Ingresa la mascara de subred (e.g., 255.255.255.0)"
        $gateway = Read-Host "Ingresa la puerta de enlace predeterminada (e.g., 192.168.1.1)"
        Log-Status "Configurando IP estatica..." "INFO" "Yellow"
        Invoke-Expression "netsh interface ip set address name='$adapterName' static $ip $subnet $gateway"
        Log-Status "IP estatica configurada" "SUCCESS"
    }

    $optionDNS = Read-Host "Deseas configurar los DNS por DHCP? (s/n)"
    if ($optionDNS -eq "s") {
        Log-Status "Configurando DNS por DHCP..." "INFO" "Yellow"
        Invoke-Expression "netsh interface ip set dns name='$adapterName' source=dhcp"
        Log-Status "DNS DHCP configurado" "SUCCESS"
    }
    else {
        $dnsOption = Read-Host "Deseas configurar los DNS de AdGuard? (s/n)"
        if ($dnsOption -eq "s") {
            $dns1 = "94.140.14.14"
            $dns2 = "94.140.15.15"
        } else {
            $dns1 = Read-Host "Ingresa el servidor DNS preferido (e.g., 8.8.8.8)"
            $dns2 = Read-Host "Ingresa el servidor DNS alternativo (e.g., 8.8.4.4)"
        }
        Log-Status "Aplicando DNS personalizados..." "INFO" "Yellow"
        Invoke-Expression "netsh interface ip set dns name='$adapterName' static $dns1"
        Invoke-Expression "netsh interface ip add dns name='$adapterName' $dns2 index=2"
        Log-Status "Configuracion de DNS completada" "SUCCESS"
    }
    Log-Status "Configuracion de red finalizada" "SUCCESS"
}

function Instalar-Programas {
    Log-Status "Iniciando instalacion de programas" "INFO" "Cyan"

    # Verificar si Chocolatey esta instalado
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Log-Status "Chocolatey no instalado. Descargando..." "WARNING"
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
            Log-Status "Limpiando residuales de Chocolatey y reintentando..." "WARNING"
            Remove-Item -Recurse -Force "C:\ProgramData\chocolatey" -ErrorAction SilentlyContinue
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

            if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
                Log-Status "Error: No se pudo instalar Chocolatey" "ERROR"
                return
            }
        }
        Log-Status "Chocolatey instalado exitosamente" "SUCCESS"
    }

    Log-Status "Iniciando instalacion de paquetes..." "INFO" "Yellow"

    $programas = @(
        "vcredist-all",
        "googlechrome",
        "opera",
        "winrar",
        "anydesk.install",
        "notepadplusplus",
        "office365business",
        "adobereader"
    )

    $total = $programas.Count
    $contador = 0

    foreach ($programa in $programas) {
        $contador++
        Log-Status "Instalando $programa ($contador/$total)..." "INFO" "Yellow"
        choco install $programa -y
        if ($LASTEXITCODE -eq 0) {
            Log-Status "$programa instalado correctamente" "SUCCESS"
        } else {
            Log-Status "Error al instalar $programa" "ERROR"
        }
    }

    Log-Status "Instalacion de programas completada" "SUCCESS"
}

function Actualizar-Drivers {
    Write-Host "`n=== Actualizacion de Drivers con Driver Booster ===" -ForegroundColor Cyan
    
    # Verificar si Driver Booster esta instalado
    if (-not (Get-Command "C:\Program Files (x86)\IObit\Driver Booster\DriverBooster.exe" -ErrorAction SilentlyContinue)) {
        Write-Host "Driver Booster no esta instalado. Descargando e instalando..." -ForegroundColor Yellow
        
        $url = "https://cdn.iobit.com/dl/driver_booster_setup.exe"
        $installerPath = Join-Path $PSScriptRoot "driver_booster_setup.exe"
        
        try {
            Invoke-WebRequest -Uri $url -OutFile $installerPath -UseBasicParsing
            Write-Host "Descarga completada. Instalando Driver Booster..." -ForegroundColor Yellow
            Start-Process -FilePath $installerPath -ArgumentList "/silent" -Wait
            Remove-Item $installerPath
        }
        catch {
            Write-Host "Error al descargar o instalar Driver Booster: $_" -ForegroundColor Red
            return
        }
    }
    
    Write-Host "Iniciando Driver Booster..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "C:\Program Files (x86)\IObit\Driver Booster\DriverBooster.exe" -ArgumentList "/scan /update /silent" -Wait
        Write-Host "Actualizacion de drivers completada." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al ejecutar Driver Booster: $_" -ForegroundColor Red
    }
}

function Personalizar-Escritorio {
    Write-Host "Personalizando el escritorio y la barra de tareas..." -ForegroundColor Cyan

    Write-Host "Ocultando el boton de vistas de tareas..." -ForegroundColor Yellow
    try {
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -PropertyType DWord -Force | Out-Null
    }
    catch {
        Write-Host "Error al ocultar el boton de vistas de tareas: $_" -ForegroundColor Red
    }

    Write-Host "Ocultando el cuadro de busqueda de la barra de tareas..." -ForegroundColor Yellow
    try {
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -PropertyType DWord -Force | Out-Null
    }
    catch {
        Write-Host "Error al ocultar el cuadro de busqueda de la barra de tareas: $_" -ForegroundColor Red
    }

    Write-Host "Desactivando noticias e intereses en la barra de tareas..." -ForegroundColor Yellow
    try {
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2 -PropertyType DWord -Force | Out-Null
    }
    catch {
        Write-Host "Error al desactivar noticias e intereses en la barra de tareas: $_" -ForegroundColor Red
    }
}

function Configurar-AnyDesk {
    Write-Host "Configurando AnyDesk..." -ForegroundColor Cyan
    try {
        $password = "Soporte2025"
        echo $password | & "C:\Program Files (x86)\AnyDeskMSI\AnyDeskMSI.exe" --set-password
        Write-Host "Contrasena de AnyDesk configurada correctamente." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al configurar la contrasena de AnyDesk: $_" -ForegroundColor Red
    }
}

function Activar-Office-Windows {
    Write-Host "Activando Office y Windows..." -ForegroundColor Cyan
    irm https://get.activated.win | iex
}

function Limpiar-Sistema {
    Log-Status "Iniciando limpieza del sistema" "INFO" "Cyan"
    try {
        Log-Status "Limpiando archivos temporales de Windows..." "INFO" "Yellow"
        Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Log-Status "Windows Temp limpiado" "SUCCESS"

        Log-Status "Limpiando archivos temporales del usuario..." "INFO" "Yellow"
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Log-Status "User Temp limpiado" "SUCCESS"

        Log-Status "Limpiando papelera de reciclaje..." "INFO" "Yellow"
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Log-Status "Papelera vaciada" "SUCCESS"

        Log-Status "Limpieza del sistema completada" "SUCCESS"
    }
    catch {
        Log-Status "Error durante la limpieza: $_" "ERROR"
    }
}

# =======================================
# MENU PRINCIPAL
# =======================================

do {
    Write-Host "`n" -ForegroundColor Magenta
    Log-Status "===== MENU DE AUTOMATIZACION =====" "INFO" "Magenta"
    Write-Host "1. Cambiar configuracion de red (IP y DNS)" -ForegroundColor White
    Write-Host "2. Instalar programas predeterminados" -ForegroundColor White
    Write-Host "3. Actualizacion de Drivers con Driver Booster" -ForegroundColor White
    Write-Host "4. Personalizar Escritorio y Barra de Tareas" -ForegroundColor White
    Write-Host "5. Configurar AnyDesk" -ForegroundColor White
    Write-Host "6. Activar Office y Windows" -ForegroundColor White
    Write-Host "7. Limpiar el Sistema" -ForegroundColor White
    Write-Host "0. Salir" -ForegroundColor Red
    Write-Host "=====================================" -ForegroundColor Magenta

    $option = Read-Host "`nSelecciona una opcion"
    Log-Status "Opcion seleccionada: $option" "INFO"
    
    switch ($option) {
        "1" { Configurar-IP }
        "2" { Instalar-Programas }
        "3" { Actualizar-Drivers }
        "4" { Personalizar-Escritorio }
        "5" { Configurar-AnyDesk }
        "6" { Activar-Office-Windows }
        "7" { Limpiar-Sistema }
        "0" { 
            Log-Status "Saliendo del menu..." "INFO"
            break 
        }
        default { 
            Log-Status "Opcion invalida, por favor elige de nuevo." "WARNING"
        }
    }
} while ($option -ne "0")

Log-Status "Script completado." "SUCCESS"
Write-Host "Presione ENTER para cerrar esta ventana." -ForegroundColor Cyan
Read-Host -Prompt "Presione ENTER"

Log-Status "Configuracion completada. Equipo listo." "SUCCESS"
