@echo off
chcp 65001 >nul
title LaptopWeb Frontend (Vue.js 3 + Vite)
echo ========================================================
echo   KHOI DONG FRONTEND VUE 3 (CONG 5173)
echo ========================================================
cd /d "%~dp0frontend"
set "PATH=C:\Program Files\nodejs;%PATH%"
npm run dev
pause
