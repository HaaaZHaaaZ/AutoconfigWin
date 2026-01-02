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

# Funcion de logging simplificada (sin barra de estado)
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

# Alias para compatibilidad
function Write-StatusLog {
    param([string]$Message, [string]$Level = "INFO", [string]$Color = "White")
    Log-Status -Message $Message -Level $Level -Color $Color
}

# Inicializacion visual
Show-Loading
Show-HaZBanner

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
        }
        else {
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
        }
        else {
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


function Optimizar-Windows {
    Log-Status "Iniciando optimizacion de Windows (Rendimiento y Privacidad)" "INFO" "Cyan"

    # 1. Plan de Energia: Maximo Rendimiento
    Log-Status "Configurando Plan de Energia..." "INFO" "Yellow"
    try {
        # Duplicar esquema de alto rendimiento para asegurar que exista Ultimate Performance si es compatible
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        Log-Status "Plan de energia 'Maximo Rendimiento' activado" "SUCCESS"
    }
    catch {
        $highPerf = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        powercfg -setactive $highPerf | Out-Null
        Log-Status "Plan de energia 'Alto Rendimiento' activado" "SUCCESS"
    }

    # 2. Desactivar Telemetria y Servicios Innecesarios
    Log-Status "Desactivando telemetria y servicios en segundo plano..." "INFO" "Yellow"
    $services = @(
        "DiagTrack",             # Telemetria
        "dmwappushservice",      # Enrutamiento de mensajes push WAP (Telemetria)
        "SysMain",               # Superfetch (A veces causa alto uso de disco, opcional)
        "MapsBroker",            # Mapas descargados
        "WerSvc"                 # Reporte de errores de Windows
    )

    foreach ($service in $services) {
        if (Get-Service $service -ErrorAction SilentlyContinue) {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            Log-Status "Servicio $service desactivado" "SUCCESS"
        }
    }

    # 3. Desactivar Game DVR y Modo Juego (Barra de juegos)
    Log-Status "Optimizando configuracion de juegos (GameDVR)..." "INFO" "Yellow"
    try {
        $regPath = "HKCU:\System\GameConfigStore"
        if (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
        New-ItemProperty -Path $regPath -Name "GameDVR_Enabled" -Value 0 -PropertyType DWord -Force | Out-Null
        
        $regPath2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
        if (!(Test-Path $regPath2)) { New-Item -Path $regPath2 -Force | Out-Null }
        New-ItemProperty -Path $regPath2 -Name "AllowGameDVR" -Value 0 -PropertyType DWord -Force | Out-Null
        
        Log-Status "GameDVR desactivado (mejora rendimiento en juegos)" "SUCCESS"
    }
    catch {
        Log-Status "No se pudo desactivar todo el GameDVR: $_" "WARNING"
    }

    # 4. Desactivar Cortana
    Log-Status "Desactivando Cortana..." "INFO" "Yellow"
    try {
        $regPathCortana = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (!(Test-Path $regPathCortana)) { New-Item -Path $regPathCortana -Force | Out-Null }
        New-ItemProperty -Path $regPathCortana -Name "AllowCortana" -Value 0 -PropertyType DWord -Force | Out-Null
        Log-Status "Cortana desactivada" "SUCCESS"
    }
    catch {
        Log-Status "Error al desactivar Cortana: $_" "WARNING"
    }


    Log-Status "Optimizacion completada. Reinicia para aplicar todos los cambios." "SUCCESS"
}

function Restaurar-Windows {
    Log-Status "Iniciando ROLLBACK de optimizaciones..." "INFO" "Cyan"

    # 1. Restaurar Plan de Energia (Equilibrado)
    Log-Status "Restaurando plan de energia (Equilibrado)..." "INFO" "Yellow"
    try {
        powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e | Out-Null
        Log-Status "Plan de energia 'Equilibrado' activado" "SUCCESS"
    }
    catch {
        Log-Status "No se pudo restaurar el plan de energia (hazlo manualmente desde Panel de Control)" "WARNING"
    }

    # 2. Reactivar Servicios
    Log-Status "Reactivando servicios del sistema..." "INFO" "Yellow"
    $services = @(
        "DiagTrack",
        "dmwappushservice",
        "SysMain",
        "MapsBroker",
        "WerSvc"
    )

    foreach ($service in $services) {
        try {
            Set-Service -Name $service -StartupType Automatic -ErrorAction SilentlyContinue
            Start-Service -Name $service -ErrorAction SilentlyContinue
            Log-Status "Servicio $service restaurado" "SUCCESS"
        }
        catch {
            Log-Status "No se pudo restaurar servicio $service" "WARNING"
        }
    }

    # 3. Reactivar GameDVR
    Log-Status "Reactivando GameDVR..." "INFO" "Yellow"
    try {
        New-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -PropertyType DWord -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 1 -PropertyType DWord -Force | Out-Null
        Log-Status "GameDVR reactivado" "SUCCESS"
    }
    catch {
        Log-Status "Error al reactivar GameDVR" "WARNING"
    }

    # 4. Reactivar Cortana
    Log-Status "Reactivando Cortana..." "INFO" "Yellow"
    try {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 1 -PropertyType DWord -Force | Out-Null
        Log-Status "Cortana reactivada" "SUCCESS"
    }
    catch {
        Log-Status "Error al reactivar Cortana" "WARNING"
    }

    Log-Status "Rollback completado. Reinicia tu equipo." "SUCCESS"
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
    Write-Host "8. Optimizar Windows (Rendimiento/Privacidad)" -ForegroundColor Green
    Write-Host "9. Deshacer Optimizaciones (Rollback)" -ForegroundColor Yellow
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
        "8" { Optimizar-Windows }
        "9" { Restaurar-Windows }
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
