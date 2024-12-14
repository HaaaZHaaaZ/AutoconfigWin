# Configuración inicial
Write-Host "Iniciando configuración automatizada del equipo..." -ForegroundColor Cyan

# 1. Configuración de Red
Write-Host "Configurando red..." -ForegroundColor Cyan

# Opciones de configuración de red
$useDHCPIP = Read-Host "¿Deseas configurar la dirección IP por DHCP? (s/n)"
if ($useDHCPIP -eq "s") {
    Write-Host "Configurando dirección IP por DHCP..." -ForegroundColor Yellow
    Invoke-Expression "netsh interface ip set address name='Ethernet' source=dhcp"
} else {
    $ip = Read-Host "Ingresa la dirección IP (e.g., 192.168.1.100)"
    $subnet = Read-Host "Ingresa la máscara de subred (e.g., 255.255.255.0)"
    $gateway = Read-Host "Ingresa la puerta de enlace predeterminada (e.g., 192.168.1.1)"
    Write-Host "Configurando dirección IP estática..." -ForegroundColor Yellow
    Invoke-Expression "netsh interface ip set address name='Ethernet' static $ip $subnet $gateway"
}

$useDHCPDNS = Read-Host "¿Deseas configurar los DNS por DHCP? (s/n)"
if ($useDHCPDNS -eq "s") {
    Write-Host "Configurando DNS por DHCP..." -ForegroundColor Yellow
    Invoke-Expression "netsh interface ip set dns name='Ethernet' source=dhcp"
} else {
    $dns1 = Read-Host "Ingresa el servidor DNS preferido (e.g., 8.8.8.8)"
    $dns2 = Read-Host "Ingresa el servidor DNS alternativo (e.g., 8.8.4.4)"
    Write-Host "Configurando servidores DNS personalizados..." -ForegroundColor Yellow
    Invoke-Expression "netsh interface ip set dns name='Ethernet' static $dns1"
    Invoke-Expression "netsh interface ip add dns name='Ethernet' $dns2 index=2"
}

# Pausa con barra de progreso
Write-Host "Esperando 30 segundos para aplicar los cambios de red..." -ForegroundColor Yellow
$duration = 15
for ($i = 0; $i -le $duration; $i++) {
    $percentComplete = ($i / $duration) * 100
    Write-Progress -Activity "Aplicando cambios de red" `
                   -Status "Tiempo restante: $($duration - $i) segundos" `
                   -PercentComplete $percentComplete
    Start-Sleep -Seconds 1
}
Write-Host "Cambios de red aplicados exitosamente." -ForegroundColor Green

# 2. Verificar e instalar Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey no está instalado. Instalando ahora..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Comprobación de instalación exitosa
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Error: No se pudo instalar Chocolatey. Por favor, verifica manualmente." -ForegroundColor Red
        exit
    }

    Write-Host "Chocolatey instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "Chocolatey ya está instalado." -ForegroundColor Green
}

# Validar que Chocolatey esté en el PATH
$chocoPath = "C:\ProgramData\chocolatey\bin"
if ($env:Path -notlike "*$chocoPath*") {
    Write-Host "Agregando Chocolatey al PATH del sistema..." -ForegroundColor Yellow
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$chocoPath", [System.EnvironmentVariableTarget]::Machine)
    Write-Host "Chocolatey agregado al PATH correctamente." -ForegroundColor Green

    # Reiniciar la sesión de PowerShell para cargar el PATH actualizado
    Write-Host "Reiniciando sesión de PowerShell para aplicar cambios en el PATH..." -ForegroundColor Yellow
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 3. Instalar programas
Write-Host "Instalando programas principales..." -ForegroundColor Cyan
choco install googlechrome -y
choco install opera -y
choco install winrar -y
choco install anydesk.install -y
choco install notepadplusplus -y
choco install office365business -y
choco install adobereader -y
choco install vcredist-all -y
Write-Host "Programas instalados correctamente." -ForegroundColor Green

# 4. Instalar controladores con Snappy Driver Installer
$SDIPath = Join-Path $PSScriptRoot "SDI\SDI_R2408.exe"
if (Test-Path $SDIPath) {
    Write-Host "Iniciando instalación de controladores con Snappy Driver Installer..." -ForegroundColor Cyan
    Start-Process -FilePath $SDIPath -ArgumentList "/autoinstall /autoclose" -Wait
    Write-Host "Instalación de controladores completada." -ForegroundColor Green
} else {
    Write-Host "Snappy Driver Installer no encontrado. Por favor verifica la ubicación." -ForegroundColor Red
}

# Personalización del Escritorio y Barra de Tareas
Write-Host "Personalizando el escritorio y la barra de tareas..." -ForegroundColor Cyan

# Ocultar el botón de vistas de tareas de la barra de tareas
Write-Host "Ocultando el botón de vistas de tareas..." -ForegroundColor Yellow
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -PropertyType DWord -Force | Out-Null

# Ocultar el cuadro de búsqueda de la barra de tareas
Write-Host "Ocultando el cuadro de búsqueda de la barra de tareas..." -ForegroundColor Yellow
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -PropertyType DWord -Force | Out-Null

# Desactivar Noticias e intereses de la barra de tareas
Write-Host "Desactivando noticias e intereses en la barra de tareas..." -ForegroundColor Yellow
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2 -PropertyType DWord -Force | Out-Null

#Activacion Office y Windows

irm https://massgrave.dev/get | iex

# Pausa para verificar errores
Write-Host "Script completado. Presione ENTER para cerrar esta ventana." -ForegroundColor Cyan
Read-Host -Prompt "Presione ENTER para finalizar"


# Finalización
Write-Host "Configuración completada. ¡El equipo está listo para usar!" -ForegroundColor Cyan
