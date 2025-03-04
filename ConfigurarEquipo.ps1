# Verificar si el script se está ejecutando con permisos de administrador
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script debe ejecutarse con permisos de administrador." -ForegroundColor Red
        Read-Host -Prompt "Presione ENTER para cerrar esta ventana"
        exit
    }
}

# Ejecutar la verificación de permisos de administrador
Test-Admin

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