@echo off
title Hieu Tran Laptop US - Auto Setup and Run
chcp 65001 >nul
cls

echo ================================================================
echo    HIEU TRAN LAPTOP US - AUTO SETUP AND RUN (1-CLICK)
echo ================================================================
echo Dang kiem tra moi truong va khoi dong he thong...
echo Vui long giu nguyen cua so nay!
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [LOI] Co van de xay ra trong qua trinh khoi chay.
    pause
)
