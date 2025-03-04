# Autoconfig Script

Este script de PowerShell automatiza varias tareas de configuración y mantenimiento en un equipo con Windows. Incluye opciones para configurar la red, instalar programas predeterminados, actualizar drivers, limpiar el sistema y personalizar el escritorio.

## Funcionalidades

1. **Cambiar configuración de red (IP y DNS)**
2. **Instalar programas predeterminados**
3. **Actualizar drivers con Driver Booster**
4. **Personalizar Escritorio y Barra de Tareas**
5. **Configurar AnyDesk**
6. **Limpiar el Sistema**

## Uso

Para ejecutar el script, tienes tres opciones:

### Opción 1: Ejecutar desde PowerShell

1. Abre PowerShell con permisos de administrador.
2. Navega al directorio donde se encuentra el script.
3. Ejecuta el script con el siguiente comando:

    ```powershell
    .\ConfigurarEquipo.ps1
    ```

### Opción 2: Ejecutar usando el archivo `.bat`

1. Abre el archivo `.bat` con permisos de administrador.
2. El archivo `.bat` ejecutará automáticamente el script de PowerShell.

### Opción 3: Ejecutar directamente desde GitHub

1. Abre PowerShell con permisos de administrador.
2. Ejecuta el siguiente comando:

    ```powershell
    iex (irm 'https://raw.githubusercontent.com/HaaaZHaaaZ/AutoconfigWin/refs/heads/master/ConfigurarEquipo.ps1')
    ```

## Menú Principal

El script presenta un menú con las siguientes opciones:

1. **Cambiar configuración de red (IP y DNS)**: Permite configurar la dirección IP y los servidores DNS, ya sea de forma automática (DHCP) o manual.
2. **Instalar programas predeterminados**: Instala una lista de programas predeterminados utilizando Chocolatey.
3. **Actualizar drivers con Driver Booster**: Verifica si Driver Booster está instalado, lo descarga e instala si es necesario, y luego actualiza los drivers del sistema.
4. **Personalizar Escritorio y Barra de Tareas**: Personaliza el escritorio y la barra de tareas ocultando el botón de vistas de tareas, el cuadro de búsqueda y desactivando noticias e intereses.
5. **Configurar AnyDesk**: Configura la contraseña de AnyDesk.
6. **Limpiar el Sistema**: Limpia archivos temporales y la papelera de reciclaje.
0. **Salir**: Cierra el menú y termina la ejecución del script.

## Requisitos

- PowerShell 5.1 o superior
- Conexión a Internet para descargar programas y actualizaciones

## Detalles de las Funciones

### Configurar-IP

Esta función permite configurar la dirección IP y los servidores DNS de la interfaz de red `Ethernet`. Puedes elegir entre configurar la IP y DNS de forma automática (DHCP) o manual. En el caso de configuración manual, se te pedirá que ingreses la dirección IP, la máscara de subred, la puerta de enlace predeterminada y los servidores DNS.

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

### Personalizar-Escritorio

Esta función personaliza el escritorio y la barra de tareas realizando las siguientes acciones:

- **Ocultar el botón de vistas de tareas**: Oculta el botón de vistas de tareas de la barra de tareas.
- **Ocultar el cuadro de búsqueda**: Oculta el cuadro de búsqueda de la barra de tareas.
- **Desactivar noticias e intereses**: Desactiva la función de noticias e intereses en la barra de tareas.

### Configurar-AnyDesk

Configura la contraseña de AnyDesk para el acceso remoto.

### Limpiar-Sistema

Esta función realiza la limpieza del sistema eliminando archivos temporales y vaciando la papelera de reciclaje:

- **Limpiar archivos temporales**: Elimina los archivos temporales ubicados en `C:\Windows\Temp` y en la carpeta temporal del usuario.
- **Limpiar la papelera de reciclaje**: Vacía la papelera de reciclaje.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este script, por favor, haz un fork del repositorio y envía un pull request con tus cambios.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo `LICENSE` para obtener más detalles.