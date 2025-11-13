@echo off
REM Script para ejecutar ConfigurarEquipo.ps1 con permisos de administrador
REM Este archivo abre PowerShell como administrador y ejecuta el script

cls
echo.
echo ==========================================
echo SCRIPT DE AUTOMATIZACION PARA WINDOWS
echo ==========================================
echo.
echo Este script se ejecutara con permisos de administrador.
echo.
pause

powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoExit -ExecutionPolicy Bypass -File \"%~dp0ConfigurarEquipo.ps1\"'"
