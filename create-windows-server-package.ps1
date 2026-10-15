# Script dong goi ban chay doc lap 1-Click cho Windows & Windows Server 2012 R2+
$zipName = "LaptopWeb-Windows-Deploy.zip"
$tempDir = "$PSScriptRoot\temp_deploy"

Write-Host ">>> Dang dong goi ban cai dat 1-Click cho Windows Server..." -ForegroundColor Cyan

if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
if (Test-Path "$PSScriptRoot\$zipName") { Remove-Item -Force "$PSScriptRoot\$zipName" }

New-Item -ItemType Directory -Path $tempDir | Out-Null
New-Item -ItemType Directory -Path "$tempDir\dist" | Out-Null
New-Item -ItemType Directory -Path "$tempDir\uploads" | Out-Null

Write-Host ">>> Sao chep 1-CLICK-RUN.bat va start.ps1..." -ForegroundColor Yellow
Copy-Item -Path "$PSScriptRoot\1-CLICK-RUN.bat" -Destination "$tempDir\1-CLICK-RUN.bat"
Copy-Item -Path "$PSScriptRoot\start.ps1" -Destination "$tempDir\start.ps1"

Write-Host ">>> Sao chep file app.jar..." -ForegroundColor Yellow
Copy-Item -Path "$PSScriptRoot\backend\target\laptopweb-backend-0.0.1-SNAPSHOT.jar" -Destination "$tempDir\app.jar"

Write-Host ">>> Sao chep frontend dist..." -ForegroundColor Yellow
Copy-Item -Path "$PSScriptRoot\frontend\dist\*" -Destination "$tempDir\dist" -Recurse

Write-Host ">>> Sao chep uploads..." -ForegroundColor Yellow
if (Test-Path "$PSScriptRoot\backend\uploads") {
    Copy-Item -Path "$PSScriptRoot\backend\uploads\*" -Destination "$tempDir\uploads" -Recurse -ErrorAction SilentlyContinue
}

$readmeContent = @"
================================================================
   HUONG DAN CHAY WEBSITE HIEU TRAN LAPTOP US TREN VPS WINDOWS
================================================================

1. CACH CHAY:
   - Chi can NHAP DUP vao file: [ 1-CLICK-RUN.bat ]
   - File se tu dong:
     + Kiem tra Java (neu chua co se tu dong tai ban Portable JRE 21 ve chay).
     + Kiem tra MySQL/MariaDB tai cong 3306 (neu chua co se tu dong tai MariaDB Portable ve chay).
     + Tu dong khoi chay website va mo trinh duyet http://localhost:8080!

2. TAI KHOAN QUAN TRI (ADMIN):
   - Link: http://localhost:8080/admin
   - Email: admin@laptopweb.com
   - Mat khau: admin123

3. TAI KHOAN KHACH HANG:
   - Email: customer@laptopweb.com
   - Mat khau: 123456

4. ZALO SHOP:
   - Hotline & Zalo: 0778.3333.62
================================================================
"@

$readmeContent | Out-File -FilePath "$tempDir\HUONG_DAN.txt" -Encoding utf8

Write-Host ">>> Dang nen thanh $zipName..." -ForegroundColor Green
Compress-Archive -Path "$tempDir\*" -DestinationPath "$PSScriptRoot\$zipName" -Force

Remove-Item -Recurse -Force $tempDir

$fileSizeMB = [math]::Round(((Get-Item "$PSScriptRoot\$zipName").Length / 1MB), 2)
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " TAO GOI THANH CONG: $zipName ($fileSizeMB MB)" -ForegroundColor Green
Write-Host " Chi can copy file $zipName len VPS, giai nen va nhap dup 1-CLICK-RUN.bat!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
