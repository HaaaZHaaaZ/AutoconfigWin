# Autoconfig Script

Este script de PowerShell automatiza varias tareas de configuración y mantenimiento en un equipo con Windows. Incluye opciones para configurar la red, instalar programas predeterminados y actualizar drivers.

## Funcionalidades

1. **Cambiar configuración de red (IP y DNS)**
2. **Instalar programas predeterminados**
3. **Actualizar drivers con Driver Booster**

## Uso

Para ejecutar el script, tienes dos opciones:

### Opción 1: Ejecutar desde PowerShell

1. Abre PowerShell con permisos de administrador.
2. Navega al directorio donde se encuentra el script.
3. Ejecuta el script con el siguiente comando:

    ```powershell
    .\ConfigurarEquipo.ps1
    ```

### Opción 2: Ejecutar usando el archivo [ejecutador.bat](http://_vscodecontentref_/1)

1. Abre el archivo [ejecutador.bat](http://_vscodecontentref_/2) con permisos de administrador.
2. El archivo `.bat` ejecutará automáticamente el script de PowerShell.

## Menú Principal

El script presenta un menú con las siguientes opciones:

1. **Cambiar configuración de red (IP y DNS)**: Permite configurar la dirección IP y los servidores DNS, ya sea de forma automática (DHCP) o manual.
2. **Instalar programas predeterminados**: Instala una lista de programas predeterminados utilizando Chocolatey.
3. **Actualizar drivers con Driver Booster**: Verifica si Driver Booster está instalado, lo descarga e instala si es necesario, y luego actualiza los drivers del sistema.
4. **Salir**: Cierra el menú y termina la ejecución del script.

## Requisitos

- PowerShell 5.1 o superior
- Conexión a Internet para descargar programas y actualizaciones

## Detalles de las Funciones

### Configurar-IP

Configura la dirección IP y los servidores DNS de la interfaz de red `Ethernet`.

### Instalar-Programas

Instala los siguientes programas utilizando Chocolatey:

- Visual C++ Redistributable
- Google Chrome
- Opera
- WinRAR
- AnyDesk
- Notepad++
- Office 365 Business
- Adobe Reader

### Actualizar-Drivers

Utiliza Driver Booster para actualizar los drivers del sistema. Si Driver Booster no está instalado, el script lo descarga e instala automáticamente.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este script, por favor, haz un fork del repositorio y envía un pull request con tus cambios.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo `LICENSE` para obtener más detalles.