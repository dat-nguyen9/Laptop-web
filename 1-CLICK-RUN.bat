@echo off
title Hieu Tran Laptop US - Auto Setup and Run
chcp 65001 >nul 2>&1
cls

echo ================================================================
echo    HIEU TRAN LAPTOP US - AUTO SETUP AND RUN (1-CLICK)
echo ================================================================
echo Dang kiem tra moi truong va khoi dong he thong...
echo Vui long giu nguyen cua so nay!
echo.
echo Log duoc ghi vao file: startup.log (cung thu muc)
echo.

:: Kiem tra PowerShell co ton tai khong
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [LOI] Khong tim thay PowerShell tren he thong nay!
    echo Vui long cai PowerShell (co san tu Windows Management Framework).
    echo.
    pause
    exit /b 1
)

:: Hien thi phien ban PowerShell de debug
echo Phien ban PowerShell dang su dung:
powershell -NoProfile -Command "Write-Host $PSVersionTable.PSVersion"
echo.

:: Chay script chinh - thu ExecutionPolicy Bypass truoc
echo [1/2] Thu chay voi ExecutionPolicy Bypass...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start.ps1"
set RESULT=%ERRORLEVEL%

:: Neu that bai, thu cach khac: Set-ExecutionPolicy trong process
if %RESULT% NEQ 0 (
    echo.
    echo [2/2] Thu cach khac (Set-ExecutionPolicy trong session)...
    powershell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; & '%~dp0start.ps1'"
    set RESULT=%ERRORLEVEL%
)

echo.
echo ================================================================
if %RESULT% EQU 0 (
    echo [THANH CONG] He thong da chay (ma: %RESULT%)
) else (
    echo [THAT BAI] Co loi xay ra (ma loi: %RESULT%)
    echo Xem file startup.log trong cung thu muc de biet them chi tiet!
)
echo ================================================================
echo.
pause
