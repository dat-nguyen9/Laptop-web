@echo off
chcp 65001 >nul
title LaptopWeb Backend (Spring Boot 3)
echo ========================================================
echo   KHOI DONG BACKEND SPRING BOOT (CONG 8080)
echo ========================================================
cd /d "%~dp0backend"
"%~dp0apache-maven-3.9.6\bin\mvn.cmd" spring-boot:run
pause
