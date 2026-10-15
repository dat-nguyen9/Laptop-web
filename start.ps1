# ================================================================
#  HIEU TRAN LAPTOP US - 1-CLICK AUTO RUN SCRIPT
#  Tu dong kiem tra va tai Java, MariaDB/MySQL neu may chua co
#  Ho tro Windows 10, 11, Windows Server 2012 R2, 2016, 2019, 2022
# ================================================================

$ErrorActionPreference = "Stop"

# Kich hoat TLS 1.2 de tai file tren Windows Server 2012 R2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls

Add-Type -AssemblyName System.IO.Compression.FileSystem

$baseDir = $PSScriptRoot
$toolsDir = Join-Path $baseDir "tools"
if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir | Out-Null
}

function Write-Step($msg) {
    Write-Host "`n[+] $msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "    -> $msg" -ForegroundColor Green
}

function Write-WarnMsg($msg) {
    Write-Host "    [!] $msg" -ForegroundColor Yellow
}

function Extract-Zip($zipPath, $destDir) {
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $destDir)
}

function Test-Port($port) {
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $connect = $tcp.BeginConnect("127.0.0.1", $port, $null, $null)
        $success = $connect.AsyncWaitHandle.WaitOne(1500, $false)
        if ($success) {
            $tcp.EndConnect($connect)
            $tcp.Close()
            return $true
        }
        $tcp.Close()
        return $false
    } catch {
        return $false
    }
}

# ----------------------------------------------------------------
# BƯỚC 1: KIỂM TRA & TẢI JAVA (JRE 21)
# ----------------------------------------------------------------
Write-Step "Kiem tra Java Runtime tren he thong..."
$javaExe = $null

$portableJava = Join-Path $toolsDir "jre\bin\java.exe"
if (Test-Path $portableJava) {
    $javaExe = $portableJava
    Write-Ok "Su dung Portable Java JRE tai tools\jre"
} else {
    try {
        $ver = & java -version 2>&1
        if ($LASTEXITCODE -eq 0 -or $ver) {
            $javaExe = "java"
            Write-Ok "Da tim thay Java he thong co san."
        }
    } catch {
        $javaExe = $null
    }
}

if (-not $javaExe) {
    Write-WarnMsg "He thong chua co Java. Dang tu dong tai Portable OpenJDK 21 (khoang 49MB)..."
    $jreZip = Join-Path $toolsDir "jre21.zip"
    $jreUrl = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jre_x64_windows_hotspot_21.0.3_9.zip"
    
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($jreUrl, $jreZip)
    Write-Ok "Tai xong Java. Dang giai nen..."
    
    $extractDir = Join-Path $toolsDir "jre_temp"
    if (Test-Path $extractDir) { Remove-Item -Recurse -Force $extractDir }
    Extract-Zip $jreZip $extractDir
    
    $subFolder = Get-ChildItem -Directory -Path $extractDir | Select-Object -First 1
    $targetJre = Join-Path $toolsDir "jre"
    if (Test-Path $targetJre) { Remove-Item -Recurse -Force $targetJre }
    Move-Item $subFolder.FullName $targetJre
    Remove-Item -Recurse -Force $extractDir
    Remove-Item -Force $jreZip
    
    $javaExe = $portableJava
    Write-Ok "Cai dat Portable Java 21 thanh cong!"
}

# ----------------------------------------------------------------
# BƯỚC 2: KIỂM TRA & KHỞI CHẠY DATABASE (MySQL / MariaDB)
# ----------------------------------------------------------------
Write-Step "Kiem tra Database (MySQL / MariaDB tai cong 3306)..."
$isDbOpen = Test-Port 3306

if ($isDbOpen) {
    Write-Ok "Cong 3306 da san sang (MySQL/MariaDB dang hoat dong)."
} else {
    $mariadbDir = Join-Path $toolsDir "mariadb"
    $mysqldExe = Join-Path $mariadbDir "bin\mysqld.exe"
    
    if (-not (Test-Path $mysqldExe)) {
        Write-WarnMsg "Cong 3306 chua co database. Dang tu dong tai Portable MariaDB 10.11 (khoang 85MB)..."
        $mariaZip = Join-Path $toolsDir "mariadb.zip"
        $mariaUrl = "https://archive.mariadb.org/mariadb-10.11.8/winx64-packages/mariadb-10.11.8-winx64.zip"
        
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($mariaUrl, $mariaZip)
        Write-Ok "Tai xong MariaDB. Dang giai nen..."
        
        $extractDir = Join-Path $toolsDir "maria_temp"
        if (Test-Path $extractDir) { Remove-Item -Recurse -Force $extractDir }
        Extract-Zip $mariaZip $extractDir
        
        $subFolder = Get-ChildItem -Directory -Path $extractDir | Select-Object -First 1
        Move-Item $subFolder.FullName $mariadbDir
        Remove-Item -Recurse -Force $extractDir
        Remove-Item -Force $mariaZip
        
        Write-Ok "Khoi tao thu muc du lieu data cho MariaDB..."
        $installDbExe = Join-Path $mariadbDir "bin\mariadb-install-db.exe"
        & $installDbExe --datadir="$mariadbDir\data" | Out-Null
    }
    
    Write-Step "Dang khoi dong Portable MariaDB ngam..."
    Start-Process -FilePath $mysqldExe -ArgumentList "--datadir=`"$mariadbDir\data`" --port=3306 --console" -WindowStyle Hidden
    
    # Cho cong 3306 khoi dong
    $retries = 20
    while (-not (Test-Port 3306) -and $retries -gt 0) {
        Start-Sleep -Seconds 1
        $retries--
    }
    
    if (Test-Port 3306) {
        Write-Ok "Portable MariaDB da khoi dong thanh cong tai cong 3306!"
        
        # Tao database laptopweb neu chua co
        $mariaClient = Join-Path $mariadbDir "bin\mariadb.exe"
        if (Test-Path $mariaClient) {
            & $mariaClient -u root -e "CREATE DATABASE IF NOT EXISTS laptopweb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>$null
        }
    } else {
        Write-WarnMsg "Khong the tu dong bat MariaDB. Neu ban co MySQL san, hay dam bao MySQL dang chay!"
    }
}

# ----------------------------------------------------------------
# BƯỚC 3: XÁC ĐỊNH FILE CHẠY BACKEND JAR
# ----------------------------------------------------------------
Write-Step "Kiem tra file chuong trinh..."
$jarFile = Join-Path $baseDir "app.jar"
if (-not (Test-Path $jarFile)) {
    $jarFile = Join-Path $baseDir "backend\target\laptopweb-backend-0.0.1-SNAPSHOT.jar"
}
if (-not (Test-Path $jarFile)) {
    Write-Host "[LOI] Khong tim thay file app.jar de chay!" -ForegroundColor Red
    exit 1
}

Write-Ok "Tim thay file chay: $jarFile"

# ----------------------------------------------------------------
# BƯỚC 4: KIỂM TRA CỔNG 8080 VÀ KHỞI CHẠY HỆ THỐNG
# ----------------------------------------------------------------
if (Test-Port 8080) {
    Write-Ok "Ung dung da dang chay tren cong 8080!"
    Write-Host "`n>>> DANG MO TRINH DUYET: http://localhost:8080 ..." -ForegroundColor Green
    Start-Process "http://localhost:8080"
    Write-Host "`nHe thong dang hoat dong. Dong cua so nay khi muon tat server.`n"
    while ($true) { Start-Sleep -Seconds 3600 }
}

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host " DANG KHOI CHAY HIẾU TRẦN LAPTOP US..." -ForegroundColor Green
Write-Host " Website: http://localhost:8080" -ForegroundColor White
Write-Host " Quan tri: http://localhost:8080/admin (admin@laptopweb.com / admin123)" -ForegroundColor White
Write-Host " Hotline: 0778.3333.62" -ForegroundColor White
Write-Host "================================================================`n" -ForegroundColor Green

# Khoi chay process Java ngam trong background va theo doi
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $javaExe
$processInfo.Arguments = "-jar `"$jarFile`""
$processInfo.WorkingDirectory = $baseDir
$processInfo.UseShellExecute = $false
$processInfo.RedirectStandardOutput = $false
$processInfo.RedirectStandardError = $false

$proc = [System.Diagnostics.Process]::Start($processInfo)

Write-Host "Dang doi may chu khoi dong tren cong 8080 de tu dong mo trinh duyet..." -ForegroundColor Yellow
$appStarted = $false
for ($i = 0; $i -lt 45; $i++) {
    Start-Sleep -Seconds 1
    if (Test-Port 8080) {
        $appStarted = $true
        break
    }
    if ($proc.HasExited) {
        break
    }
}

if ($appStarted) {
    Write-Host "`n>>> HE THONG KHOI DONG THANH CONG!" -ForegroundColor Green
    Write-Host ">>> DANG MO TRINH DUYET: http://localhost:8080 ..." -ForegroundColor Green
    Start-Process "http://localhost:8080"
} else {
    Write-WarnMsg "Khong the phat hien cong 8080 trong 45 giay. Hay thu mo thu cong http://localhost:8080"
}

# Cho tien trinh Java chay
$proc.WaitForExit()
