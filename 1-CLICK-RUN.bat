@echo off
setlocal
title Hieu Tran Laptop US - Auto Setup and Run
chcp 65001 >nul 2>&1
cls

echo ================================================================
echo    HIEU TRAN LAPTOP US - AUTO SETUP AND RUN (1-CLICK)
echo ================================================================
echo Dang kiem tra moi truong va khoi dong he thong...
echo Vui long giu nguyen cua so nay!
echo/
echo Nhat ky hoat dong: startup.log (trong thu muc hien tai)
echo/

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%start.ps1"

echo [*] Dang khoi chay qua PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
set "EXIT_CODE=%ERRORLEVEL%"

if %EXIT_CODE% NEQ 0 goto RETRY_COMMAND
goto DONE

:RETRY_COMMAND
echo/
echo [!] Thu khoi chay lai voi quyen thuc thi Process...
powershell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; & '%PS_SCRIPT%'"
set "EXIT_CODE=%ERRORLEVEL%"

:DONE
echo/
echo ================================================================
if %EXIT_CODE% EQU 0 (
    echo [THANH CONG] Qua trinh khoi chay da hoan tat.
) else (
    echo [THONG BAO] Tien trinh da dung lai (Ma ket thuc: %EXIT_CODE%).
    echo Kiem tra them trong file startup.log neu gap loi.
)
echo ================================================================
echo/
echo Nhan phim bat ky de thoat...
pause >nul
