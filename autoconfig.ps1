# Script de Automatización para Windows - Versión Mejorada
# Requiere permisos de administrador

# Verificar si el script se está ejecutando con permisos de administrador
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script debe ejecutarse con permisos de administrador." -ForegroundColor Red
        Write-Host "Reiniciando como administrador..." -ForegroundColor Yellow
        Start-Process PowerShell -Verb RunAs "-File `"$PSCommandPath`""
        exit
    }
}

# Ejecutar la verificación de permisos de administrador
Test-Admin

# Configurar política de ejecución
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Banner de inicio mejorado
function Show-Banner {
    Clear-Host
    $banner = @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    ██╗    ██╗ ██╗███╗   ██╗    ██████╗  ██████╗ ████████╗   ║
║    ██║    ██║ ██║████╗  ██║    ██╔══██╗██╔═══██╗╚══██╔══╝   ║
║    ██║ █╗ ██║ ██║██╔██╗ ██║    ██████╔╝██║   ██║   ██║      ║
║    ██║███╗██║ ██║██║╚██╗██║    ██╔══██╗██║   ██║   ██║      ║
║    ╚███╔███╔╝ ██║██║ ╚████║    ██████╔╝╚██████╔╝   ██║      ║
║     ╚══╝╚══╝  ╚═╝╚═╝  ╚═══╝    ╚═════╝  ╚═════╝    ╚═╝      ║
║                                                              ║
║          SCRIPT DE AUTOMATIZACIÓN PARA WINDOWS              ║
║                    Versión Mejorada v2.0                    ║
╚══════════════════════════════════════════════════════════════╝
"@
    Write-Host $banner -ForegroundColor Cyan
    Write-Host ""
}

# Función para logging mejorado
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        default { Write-Host $logMessage -ForegroundColor White }
    }
}

# Función para crear punto de restauración
function Create-RestorePoint {
    Write-Log "Creando punto de restauración del sistema..." "INFO"
    try {
        Enable-ComputerRestore -Drive "C:\"
        Checkpoint-Computer -Description "Antes de ejecutar script de automatización" -RestorePointType "APPLICATION_INSTALL"
        Write-Log "Punto de restauración creado exitosamente." "SUCCESS"
    }
    catch {
        Write-Log "No se pudo crear el punto de restauración: $_" "WARNING"
    }
}

# Función mejorada para obtener adaptador de red activo
function Get-ActiveNetworkAdapter {
    Write-Log "Buscando adaptador de red activo..." "INFO"
    
    $adapters = Get-NetAdapter | Where-Object { 
        $_.Status -eq "Up" -and 
        $_.MediaType -ne "Unspecified" -and
        $_.Name -notlike "*Loopback*"
    } | Sort-Object LinkSpeed -Descending
    
    foreach ($adapter in $adapters) {
        try {
            $ipConfig = Get-NetIPConfiguration -InterfaceAlias $adapter.Name -ErrorAction SilentlyContinue
            if ($ipConfig.IPv4Address -and (Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet)) {
                Write-Log "Adaptador activo encontrado: $($adapter.Name)" "SUCCESS"
                return $adapter.Name
            }
        }
        catch {
            continue
        }
    }
    return $null
}

function Configurar-IP {
    Write-Host "`n=== CONFIGURACIÓN DE RED ===" -ForegroundColor Cyan
    
    $adapterName = Get-ActiveNetworkAdapter
    if ($null -eq $adapterName) {
        Write-Log "No se encontró un adaptador de red con conexión a Internet." "ERROR"
        return
    }
    
    Write-Log "Adaptador de red activo: $adapterName" "INFO"

    # Mostrar configuración actual
    try {
        $currentConfig = Get-NetIPConfiguration -InterfaceAlias $adapterName
        Write-Host "`nConfiguración actual:" -ForegroundColor Yellow
        Write-Host "IP: $($currentConfig.IPv4Address.IPAddress)"
        Write-Host "Gateway: $($currentConfig.IPv4DefaultGateway.NextHop)"
        Write-Host "DNS: $($currentConfig.DNSServer.ServerAddresses -join ', ')"
    }
    catch {
        Write-Log "No se pudo obtener la configuración actual." "WARNING"
    }

    # Configuración IP
    do {
        $optionIP = Read-Host "`n¿Deseas configurar la dirección IP por DHCP? (s/n)"
    } while ($optionIP -notin @('s', 'n', 'S', 'N'))
    
    if ($optionIP.ToLower() -eq "s") {
        Write-Log "Configurando dirección IP por DHCP..." "INFO"
        try {
            Remove-NetIPAddress -InterfaceAlias $adapterName -Confirm:$false -ErrorAction SilentlyContinue
            Remove-NetRoute -InterfaceAlias $adapterName -Confirm:$false -ErrorAction SilentlyContinue
            Set-NetIPInterface -InterfaceAlias $adapterName -Dhcp Enabled
            Write-Log "IP configurada por DHCP exitosamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al configurar DHCP: $_" "ERROR"
        }
    }
    else {
        # Validación de entrada para IP estática
        do {
            $ip = Read-Host "Ingresa la dirección IP (ej: 192.168.1.100)"
        } while (-not ($ip -match '^(\d{1,3}\.){3}\d{1,3}$'))
        
        do {
            $subnet = Read-Host "Ingresa la máscara de subred (ej: 255.255.255.0)"
        } while (-not ($subnet -match '^(\d{1,3}\.){3}\d{1,3}$'))
        
        do {
            $gateway = Read-Host "Ingresa la puerta de enlace predeterminada (ej: 192.168.1.1)"
        } while (-not ($gateway -match '^(\d{1,3}\.){3}\d{1,3}$'))
        
        Write-Log "Configurando dirección IP estática..." "INFO"
        try {
            Remove-NetIPAddress -InterfaceAlias $adapterName -Confirm:$false -ErrorAction SilentlyContinue
            Remove-NetRoute -InterfaceAlias $adapterName -Confirm:$false -ErrorAction SilentlyContinue
            
            New-NetIPAddress -InterfaceAlias $adapterName -IPAddress $ip -PrefixLength 24 -DefaultGateway $gateway
            Write-Log "IP estática configurada exitosamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al configurar IP estática: $_" "ERROR"
        }
    }

    # Configuración DNS
    do {
        $optionDNS = Read-Host "`n¿Deseas configurar los DNS por DHCP? (s/n)"
    } while ($optionDNS -notin @('s', 'n', 'S', 'N'))
    
    if ($optionDNS.ToLower() -eq "s") {
        Write-Log "Configurando DNS por DHCP..." "INFO"
        try {
            Set-DnsClientServerAddress -InterfaceAlias $adapterName -ResetServerAddresses
            Write-Log "DNS configurado por DHCP exitosamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al configurar DNS por DHCP: $_" "ERROR"
        }
    }
    else {
        Write-Host "`nOpciones de DNS disponibles:"
        Write-Host "1. AdGuard DNS (94.140.14.14, 94.140.15.15)"
        Write-Host "2. Cloudflare DNS (1.1.1.1, 1.0.0.1)"
        Write-Host "3. Google DNS (8.8.8.8, 8.8.4.4)"
        Write-Host "4. OpenDNS (208.67.222.222, 208.67.220.220)"
        Write-Host "5. DNS personalizado"
        
        do {
            $dnsChoice = Read-Host "Selecciona una opción (1-5)"
        } while ($dnsChoice -notin @('1', '2', '3', '4', '5'))
        
        switch ($dnsChoice) {
            "1" { $dns1 = "94.140.14.14"; $dns2 = "94.140.15.15" }
            "2" { $dns1 = "1.1.1.1"; $dns2 = "1.0.0.1" }
            "3" { $dns1 = "8.8.8.8"; $dns2 = "8.8.4.4" }
            "4" { $dns1 = "208.67.222.222"; $dns2 = "208.67.220.220" }
            "5" { 
                do {
                    $dns1 = Read-Host "Ingresa el servidor DNS preferido"
                } while (-not ($dns1 -match '^(\d{1,3}\.){3}\d{1,3}$'))
                
                do {
                    $dns2 = Read-Host "Ingresa el servidor DNS alternativo"
                } while (-not ($dns2 -match '^(\d{1,3}\.){3}\d{1,3}$'))
            }
        }
        
        Write-Log "Configurando servidores DNS: $dns1, $dns2..." "INFO"
        try {
            Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses $dns1, $dns2
            Write-Log "Servidores DNS configurados exitosamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al configurar servidores DNS: $_" "ERROR"
        }
    }
    
    # Limpiar caché DNS
    Write-Log "Limpiando caché DNS..." "INFO"
    ipconfig /flushdns | Out-Null
    
    Write-Log "Configuración de red completada." "SUCCESS"
}

function Instalar-Programas {
    Write-Host "`n=== INSTALACIÓN DE PROGRAMAS PREDETERMINADOS ===" -ForegroundColor Cyan

    # Verificar conexión a Internet
    if (-not (Test-Connection -ComputerName "google.com" -Count 2 -Quiet)) {
        Write-Log "No hay conexión a Internet. No se pueden instalar programas." "ERROR"
        return
    }

    # Verificar e instalar Chocolatey
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Log "Chocolatey no está instalado. Instalando..." "INFO"
        try {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            
            # Refrescar variables de entorno
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
            
            Write-Log "Chocolatey instalado exitosamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al instalar Chocolatey: $_" "ERROR"
            return
        }
    }

    # Lista mejorada de programas con categorías
    $programasEsenciales = @{
        "Navegadores" = @("googlechrome", "firefox", "opera")
        "Herramientas" = @("7zip", "winrar", "notepadplusplus.install")
        "Comunicación" = @("anydesk.install", "teamviewer", "discord")
        "Multimedia" = @("vlc", "paint.net", "audacity")
        "Desarrollo" = @("vscode", "git", "python3")
        "Oficina" = @("adobereader", "libreoffice-fresh")
        "Sistema" = @("vcredist-all", "dotnetfx", "directx")
    }

    Write-Host "`nCategorías de software disponibles:"
    $categorias = $programasEsenciales.Keys | Sort-Object
    for ($i = 0; $i -lt $categorias.Count; $i++) {
        Write-Host "$($i + 1). $($categorias[$i])"
    }
    Write-Host "$($categorias.Count + 1). Instalar todo"
    Write-Host "$($categorias.Count + 2). Instalación personalizada"

    do {
        $seleccion = Read-Host "`nSelecciona una opción (1-$($categorias.Count + 2))"
    } while (-not ($seleccion -match '^\d+$') -or [int]$seleccion -lt 1 -or [int]$seleccion -gt ($categorias.Count + 2))

    $programasAInstalar = @()

    if ([int]$seleccion -eq ($categorias.Count + 1)) {
        # Instalar todo
        $programasAInstalar = $programasEsenciales.Values | ForEach-Object { $_ }
    }
    elseif ([int]$seleccion -eq ($categorias.Count + 2)) {
        # Instalación personalizada
        Write-Host "`nProgramas disponibles:"
        $todosLosProgramas = $programasEsenciales.Values | ForEach-Object { $_ } | Sort-Object
        for ($i = 0; $i -lt $todosLosProgramas.Count; $i++) {
            Write-Host "$($i + 1). $($todosLosProgramas[$i])"
        }
        
        do {
            $indices = Read-Host "Ingresa los números de los programas a instalar (separados por comas)"
            $indicesArray = $indices -split ',' | ForEach-Object { $_.Trim() }
            $valido = $true
            foreach ($indice in $indicesArray) {
                if (-not ($indice -match '^\d+$') -or [int]$indice -lt 1 -or [int]$indice -gt $todosLosProgramas.Count) {
                    $valido = $false
                    break
                }
            }
        } while (-not $valido)
        
        $programasAInstalar = $indicesArray | ForEach-Object { $todosLosProgramas[[int]$_ - 1] }
    }
    else {
        # Instalar categoría específica
        $categoriaSeleccionada = $categorias[[int]$seleccion - 1]
        $programasAInstalar = $programasEsenciales[$categoriaSeleccionada]
    }

    # Instalar programas seleccionados
    $totalProgramas = $programasAInstalar.Count
    $contador = 0

    foreach ($programa in $programasAInstalar) {
        $contador++
        Write-Log "Instalando $programa ($contador de $totalProgramas)..." "INFO"
        
        try {
            $result = choco install $programa -y --no-progress --limit-output 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "$programa instalado correctamente." "SUCCESS"
            }
            else {
                Write-Log "Error al instalar $programa. Código de salida: $LASTEXITCODE" "ERROR"
            }
        }
        catch {
            Write-Log "Error al instalar $programa: $_" "ERROR"
        }
    }

    Write-Log "Instalación de programas completada." "SUCCESS"
}

function Actualizar-Sistema {
    Write-Host "`n=== ACTUALIZACIÓN DEL SISTEMA ===" -ForegroundColor Cyan
    
    # Verificar e instalar PSWindowsUpdate si no está disponible
    if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Log "Instalando módulo PSWindowsUpdate..." "INFO"
        try {
            Install-Module PSWindowsUpdate -Force -AllowClobber
            Write-Log "Módulo PSWindowsUpdate instalado." "SUCCESS"
        }
        catch {
            Write-Log "Error al instalar PSWindowsUpdate: $_" "ERROR"
            return
        }
    }

    Import-Module PSWindowsUpdate

    Write-Log "Buscando actualizaciones de Windows..." "INFO"
    try {
        $updates = Get-WindowsUpdate
        if ($updates) {
            Write-Log "Se encontraron $($updates.Count) actualizaciones disponibles." "INFO"
            
            $instalarActualizaciones = Read-Host "¿Deseas instalar las actualizaciones ahora? (s/n)"
            if ($instalarActualizaciones.ToLower() -eq 's') {
                Write-Log "Instalando actualizaciones de Windows..." "INFO"
                Install-WindowsUpdate -AcceptAll -AutoReboot:$false
                Write-Log "Actualizaciones instaladas. Es recomendable reiniciar el sistema." "SUCCESS"
            }
        }
        else {
            Write-Log "No se encontraron actualizaciones disponibles." "INFO"
        }
    }
    catch {
        Write-Log "Error al buscar actualizaciones: $_" "ERROR"
    }
}

function Personalizar-Escritorio {
    Write-Host "`n=== PERSONALIZACIÓN DEL ESCRITORIO ===" -ForegroundColor Cyan

    Write-Log "Aplicando personalizaciones del escritorio..." "INFO"

    $personalizaciones = @{
        "Ocultar botón de vistas de tareas" = @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "ShowTaskViewButton"
            Value = 0
        }
        "Ocultar cuadro de búsqueda" = @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
            Name = "SearchboxTaskbarMode"
            Value = 0
        }
        "Desactivar noticias e intereses" = @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
            Name = "ShellFeedsTaskbarViewMode"
            Value = 2
        }
        "Mostrar extensiones de archivos" = @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "HideFileExt"
            Value = 0
        }
        "Mostrar archivos ocultos" = @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "Hidden"
            Value = 1
        }
        "Desactivar animaciones" = @{
            Path = "HKCU:\Control Panel\Desktop\WindowMetrics"
            Name = "MinAnimate"
            Value = "0"
        }
    }

    foreach ($personalizacion in $personalizaciones.GetEnumerator()) {
        try {
            if (!(Test-Path $personalizacion.Value.Path)) {
                New-Item -Path $personalizacion.Value.Path -Force | Out-Null
            }
            
            New-ItemProperty -Path $personalizacion.Value.Path -Name $personalizacion.Value.Name -Value $personalizacion.Value.Value -PropertyType DWord -Force | Out-Null
            Write-Log "$($personalizacion.Key) aplicado correctamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al aplicar $($personalizacion.Key): $_" "ERROR"
        }
    }

    Write-Log "Reiniciando Explorer para aplicar cambios..." "INFO"
    try {
        Stop-Process -Name explorer -Force
        Start-Sleep -Seconds 2
        Start-Process explorer
        Write-Log "Explorer reiniciado exitosamente." "SUCCESS"
    }
    catch {
        Write-Log "Error al reiniciar Explorer: $_" "ERROR"
    }
}

function Configurar-AnyDesk {
    Write-Host "`n=== CONFIGURACIÓN DE ANYDESK ===" -ForegroundColor Cyan
    
    $anydeskPaths = @(
        "C:\Program Files (x86)\AnyDesk\AnyDesk.exe",
        "C:\Program Files\AnyDesk\AnyDesk.exe",
        "$env:APPDATA\AnyDesk\AnyDesk.exe"
    )
    
    $anydeskPath = $null
    foreach ($path in $anydeskPaths) {
        if (Test-Path $path) {
            $anydeskPath = $path
            break
        }
    }
    
    if (-not $anydeskPath) {
        Write-Log "AnyDesk no está instalado. Instálalo primero desde el menú de programas." "ERROR"
        return
    }
    
    Write-Log "Configurando AnyDesk..." "INFO"
    
    try {
        # Configurar contraseña
        $password = Read-Host "Ingresa la contraseña para AnyDesk (o presiona Enter para usar 'Soporte2025')"
        if ([string]::IsNullOrEmpty($password)) {
            $password = "Soporte2025"
        }
        
        # Ejecutar AnyDesk con configuración
        $anydeskDir = Split-Path $anydeskPath
        Set-Location $anydeskDir
        
        & $anydeskPath --set-password $password
        & $anydeskPath --start-service
        
        Write-Log "AnyDesk configurado con contraseña: $password" "SUCCESS"
        
        # Mostrar ID de AnyDesk
        Start-Sleep -Seconds 3
        $anydeskId = & $anydeskPath --get-id
        if ($anydeskId) {
            Write-Log "ID de AnyDesk: $anydeskId" "SUCCESS"
        }
    }
    catch {
        Write-Log "Error al configurar AnyDesk: $_" "ERROR"
    }
}

function Activar-Office-Windows {
    Write-Host "`n=== ACTIVACIÓN DE OFFICE Y WINDOWS ===" -ForegroundColor Cyan
    
    Write-Host "ADVERTENCIA: Este proceso utiliza herramientas de activación de terceros." -ForegroundColor Yellow
    Write-Host "Asegúrate de cumplir con las licencias de software correspondientes." -ForegroundColor Yellow
    
    $continuar = Read-Host "¿Deseas continuar? (s/n)"
    if ($continuar.ToLower() -ne 's') {
        Write-Log "Activación cancelada por el usuario." "INFO"
        return
    }
    
    Write-Log "Ejecutando herramienta de activación Microsoft Activation Scripts..." "INFO"
    
    try {
        # Descargar y ejecutar Microsoft Activation Scripts
        $response = Invoke-WebRequest -Uri "https://massgrave.dev/get" -UseBasicParsing
        Invoke-Expression $response.Content
        Write-Log "Herramienta de activación ejecutada." "SUCCESS"
    }
    catch {
        Write-Log "Error al ejecutar la herramienta de activación: $_" "ERROR"
    }
}

function Limpiar-Sistema {
    Write-Host "`n=== LIMPIEZA DEL SISTEMA ===" -ForegroundColor Cyan
    
    $limpiezas = @{
        "Archivos temporales de Windows" = @{
            Action = { Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue }
        }
        "Archivos temporales de usuario" = @{
            Action = { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue }
        }
        "Papelera de reciclaje" = @{
            Action = { Clear-RecycleBin -Force -ErrorAction SilentlyContinue }
        }
        "Caché de Windows Update" = @{
            Action = { 
                Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                Start-Service wuauserv -ErrorAction SilentlyContinue
            }
        }
        "Archivos de registro antiguos" = @{
            Action = { Get-ChildItem -Path "C:\Windows\Logs" -Recurse -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force -ErrorAction SilentlyContinue }
        }
        "Caché DNS" = @{
            Action = { ipconfig /flushdns | Out-Null }
        }
    }

    foreach ($limpieza in $limpiezas.GetEnumerator()) {
        Write-Log "Limpiando: $($limpieza.Key)..." "INFO"
        try {
            & $limpieza.Value.Action
            Write-Log "$($limpieza.Key) limpiado exitosamente." "SUCCESS"
        }
        catch {
            Write-Log "Error al limpiar $($limpieza.Key): $_" "ERROR"
        }
    }

    # Ejecutar Liberador de espacio en disco
    Write-Log "Ejecutando Liberador de espacio en disco..." "INFO"
    try {
        Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait -NoNewWindow
        Write-Log "Liberador de espacio ejecutado." "SUCCESS"
    }
    catch {
        Write-Log "Error al ejecutar el liberador de espacio: $_" "ERROR"
    }
}

function Optimizar-Sistema {
    Write-Host "`n=== OPTIMIZACIÓN DEL SISTEMA ===" -ForegroundColor Cyan
    
    Write-Log "Aplicando optimizaciones del sistema..." "INFO"
    
    # Desactivar servicios innecesarios
    $serviciosADesactivar = @(
        "Fax",
        "WSearch",
        "TabletInputService",
        "WMPNetworkSvc"
    )
    
    foreach ($servicio in $serviciosADesactivar) {
        try {
            if (Get-Service -Name $servicio -ErrorAction SilentlyContinue) {
                Stop-Service -Name $servicio -Force -ErrorAction SilentlyContinue
                Set-Service -Name $servicio -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Log "Servicio $servicio desactivado." "SUCCESS"
            }
        }
        catch {
            Write-Log "Error al desactivar servicio $servicio: $_" "ERROR"
        }
    }
    
    # Optimizar plan de energía
    try {
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  # Alto rendimiento
        Write-Log "Plan de energía configurado a Alto Rendimiento." "SUCCESS"
    }
    catch {
        Write-Log "Error al configurar plan de energía: $_" "ERROR"
    }
    
    # Desactivar programas de inicio innecesarios
    Write-Log "Optimizando programas de inicio..." "INFO"
    try {
        $startupItems = Get-CimInstance Win32_StartupCommand
        foreach ($item in $startupItems) {
            if ($item.Name -match "Spotify|Skype|Teams|Steam") {
                Write-Log "Programa de inicio encontrado: $($item.Name)" "INFO"
            }
        }
    }
    catch {
        Write-Log "Error al analizar programas de inicio: $_" "ERROR"
    }
}

function Mostrar-InfoSistema {
    Write-Host "`n=== INFORMACIÓN DEL SISTEMA ===" -ForegroundColor Cyan
    
    try {
        $computerInfo = Get-ComputerInfo
        $networkConfig = Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq "Up" }
        
        Write-Host "`nInformación del Hardware:" -ForegroundColor Yellow
        Write-Host "Procesador: $($computerInfo.CsProcessors.Name)"
        Write-Host "Memoria RAM: $([Math]::Round($computerInfo.CsTotalPhysicalMemory / 1GB, 2)) GB"
        Write-Host "Sistema Operativo: $($computerInfo.WindowsProductName)"
        Write-Host "Versión: $($computerInfo.WindowsVersion)"
        Write-Host "Espacio en disco C: $([Math]::Round((Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB, 2)) GB libres"
        
        Write-Host "`nConfiguración de Red:" -ForegroundColor Yellow
        foreach ($config in $networkConfig) {
            Write-Host "Adaptador: $($config.InterfaceAlias)"
            Write-Host "IP: $($config.IPv4Address.IPAddress)"
            Write-Host "Gateway: $($config.IPv4DefaultGateway.NextHop)"
            Write-Host "DNS: $($config.DNSServer.ServerAddresses -join ', ')"
            Write-Host "---"
        }
        
        # Mostrar programas instalados recientemente
        Write-Host "`nProgramas instalados recientemente:" -ForegroundColor Yellow
        $recentPrograms = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
                         Where-Object { $_.InstallDate -and $_.InstallDate -gt (Get-Date).AddDays(-30).ToString("yyyyMMdd") } |
                         Sort-Object InstallDate -Descending |
                         Select-Object DisplayName, InstallDate -First 10
        
        foreach ($program in $recentPrograms) {
            Write-Host "- $($program.DisplayName) (Instalado: $($program.InstallDate))"
        }
    }
    catch {
        Write-Log "Error al obtener información del sistema: $_" "ERROR"
    }
}

function Crear-Backup {
    Write-Host "`n=== CREACIÓN DE BACKUP ===" -ForegroundColor Cyan
    
    $backupPath = Read-Host "Ingresa la ruta donde guardar el backup (ej: D:\Backup)"
    
    if (-not (Test-Path $backupPath)) {
        try {
            New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
            Write-Log "Directorio de backup creado: $backupPath" "SUCCESS"
        }
        catch {
            Write-Log "Error al crear directorio de backup: $_" "ERROR"
            return
        }
    }
    
    $backupDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $backupFolder = Join-Path $backupPath "SystemBackup_$backupDate"
    
    Write-Log "Creando backup del sistema en: $backupFolder" "INFO"
    
    try {
        New-Item -Path $backupFolder -ItemType Directory | Out-Null
        
        # Backup de configuraciones del registro
        Write-Log "Realizando backup del registro..." "INFO"
        $registryBackup = Join-Path $backupFolder "Registry"
        New-Item -Path $registryBackup -ItemType Directory | Out-Null
        
        reg export "HKEY_LOCAL_MACHINE\SOFTWARE" "$registryBackup\HKLM_SOFTWARE.reg" /y
        reg export "HKEY_CURRENT_USER\Software" "$registryBackup\HKCU_SOFTWARE.reg" /y
        
        # Backup de drivers
        Write-Log "Realizando backup de drivers..." "INFO"
        $driversBackup = Join-Path $backupFolder "Drivers"
        dism /online /export-driver /destination:$driversBackup
        
        # Lista de programas instalados
        Write-Log "Guardando lista de programas instalados..." "INFO"
        Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
        Export-Csv -Path (Join-Path $backupFolder "ProgramasInstalados.csv") -NoTypeInformation -Encoding UTF8
        
        # Configuración de red
        Write-Log "Guardando configuración de red..." "INFO"
        Get-NetIPConfiguration | ConvertTo-Json | Out-File (Join-Path $backupFolder "ConfiguracionRed.json") -Encoding UTF8
        
        Write-Log "Backup completado exitosamente en: $backupFolder" "SUCCESS"
    }
    catch {
        Write-Log "Error durante el backup: $_" "ERROR"
    }
}

function Verificar-Seguridad {
    Write-Host "`n=== VERIFICACIÓN DE SEGURIDAD ===" -ForegroundColor Cyan
    
    # Verificar Windows Defender
    Write-Log "Verificando estado de Windows Defender..." "INFO"
    try {
        $defenderStatus = Get-MpComputerStatus
        if ($defenderStatus.AntivirusEnabled) {
            Write-Log "Windows Defender está activo." "SUCCESS"
            Write-Host "Última actualización: $($defenderStatus.AntivirusSignatureLastUpdated)"
        }
        else {
            Write-Log "Windows Defender está desactivado." "WARNING"
        }
        
        # Ejecutar escaneo rápido si está habilitado
        $ejecutarEscaneo = Read-Host "¿Deseas ejecutar un escaneo rápido de Windows Defender? (s/n)"
        if ($ejecutarEscaneo.ToLower() -eq 's') {
            Write-Log "Iniciando escaneo rápido..." "INFO"
            Start-MpScan -ScanType QuickScan
            Write-Log "Escaneo iniciado. Revisa el centro de seguridad para ver los resultados." "SUCCESS"
        }
    }
    catch {
        Write-Log "Error al verificar Windows Defender: $_" "ERROR"
    }
    
    # Verificar firewall
    Write-Log "Verificando estado del firewall..." "INFO"
    try {
        $firewallProfiles = Get-NetFirewallProfile
        foreach ($profile in $firewallProfiles) {
            $estado = if ($profile.Enabled) { "Activo" } else { "Inactivo" }
            Write-Host "Firewall $($profile.Name): $estado"
        }
    }
    catch {
        Write-Log "Error al verificar firewall: $_" "ERROR"
    }
    
    # Verificar actualizaciones pendientes
    Write-Log "Verificando actualizaciones pendientes..." "INFO"
    try {
        if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
            Import-Module PSWindowsUpdate
            $updates = Get-WindowsUpdate
            if ($updates) {
                Write-Log "Se encontraron $($updates.Count) actualizaciones pendientes." "WARNING"
                foreach ($update in $updates | Select-Object -First 5) {
                    Write-Host "- $($update.Title)"
                }
            }
            else {
                Write-Log "No hay actualizaciones pendientes." "SUCCESS"
            }
        }
    }
    catch {
        Write-Log "Error al verificar actualizaciones: $_" "ERROR"
    }
}

function Ejecutar-Todo {
    Write-Host "`n=== EJECUTAR CONFIGURACIÓN COMPLETA ===" -ForegroundColor Cyan
    Write-Host "Esta opción ejecutará todas las configuraciones automáticamente." -ForegroundColor Yellow
    Write-Host "Esto incluye:" -ForegroundColor Yellow
    Write-Host "- Configuración de red (DHCP)" -ForegroundColor Yellow
    Write-Host "- Instalación de programas esenciales" -ForegroundColor Yellow
    Write-Host "- Personalización del escritorio" -ForegroundColor Yellow
    Write-Host "- Limpieza del sistema" -ForegroundColor Yellow
    Write-Host "- Optimización básica" -ForegroundColor Yellow
    
    $confirmar = Read-Host "`n¿Estás seguro de que deseas continuar? (s/n)"
    if ($confirmar.ToLower() -ne 's') {
        Write-Log "Configuración completa cancelada." "INFO"
        return
    }
    
    Write-Log "Iniciando configuración completa del sistema..." "INFO"
    
    # Crear punto de restauración
    Create-RestorePoint
    
    # Configurar red con DHCP
    Write-Log "Configurando red con DHCP..." "INFO"
    $adapterName = Get-ActiveNetworkAdapter
    if ($adapterName) {
        try {
            Remove-NetIPAddress -InterfaceAlias $adapterName -Confirm:$false -ErrorAction SilentlyContinue
            Remove-NetRoute -InterfaceAlias $adapterName -Confirm:$false -ErrorAction SilentlyContinue
            Set-NetIPInterface -InterfaceAlias $adapterName -Dhcp Enabled
            Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses "8.8.8.8", "8.8.4.4"
        }
        catch {
            Write-Log "Error en configuración automática de red: $_" "ERROR"
        }
    }
    
    # Instalar programas esenciales
    Write-Log "Instalando programas esenciales..." "INFO"
    $programasEsenciales = @("googlechrome", "7zip", "notepadplusplus.install", "vcredist-all", "adobereader")
    foreach ($programa in $programasEsenciales) {
        try {
            choco install $programa -y --limit-output 2>&1 | Out-Null
        }
        catch {
            Write-Log "Error al instalar $programa automáticamente." "ERROR"
        }
    }
    
    # Personalizar escritorio
    Personalizar-Escritorio
    
    # Limpiar sistema
    Limpiar-Sistema
    
    # Optimizar sistema
    Optimizar-Sistema
    
    Write-Log "Configuración completa finalizada." "SUCCESS"
    Write-Log "Se recomienda reiniciar el sistema para aplicar todos los cambios." "INFO"
}

# Función principal del menú
function Show-Menu {
    do {
        Show-Banner
        Write-Host "MENÚ PRINCIPAL DE AUTOMATIZACIÓN" -ForegroundColor Magenta
        Write-Host "=" * 50 -ForegroundColor Magenta
        Write-Host ""
        Write-Host " 1.  Configurar Red (IP y DNS)" -ForegroundColor White
        Write-Host " 2.  Instalar Programas" -ForegroundColor White
        Write-Host " 3.  Actualizar Sistema" -ForegroundColor White
        Write-Host " 4.  Personalizar Escritorio" -ForegroundColor White
        Write-Host " 5.  Configurar AnyDesk" -ForegroundColor White
        Write-Host " 6.  Activar Office y Windows" -ForegroundColor White
        Write-Host " 7.  Limpiar Sistema" -ForegroundColor White
        Write-Host " 8.  Optimizar Sistema" -ForegroundColor White
        Write-Host " 9.  Información del Sistema" -ForegroundColor White
        Write-Host "10.  Crear Backup" -ForegroundColor White
        Write-Host "11.  Verificar Seguridad" -ForegroundColor White
        Write-Host "12.  Ejecutar Todo Automáticamente" -ForegroundColor Cyan
        Write-Host " 0.  Salir" -ForegroundColor Red
        Write-Host ""
        Write-Host "=" * 50 -ForegroundColor Magenta
        
        do {
            $option = Read-Host "Selecciona una opción (0-12)"
        } while ($option -notin @('0','1','2','3','4','5','6','7','8','9','10','11','12'))
        
        switch ($option) {
            "1" { Configurar-IP }
            "2" { Instalar-Programas }
            "3" { Actualizar-Sistema }
            "4" { Personalizar-Escritorio }
            "5" { Configurar-AnyDesk }
            "6" { Activar-Office-Windows }
            "7" { Limpiar-Sistema }
            "8" { Optimizar-Sistema }
            "9" { Mostrar-InfoSistema }
            "10" { Crear-Backup }
            "11" { Verificar-Seguridad }
            "12" { Ejecutar-Todo }
            "0" { 
                Write-Log "Saliendo del programa..." "INFO"
                Write-Host "`n¡Gracias por usar el script de automatización!" -ForegroundColor Cyan
                break 
            }
        }
        
        if ($option -ne "0") {
            Write-Host "`nPresiona ENTER para continuar..." -ForegroundColor Gray
            Read-Host
        }
        
    } while ($option -ne "0")
}

# Inicio del script
try {
    # Mostrar información inicial
    Write-Log "Iniciando script de automatización para Windows..." "INFO"
    Write-Log "Verificando permisos y configuración inicial..." "INFO"
    
    # Preguntar si crear punto de restauración
    $crearRestorePoint = Read-Host "¿Deseas crear un punto de restauración antes de continuar? (s/n)"
    if ($crearRestorePoint.ToLower() -eq 's') {
        Create-RestorePoint
    }
    
    # Ejecutar menú principal
    Show-Menu
}
catch {
    Write-Log "Error crítico en el script: $_" "ERROR"
    Write-Host "Presiona ENTER para salir..." -ForegroundColor Red
    Read-Host
}
finally {
    Write-Log "Script finalizado." "INFO"
}