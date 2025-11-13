# 🖥️ AutoconfigWin - Script de Automatización para Windows

> Script PowerShell que automatiza configuración de Windows con efectos visuales tipo "hacker"

![PowerShell](https://img.shields.io/badge/PowerShell-5.0+-blue?style=flat-square&logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## ¿Qué hace este script?

`ConfigurarEquipo.ps1` es una herramienta de automatización que permite configurar una PC con Windows de forma rápida y visual. Incluye las siguientes funcionalidades:

1. **Configurar Red (IP y DNS)** - Establece dirección IP y servidores DNS
2. **Instalar Programas** - Instala automáticamente una lista de programas via Chocolatey
3. **Actualizar Drivers** - Descarga e instala Driver Booster para actualizar drivers
4. **Personalizar Escritorio** - Oculta elementos innecesarios de Windows
5. **Configurar AnyDesk** - Configura acceso remoto
6. **Activar Office/Windows** - Herramientas de activación
7. **Limpiar Sistema** - Elimina archivos temporales y libera espacio

---

## ✨ Características Visuales

El script incluye **efectos visuales tipo "hacker"**:
- 🖥️ Pantalla maximizada automáticamente
- 🎬 Animación de inicio con efecto máquina de escribir (verde)
- 📊 Barra de estado persistente en tiempo real
- 🎨 Logs codificados por color (INFO, SUCCESS, WARNING, ERROR)

---

## 🚀 Cómo Usar

### Opción 1: Launcher Fácil (Recomendado)
```bash
# Haz doble clic en:
Ejecutar_Script.bat
```

### Opción 2: PowerShell como Administrador
```powershell
powershell -ExecutionPolicy Bypass -File "ConfigurarEquipo.ps1"
```

### Opción 3: Ver Demo (Sin modificar sistema)
```powershell
# Para ver los efectos visuales sin hacer cambios:
powershell -ExecutionPolicy Bypass -File "Demo_Visual.ps1"
```

### Opción 4: Ejecutar Directamente desde GitHub
```powershell
# Descarga y ejecuta el script desde GitHub directamente:
iex (irm 'https://raw.githubusercontent.com/HaaaZHaaaZ/AutoconfigWin/refs/heads/master/ConfigurarEquipo.ps1')
```

---

## ⚙️ Requisitos

- **Windows 10 o 11**
- **PowerShell 5.0+** (incluido en Windows)
- **Permisos de Administrador**
- **Conexión a Internet** (para instalar programas)

---

## � Menú Principal

Al ejecutar el script, aparecerá un menú interactivo:

```
========== MENU DE AUTOMATIZACION ==========

1. Cambiar configuracion de red (IP y DNS)
2. Instalar programas predeterminados
3. Actualizacion de Drivers
4. Personalizar Escritorio y Barra de Tareas
5. Configurar AnyDesk
6. Activar Office y Windows
7. Limpiar Sistema
0. Salir

Selecciona una opcion: █
```

---

## 🎨 Opciones Disponibles

### 1️⃣ Configurar Red (IP y DNS)
- **DHCP automático** - Obtiene IP automáticamente
- **IP estática** - Configura IP manual
- **DNS personalizados** - AdGuard, Google o personalizados

### 2️⃣ Instalar Programas
Instala automáticamente:
- Google Chrome
- Opera
- WinRAR
- AnyDesk
- Notepad++
- Visual C++ Redistributable
- Office 365
- Adobe Reader

### 3️⃣ Actualizar Drivers
- Descarga e instala Driver Booster
- Actualiza automáticamente todos los drivers

### 4️⃣ Personalizar Escritorio
- Oculta botón de Vistas de Tareas
- Oculta cuadro de búsqueda
- Desactiva noticias e intereses

### 5️⃣ Configurar AnyDesk
- Configura contraseña de acceso remoto

### 6️⃣ Activar Office/Windows
- Herramientas para activación

### 7️⃣ Limpiar Sistema
- Elimina archivos temporales
- Vacía papelera de reciclaje
- Libera espacio en disco

---

## 📊 Colores en la Consola

| Color | Significa |
|-------|-----------|
| 🟢 Verde | ✅ Éxito / Completado |
| ⚪ Blanco | ℹ️ Información |
| 🟡 Amarillo | ⚠️ Advertencia |
| 🔴 Rojo | ❌ Error |

---

## 🐛 Solución de Problemas

### "Acceso denegado"
```
→ Ejecuta PowerShell como Administrador
```

### "El script no se ejecuta"
```
→ Ejecuta en PowerShell:
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### "Los visuales no aparecen"
```
→ Normal en algunos terminales. El script funciona igual.
```

### "Error de Chocolatey"
```
→ Instala Chocolatey manualmente:
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

---

## 📄 Licencia

Este proyecto está licenciado bajo la **Licencia MIT** - ver el archivo [LICENSE](LICENSE) para más detalles.

```
MIT License

Copyright (c) 2025 HaaaZHaaaZ

Permiso para usar, copiar, modificar, fusionar, publicar, distribuir, 
sublicenciar, y/o vender copias del Software.
```

---

## 🙏 Créditos

- **Autor**: HaaaZHaaaZ
- **Año**: 2025
- **Versión**: 2.1
- **Estado**: ✅ Listo para Producción

---

## 🎯 Roadmap Futuro

- [ ] Interfaz gráfica (GUI)
- [ ] Actualización automática
- [ ] Soporte para Linux/Mac
- [ ] Configuración por archivo JSON
- [ ] Logs persistentes
- [ ] Sistema de plugins

---

## 📁 Archivos Incluidos

```
AutoconfigWin/
├── ConfigurarEquipo.ps1      ← Script principal
├── Demo_Visual.ps1           ← Demo sin admin
├── Ejecutar_Script.bat       ← Launcher
├── README.md                 ← Este archivo
├── GUIA_RAPIDA.txt          ← Referencia rápida
└── LICENSE                   ← MIT License
```

---

**¿Listo para automatizar tu Windows? Ejecuta `Ejecutar_Script.bat` 🚀**
