# ================================================================
#  HIEU TRAN LAPTOP US - 1-CLICK AUTO RUN SCRIPT
#  Tu dong kiem tra va tai Java, MariaDB/MySQL neu may chua co
#  Ho tro Windows 10, 11, Windows Server 2012 R2, 2016, 2019, 2022
# ================================================================

# Bat dau ghi log ngay lap tuc
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logFile = Join-Path $baseDir "startup.log"
try {
    Start-Transcript -Path $logFile -Append -Force | Out-Null
} catch {
    # Neu Start-Transcript that bai (PS co), bo qua
}

Write-Host "=== HIEU TRAN LAPTOP US - Bat dau khoi dong ===" -ForegroundColor Cyan
Write-Host "Thoi gian: $(Get-Date)" -ForegroundColor Gray
Write-Host "Thu muc: $baseDir" -ForegroundColor Gray
Write-Host "Log: $logFile" -ForegroundColor Gray
Write-Host ""

$ErrorActionPreference = "Stop"

# Kich hoat TLS 1.2 de tai file tren Windows Server 2012 R2
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls
    Write-Host "[OK] Da kich hoat TLS 1.2" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Khong the doi TLS: $($_.Exception.Message)" -ForegroundColor Yellow
}

try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Write-Host "[OK] Da tai System.IO.Compression.FileSystem" -ForegroundColor Green
} catch {
    Write-Host "[WARN] System.IO.Compression.FileSystem: $($_.Exception.Message)" -ForegroundColor Yellow
}

$toolsDir = Join-Path $baseDir "tools"
if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir | Out-Null
}

function Write-Step($msg) {
    Write-Host "`n[BUOC] $msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "  [OK] $msg" -ForegroundColor Green
}

function Write-WarnMsg($msg) {
    Write-Host "  [!!] $msg" -ForegroundColor Yellow
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
            try { $tcp.EndConnect($connect) } catch {}
            $tcp.Close()
            return $true
        }
        $tcp.Close()
        return $false
    } catch {
        return $false
    }
}

function Open-Browser($url) {
    $browserPaths = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LocalAppData}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe",
        "${env:ProgramFiles}\Mozilla Firefox\firefox.exe"
    )
    foreach ($path in $browserPaths) {
        if ($path -and (Test-Path $path)) {
            Start-Process -FilePath $path -ArgumentList $url
            return
        }
    }
    Start-Process $url
}

# ----------------------------------------------------------------
# BUOC 1: KIEM TRA & TAI JAVA (JRE 21)
# ----------------------------------------------------------------
Write-Step "Kiem tra Java Runtime tren he thong..."
$javaExe = $null

function Test-JavaExe($exe) {
    # java -fullversion in ra stdout (khac voi -version in ra stderr)
    try {
        $out = & $exe -fullversion 2>&1
        if ("$out" -match "version") { return $true }
    } catch {}
    return $false
}

$portableJava = Join-Path $toolsDir "jre\bin\java.exe"
if (Test-Path $portableJava) {
    $javaExe = $portableJava
    Write-Ok "Su dung Portable Java JRE tai tools\jre"
} else {
    # Thu tim java tren PATH he thong
    $sysJava = (Get-Command java -ErrorAction SilentlyContinue)
    if ($sysJava) {
        $javaExe = $sysJava.Source
        Write-Ok "Da tim thay Java he thong: $javaExe"
    } else {
        $javaExe = $null
        Write-WarnMsg "Khong tim thay java tren PATH he thong."
    }
}

if (-not $javaExe) {
    Write-WarnMsg "He thong chua co Java. Dang tu dong tai Portable OpenJDK 21 (khoang 49MB)..."
    Write-Host "  Vui long doi, qua trinh nay co the mat vai phut..." -ForegroundColor Yellow
    $jreZip = Join-Path $toolsDir "jre21.zip"
    $jreUrl = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jre_x64_windows_hotspot_21.0.3_9.zip"
    
    try {
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
    } catch {
        Write-Host "`n[LOI] Khong the tai Java: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  Vui long cai Java 21 thu cong tai: https://adoptium.net" -ForegroundColor Yellow
        Write-Host "  Sau khi cai xong, chay lai chuong trinh nay." -ForegroundColor Yellow
        try { Stop-Transcript | Out-Null } catch {}
        exit 1
    }
}

# Xac nhan java co chay duoc khong (dung -fullversion)
$javaVerOut = $null
$ErrorActionPreference = "Continue"
try { $javaVerOut = & $javaExe -fullversion 2>&1 } catch { $javaVerOut = $null }
$ErrorActionPreference = "Stop"
if ("$javaVerOut" -match "version") {
    Write-Ok "Java version OK: $javaVerOut"
} else {
    Write-Host "[LOI] File Java khong chay duoc: $javaExe" -ForegroundColor Red
    Write-Host "  Output: $javaVerOut" -ForegroundColor Yellow
    try { Stop-Transcript | Out-Null } catch {}
    exit 1
}


# ----------------------------------------------------------------
# BUOC 2: KIEM TRA & KHOI CHAY DATABASE (MySQL / MariaDB)
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
        Write-Host "  Vui long doi, qua trinh nay co the mat vai phut..." -ForegroundColor Yellow
        $mariaZip = Join-Path $toolsDir "mariadb.zip"
        $mariaUrl = "https://archive.mariadb.org/mariadb-10.11.8/winx64-packages/mariadb-10.11.8-winx64.zip"
        
        try {
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
            & $installDbExe --datadir="$mariadbDir\data" 2>&1 | Out-Null
        } catch {
            Write-Host "[LOI] Khong the tai MariaDB: $($_.Exception.Message)" -ForegroundColor Red
            Write-WarnMsg "Vui long dam bao MySQL/MariaDB dang chay tren cong 3306 truoc khi chay lai!"
            try { Stop-Transcript | Out-Null } catch {}
            exit 1
        }
    }
    
    Write-Step "Dang khoi dong Portable MariaDB ngam..."
    try {
        Start-Process -FilePath $mysqldExe -ArgumentList "--datadir=`"$mariadbDir\data`" --port=3306 --console" -WindowStyle Hidden
    } catch {
        Write-Host "[LOI] Khong the khoi dong MariaDB: $($_.Exception.Message)" -ForegroundColor Red
        try { Stop-Transcript | Out-Null } catch {}
        exit 1
    }
    
    # Cho cong 3306 khoi dong
    Write-Host "  Dang cho MariaDB khoi dong..." -ForegroundColor Yellow
    $retries = 30
    while (-not (Test-Port 3306) -and $retries -gt 0) {
        Start-Sleep -Seconds 1
        $retries--
        if ($retries % 5 -eq 0) {
            Write-Host "  ...con lai $retries giay..." -ForegroundColor Gray
        }
    }
    
    if (Test-Port 3306) {
        Write-Ok "Portable MariaDB da khoi dong thanh cong tai cong 3306!"
        
        # Tao database laptopweb neu chua co
        $mariaClient = Join-Path $mariadbDir "bin\mariadb.exe"
        if (Test-Path $mariaClient) {
            try {
                & $mariaClient -u root -e "CREATE DATABASE IF NOT EXISTS laptopweb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1 | Out-Null
                Write-Ok "Database 'laptopweb' da san sang."
            } catch {
                Write-WarnMsg "Khong tao duoc database tu dong, co the da ton tai."
            }
        }
    } else {
        Write-WarnMsg "Khong the tu dong bat MariaDB sau 30 giay. Kiem tra MySQL/MariaDB tren may!"
    }
}

# ----------------------------------------------------------------
# BUOC 3: XAC DINH FILE CHAY BACKEND JAR
# ----------------------------------------------------------------
Write-Step "Kiem tra file chuong trinh (app.jar)..."
$jarFile = Join-Path $baseDir "app.jar"
if (-not (Test-Path $jarFile)) {
    $jarFile = Join-Path $baseDir "backend\target\laptopweb-backend-0.0.1-SNAPSHOT.jar"
}
if (-not (Test-Path $jarFile)) {
    Write-Host "[LOI] Khong tim thay file app.jar de chay!" -ForegroundColor Red
    Write-Host "  Da kiem tra: $(Join-Path $baseDir 'app.jar')" -ForegroundColor Yellow
    Write-Host "  Da kiem tra: $(Join-Path $baseDir 'backend\target\laptopweb-backend-0.0.1-SNAPSHOT.jar')" -ForegroundColor Yellow
    try { Stop-Transcript | Out-Null } catch {}
    exit 1
}

$jarSizeMB = [math]::Round((Get-Item $jarFile).Length / 1MB, 1)
Write-Ok "Tim thay file chay: $jarFile ($jarSizeMB MB)"

# ----------------------------------------------------------------
# BUOC 4: KIEM TRA CONG 8080 VA KHOI CHAY HE THONG
# ----------------------------------------------------------------
Write-Step "Kiem tra cong 8080..."
if (Test-Port 8080) {
    Write-Ok "Ung dung da dang chay tren cong 8080!"
    Write-Host ""
    Write-Host ">>> DANG MO TRINH DUYET: http://localhost:8080 ..." -ForegroundColor Green
    Open-Browser "http://localhost:8080"
    Write-Host ""
    Write-Host "He thong dang hoat dong. Dong cua so nay khi muon tat server." -ForegroundColor Cyan
    try { Stop-Transcript | Out-Null } catch {}
    # Giu cua so mo
    while ($true) { Start-Sleep -Seconds 3600 }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host " DANG KHOI CHAY HIEU TRAN LAPTOP US..." -ForegroundColor Green
Write-Host " Website  : http://localhost:8080" -ForegroundColor White
Write-Host " Admin    : http://localhost:8080/admin" -ForegroundColor White
Write-Host " TK Admin : admin@laptopweb.com / admin123" -ForegroundColor White
Write-Host " Hotline  : 0778.3333.62" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""

# Khoi chay process Java
Write-Host "Dang khoi chay May chu (Spring Boot)..." -ForegroundColor Yellow
try {
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $javaExe
    $processInfo.Arguments = "-jar `"$jarFile`""
    $processInfo.WorkingDirectory = $baseDir
    $processInfo.UseShellExecute = $false
    $processInfo.RedirectStandardOutput = $false
    $processInfo.RedirectStandardError = $false
    
    $proc = [System.Diagnostics.Process]::Start($processInfo)
    Write-Ok "May chu da bat dau (PID: $($proc.Id)). Dang cho cong 8080..."
} catch {
    Write-Host "[LOI] Khong the khoi chay Java: $($_.Exception.Message)" -ForegroundColor Red
    try { Stop-Transcript | Out-Null } catch {}
    exit 1
}

# Doi Spring Boot khoi dong xong
$appStarted = $false
for ($i = 1; $i -le 60; $i++) {
    Start-Sleep -Seconds 1
    if (Test-Port 8080) {
        $appStarted = $true
        break
    }
    if ($proc.HasExited) {
        Write-Host "[LOI] May chu da thoat dot ngot! Ma thoat: $($proc.ExitCode)" -ForegroundColor Red
        Write-Host "  Kiem tra file startup.log de biet them chi tiet." -ForegroundColor Yellow
        break
    }
    # Hien thi trang thai moi 5 giay
    if ($i % 5 -eq 0) {
        Write-Host "  ...Dang khoi dong ($i/60 giay)..." -ForegroundColor Gray
    }
}

Write-Host ""
if ($appStarted) {
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host " >>> HE THONG KHOI DONG THANH CONG! <<<" -ForegroundColor Green
    Write-Host " >>> DANG MO TRINH DUYET: http://localhost:8080" -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Open-Browser "http://localhost:8080"
    Write-Host ""
    Write-Host "De tat server: dong cua so CMD nay." -ForegroundColor Cyan
    try { Stop-Transcript | Out-Null } catch {}
    # Giu cua so mo va doi java thoat
    $proc.WaitForExit()
} else {
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host " [THAT BAI] Khong phat hien cong 8080 trong 60 giay!" -ForegroundColor Red
    Write-Host " Hay thu mo thu cong: http://localhost:8080" -ForegroundColor Yellow
    Write-Host " Xem file startup.log de biet them chi tiet." -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Red
    try { Stop-Transcript | Out-Null } catch {}
    exit 1
}
