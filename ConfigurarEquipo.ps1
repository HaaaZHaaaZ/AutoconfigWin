# Banner de inicio
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

# Mostrar banner al inicio
Show-Banner

# -------------------------------
# Funciones para cada accion
# -------------------------------

function Configurar-IP {
    Write-Host "`n=== Configuracion de Red ===" -ForegroundColor Cyan
    $optionIP = Read-Host "¿Deseas configurar la direccion IP por DHCP? (s/n)"
    if ($optionIP -eq "s") {
        Write-Host "Configurando direccion IP por DHCP..." -ForegroundColor Yellow
        Invoke-Expression "netsh interface ip set address name='Ethernet' source=dhcp"
    }
    else {
        $ip = Read-Host "Ingresa la direccion IP (e.g., 192.168.1.100)"
        $subnet = Read-Host "Ingresa la mascara de subred (e.g., 255.255.255.0)"
        $gateway = Read-Host "Ingresa la puerta de enlace predeterminada (e.g., 192.168.1.1)"
        Write-Host "Configurando direccion IP estatica..." -ForegroundColor Yellow
        Invoke-Expression "netsh interface ip set address name='Ethernet' static $ip $subnet $gateway"
    }

    $optionDNS = Read-Host "¿Deseas configurar los DNS por DHCP? (s/n)"
    if ($optionDNS -eq "s") {
        Write-Host "Configurando DNS por DHCP..." -ForegroundColor Yellow
        Invoke-Expression "netsh interface ip set dns name='Ethernet' source=dhcp"
    }
    else {
        $dns1 = Read-Host "Ingresa el servidor DNS preferido (e.g., 8.8.8.8)"
        $dns2 = Read-Host "Ingresa el servidor DNS alternativo (e.g., 8.8.4.4)"
        Write-Host "Configurando servidores DNS personalizados..." -ForegroundColor Yellow
        Invoke-Expression "netsh interface ip set dns name='Ethernet' static $dns1"
        Invoke-Expression "netsh interface ip add dns name='Ethernet' $dns2 index=2"
    }
    Write-Host "Configuracion de red completada." -ForegroundColor Green
}


function Instalar-Programas {
    Write-Host "`n=== Instalacion de Programas Predeterminados ===" -ForegroundColor Cyan

    # Verificar si Chocolatey está instalado
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey no está instalado. Instalando..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        # Verificar nuevamente si Chocolatey se instaló correctamente
        if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Host "Error: Chocolatey no se pudo instalar. Eliminando carpeta residual y reintentando..." -ForegroundColor Red
            Remove-Item -Recurse -Force "C:\ProgramData\chocolatey"
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

            # Verificar una última vez si Chocolatey se instaló correctamente
            if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
                Write-Host "Error: Chocolatey no se pudo instalar después de reintentar." -ForegroundColor Red
                return
            }
        }
    }

    Write-Host "Instalando programas con Chocolatey..." -ForegroundColor Yellow

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

    foreach ($programa in $programas) {
        Write-Host "Instalando $programa..." -ForegroundColor Yellow
        choco install $programa -y
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error al instalar $programa" -ForegroundColor Red
        } else {
            Write-Host "$programa instalado correctamente." -ForegroundColor Green
        }
    }

    Write-Host "Instalacion de programas completada." -ForegroundColor Green
}

function Actualizar-Drivers {
    Write-Host "`n=== Actualizacion de Drivers con Driver Booster ===" -ForegroundColor Cyan
    
    # Verificar si Driver Booster está instalado
    if (-not (Get-Command "C:\Program Files (x86)\IObit\Driver Booster\DriverBooster.exe" -ErrorAction SilentlyContinue)) {
        Write-Host "Driver Booster no está instalado. Descargando e instalando..." -ForegroundColor Yellow
        
        # URL de descarga (ajusta la URL si es necesario)
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
        Write-Host "Actualización de drivers completada." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al ejecutar Driver Booster: $_" -ForegroundColor Red
    }
}

# -------------------------------
# Menu Principal
# -------------------------------

do {
    Write-Host "`n----------------------------------------" -ForegroundColor Magenta
    Write-Host "Menu de Automatizacion"
    Write-Host "1. Cambiar configuracion de red (IP y DNS)"
    Write-Host "2. Instalar programas predeterminados"
    Write-Host "3. Actualizacion de Drivers con Driver Booster"
    Write-Host "0. Salir"
    Write-Host "----------------------------------------" -ForegroundColor Magenta

    $option = Read-Host "Selecciona una opcion"
    
    switch ($option) {
        "1" { Configurar-IP }
        "2" { Instalar-Programas }
        "3" { Actualizar-Drivers }
        "0" { Write-Host "Saliendo del menu..."; break }
        default { Write-Host "Opcion invalida, por favor elige de nuevo." -ForegroundColor Red }
    }
} while ($true)
