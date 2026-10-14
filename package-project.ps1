# Script dong goi du an LaptopWeb de chuyen qua may khac
$zipName = "LaptopWeb-Package.zip"
$tempDir = "$PSScriptRoot\temp_package"

Write-Host ">>> Preparing LaptopWeb package..." -ForegroundColor Cyan

if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
if (Test-Path "$PSScriptRoot\$zipName") {
    Remove-Item -Force "$PSScriptRoot\$zipName"
}

New-Item -ItemType Directory -Path $tempDir | Out-Null
New-Item -ItemType Directory -Path "$tempDir\backend" | Out-Null
New-Item -ItemType Directory -Path "$tempDir\frontend" | Out-Null

Write-Host ">>> Copying backend files (excluding target, .mvn)..." -ForegroundColor Yellow
Copy-Item -Path "$PSScriptRoot\backend\src" -Destination "$tempDir\backend\src" -Recurse
Copy-Item -Path "$PSScriptRoot\backend\pom.xml" -Destination "$tempDir\backend\pom.xml"
Copy-Item -Path "$PSScriptRoot\backend\Dockerfile" -Destination "$tempDir\backend\Dockerfile"
Copy-Item -Path "$PSScriptRoot\backend\.dockerignore" -Destination "$tempDir\backend\.dockerignore"

Write-Host ">>> Copying frontend files (excluding node_modules, dist)..." -ForegroundColor Yellow
Copy-Item -Path "$PSScriptRoot\frontend\src" -Destination "$tempDir\frontend\src" -Recurse
Copy-Item -Path "$PSScriptRoot\frontend\public" -Destination "$tempDir\frontend\public" -Recurse
Copy-Item -Path "$PSScriptRoot\frontend\index.html" -Destination "$tempDir\frontend\index.html"
Copy-Item -Path "$PSScriptRoot\frontend\package.json" -Destination "$tempDir\frontend\package.json"
Copy-Item -Path "$PSScriptRoot\frontend\package-lock.json" -Destination "$tempDir\frontend\package-lock.json" -ErrorAction SilentlyContinue
Copy-Item -Path "$PSScriptRoot\frontend\vite.config.js" -Destination "$tempDir\frontend\vite.config.js"
Copy-Item -Path "$PSScriptRoot\frontend\tailwind.config.js" -Destination "$tempDir\frontend\tailwind.config.js"
Copy-Item -Path "$PSScriptRoot\frontend\postcss.config.js" -Destination "$tempDir\frontend\postcss.config.js"
Copy-Item -Path "$PSScriptRoot\frontend\nginx.conf" -Destination "$tempDir\frontend\nginx.conf"
Copy-Item -Path "$PSScriptRoot\frontend\Dockerfile" -Destination "$tempDir\frontend\Dockerfile"
Copy-Item -Path "$PSScriptRoot\frontend\.dockerignore" -Destination "$tempDir\frontend\.dockerignore"

Write-Host ">>> Copying docker-compose and docs..." -ForegroundColor Yellow
Copy-Item -Path "$PSScriptRoot\docker-compose.yml" -Destination "$tempDir\docker-compose.yml"
Copy-Item -Path "$PSScriptRoot\README.md" -Destination "$tempDir\README.md"
Copy-Item -Path "$PSScriptRoot\plan.txt" -Destination "$tempDir\plan.txt"

Write-Host ">>> Compressing into $zipName..." -ForegroundColor Green
Compress-Archive -Path "$tempDir\*" -DestinationPath "$PSScriptRoot\$zipName" -Force

Remove-Item -Recurse -Force $tempDir

$fileSizeMB = [math]::Round(((Get-Item "$PSScriptRoot\$zipName").Length / 1MB), 2)
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " SUCCESS: $zipName ($fileSizeMB MB)" -ForegroundColor Green
Write-Host " You can now transfer $zipName to another machine!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
