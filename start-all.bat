@echo off
chcp 65001 >nul
echo ========================================================
echo   KHOI DONG DONG THOI BACKEND VA FRONTEND LAPTOPWEB
echo ========================================================
start "LaptopWeb Backend" cmd /c "%~dp0start-backend.bat"
timeout /t 3 /nobreak >nul
start "LaptopWeb Frontend" cmd /c "%~dp0start-frontend.bat"
echo Da khoi chay ca 2 dich vu!
echo - Backend:  http://localhost:8080
echo - Frontend: http://localhost:5173
pause
