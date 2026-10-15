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
echo.
echo Nhat ky hoat dong: startup.log (trong thu muc hien tai)
echo.

cd /d "%~dp0"

echo [*] Dang khoi chay qua PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start.ps1"
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" goto RETRY_COMMAND
goto SHOW_SUCCESS

:RETRY_COMMAND
echo.
echo [!] Thu khoi chay lai voi quyen thuc thi Process...
powershell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; & '%~dp0start.ps1'"
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" goto SHOW_FAILED
goto SHOW_SUCCESS

:SHOW_SUCCESS
echo.
echo ================================================================
echo [THANH CONG] Qua trinh khoi chay da hoan tat.
echo ================================================================
goto FINISH

:SHOW_FAILED
echo.
echo ================================================================
echo [THONG BAO] Tien trinh da dung lai voi ma thoat: %EXIT_CODE%
echo Xem file startup.log trong thu muc de biet them chi tiet neu gap loi.
echo ================================================================
goto FINISH

:FINISH
echo.
echo ================================================================
echo Cua so nay se khong tu tat de ban co the doc duoc thong bao tren.
echo Nhan phim bat ky tren ban phim de dong cua so...
pause
