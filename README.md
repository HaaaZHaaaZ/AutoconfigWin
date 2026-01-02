# 🖥️ AutoconfigWin - Optimización y Configuración para Windows

> Script de PowerShell todo-en-uno para configurar, optimizar y limpiar Windows 10 y 11. Ahora con un diseño limpio y nuevas funciones de rendimiento.

![PowerShell](https://img.shields.io/badge/PowerShell-5.0+-blue?style=flat-square&logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## 🚀 Instalación Rápida (Recomendado)

La forma más rápida de usar este script es ejecutarlo directamente desde PowerShell (como Administrador) sin descargar nada:

```powershell
# Descarga y ejecuta el script desde GitHub directamente:
iex (irm 'https://raw.githubusercontent.com/HaaaZHaaaZ/AutoconfigWin/refs/heads/master/ConfigurarEquipo.ps1')
```

---

## ¿Qué hace este script?

`ConfigurarEquipo.ps1` es una "navaja suiza" para tu sistema. Permite realizar tareas complejas en segundos a través de un menú interactivo.

### ✨ Nuevas Funciones (v3.0)
*   **Interfaz Limpia**: Nuevo diseño profesional con banner ASCII "HaZ" y carga rápida.
*   **Optimización Windows 11**: Opción dedicada para mejorar FPS y reducir latencia.
*   **Modo Rollback**: ¿Te arrepentiste? Deshaz los cambios con un solo clic.

### 📋 Características Principales
1.  **Configurar Red**: Establece IP estática/DHCP y DNS rápidos (AdGuard/Google).
2.  **Software Esencial**: Instala Chrome, WinRAR, AnyDesk, Office 365 y más con un clic.
3.  **Drivers**: Descarga y actualiza todos tus drivers automáticamente.
4.  **Personalización**: Limpia tu barra de tareas y elimina bloatware visual.
5.  **Optimización (NUEVO)**: 
    *   Activa plan "Máximo Rendimiento".
    *   Elimina Telemetría y rastreadores.
    *   Desactiva GameDVR para más FPS.
6.  **Limpieza**: Elimina basura del sistema y libera espacio.

---

## �️ Cómo Usar (Otras opciones)

### Opción 1: Launcher Fácil
Si descargaste el proyecto, simplemente haz doble clic en:
`Ejecutar_Script.bat`

### Opción 2: PowerShell Local
```powershell
powershell -ExecutionPolicy Bypass -File "ConfigurarEquipo.ps1"
```

### Opción 3: Ver Demo Visual
¿Quieres ver cómo luce sin cambiar nada en tu PC?
```powershell
.\Demo_Visual.ps1
```

---

## 🎮 Menú de Opciones

| Opción | Descripción |
| :--- | :--- |
| **1** | **Red y DNS**: Cambiar IP y configurar DNS seguros. |
| **2** | **Instalar Programas**: Pack básico (Navegadores, Utilidades, Office). |
| **3** | **Drivers**: Actualización automática via Driver Booster. |
| **4** | **Personalizar**: Escritorio limpio y minimalista. |
| **5** | **AnyDesk**: Configurar acceso remoto con contraseña. |
| **6** | **Activar**: Herramientas para Windows y Office. |
| **7** | **Limpieza**: Borrar temporales y vaciar papelera. |
| **8** | **CALIDAD/RENDIMIENTO**: Optimizar Windows para Gaming/Privacidad. |
| **9** | **ROLLBACK**: Deshacer optimizaciones y restaurar valores. |
| **0** | **Salir** |

---

## ⚙️ Requisitos

*   **Windows 10 o 11** (Totalmente compatible con 24H2/25H2).
*   **PowerShell 5.0+** (Viene por defecto).
*   **Permisos de Administrador**.
*   **Internet** (Para descargar programas).

---

## 🐛 Solución de Problemas

### 1. Error: "La ejecución de scripts está deshabilitada..."
Si al ejecutar `.\Demo_Visual.ps1` o el script principal recibes este error en rojo:
> *...porque la ejecución de scripts está deshabilitada en este sistema...*

**Solución:**
Tienes que permitir la ejecución de scripts en PowerShell. Copia y pega este comando y presiona Enter:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
(Presiona 'S' o 'Y' para confirmar si te pregunta).

Alternativamente, ejecuta el script con este comando que salta la restricción temporalmente:
```powershell
powershell -ExecutionPolicy Bypass -File ".\Demo_Visual.ps1"
```

### 2. Error: "Acceso Denegado"
Si ves mensajes de error escribiendo archivos o cambiando configuraciones:
**Solución:** Debes ejecutar PowerShell o la Terminal como **Administrador** (Clic derecho > Ejecutar como administrador).

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Eres libre de usarlo, modificarlo y compartirlo.

**Autor**: HaaaZHaaaZ
**Versión**: 3.0 (Update Visual & Performance)
