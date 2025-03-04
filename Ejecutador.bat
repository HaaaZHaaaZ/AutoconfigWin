@echo off
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0ConfigurarEquipo.ps1\"' -Verb RunAs"
