# Fuel Tracker Windows Offline Setup Script
# This script downloads, installs, and configures PHP, MariaDB, and phpMyAdmin.
# Target Directory: C:\IT\Apps\FuelTracker

$targetDir = "C:\IT\Apps\FuelTracker"
$phpDir = "$targetDir\php"
$mariadbDir = "$targetDir\mariadb"
$appDir = "$targetDir\www"
$pmaDir = "$appDir\phpmyadmin"
$tempDir = "$targetDir\temp"
$tempPort = 3307

# URLs for components
$phpUrl = "https://windows.php.net/downloads/releases/php-8.3.6-Win32-vs16-x64.zip"
$mariadbUrl = "https://archive.mariadb.org/mariadb-11.4.2/winx64-packages/mariadb-11.4.2-winx64.zip"
$pmaUrl = "https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip"

Write-Host "Starting Fuel Tracker Full Setup..." -ForegroundColor Cyan

# 1. Create Directory Structure
if (!(Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir | Out-Null }

function Download-And-Extract {
    param($url, $destination)
    $zipFile = Join-Path $tempDir (Split-Path $url -Leaf)
    if (!(Test-Path $zipFile)) {
        Write-Host "Downloading $(Split-Path $url -Leaf)..."
        Invoke-WebRequest -Uri $url -OutFile $zipFile
    }
    Write-Host "Extracting to $destination..."
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force

    $extractedFolder = Get-ChildItem -Path $tempDir -Directory | Where-Object { $zipFile -like "*$($_.Name)*" -or $_.Name -like "phpMyAdmin*" } | Select-Object -First 1
    if ($extractedFolder) {
        Copy-Item -Path "$($extractedFolder.FullName)\*" -Destination $destination -Recurse -Force
        Remove-Item -Path $extractedFolder.FullName -Recurse -Force
    }
}

# 2. Download and Extract Components
if (!(Test-Path $phpDir)) { New-Item -ItemType Directory -Path $phpDir | Out-Null; Download-And-Extract $phpUrl $phpDir }
if (!(Test-Path $mariadbDir)) { New-Item -ItemType Directory -Path $mariadbDir | Out-Null; Download-And-Extract $mariadbUrl $mariadbDir }
if (!(Test-Path $pmaDir)) { New-Item -ItemType Directory -Path $pmaDir | Out-Null; Download-And-Extract $pmaUrl $pmaDir }

# 3. Configure PHP
$phpIni = "$phpDir\php.ini"
if (Test-Path "$phpDir\php.ini-development") {
    Copy-Item "$phpDir\php.ini-development" $phpIni -Force
    Write-Host "Configuring php.ini..."
    $content = Get-Content $phpIni
    $content = $content -replace ';extension_dir = "ext"', 'extension_dir = "ext"'
    $content = $content -replace ';extension=pdo_mysql', 'extension=pdo_mysql'
    $content = $content -replace ';extension=mysqli', 'extension=mysqli'
    $content = $content -replace ';extension=mbstring', 'extension=mbstring'
    $content | Set-Content $phpIni
}

# 4. Database Initialization
$mariadbInstallDb = "$mariadbDir\bin\mariadb-install-db.exe"
if (!(Test-Path "$mariadbDir\data")) {
    Write-Host "Initializing MariaDB data directory..."
    Start-Process -FilePath $mariadbInstallDb -ArgumentList "--datadir=$mariadbDir\data" -Wait
}

# Start MariaDB temporarily on a custom port to initialize database
Write-Host "Starting MariaDB on port $tempPort to initialize database..."
$mysqld = "$mariadbDir\bin\mysqld.exe"
$mysqlProcess = Start-Process -FilePath $mysqld -ArgumentList "--datadir=$mariadbDir\data", "--port=$tempPort", "--skip-grant-tables", "--console" -PassThru -NoNewWindow
$retryCount = 0
$maxRetries = 15
$portFound = $false

while ($retryCount -lt $maxRetries -and -not $portFound) {
    Write-Host "Waiting for MariaDB to start (Attempt $($retryCount + 1))..."
    if (Test-NetConnection -ComputerName localhost -Port $tempPort -InformationLevel Quiet) {
        $portFound = $true
    } else {
        $retryCount++
        Start-Sleep -Seconds 2
    }
}

if ($portFound) {
    $mysqlExe = "$mariadbDir\bin\mariadb.exe"
    Write-Host "Creating database and tables..."
    $schemaPath = Join-Path (Get-Location) "schema.sql"
    & $mysqlExe -P $tempPort -u root -e "CREATE DATABASE IF NOT EXISTS fuel_tracker;"
    Get-Content "$schemaPath" | & $mysqlExe -P $tempPort -u root fuel_tracker
    Write-Host "Database initialization complete."
} else {
    Write-Error "Could not connect to MariaDB on port $tempPort after $maxRetries attempts."
}

# Cleanly stop MariaDB
if ($mysqlProcess -and !( $mysqlProcess.HasExited )) {
    Write-Host "Stopping temporary MariaDB process..."
    Stop-Process -Id $mysqlProcess.Id -Force -ErrorAction SilentlyContinue
}

# 5. Copy Application Files
Write-Host "Copying application files..."
if (!(Test-Path $appDir)) { New-Item -ItemType Directory -Path $appDir | Out-Null }
$currentDir = Get-Location
Copy-Item -Path "$currentDir\index.php", "$currentDir\add.php", "$currentDir\schema.sql", "$currentDir\README.md", "$currentDir\start_app.bat" -Destination $appDir -Force
Copy-Item -Path "$currentDir\includes", "$currentDir\css" -Destination $appDir -Recurse -Force

if (Test-Path "$currentDir\phpmyadmin_config.inc.php") {
    Copy-Item -Path "$currentDir\phpmyadmin_config.inc.php" -Destination "$pmaDir\config.inc.php" -Force
}

Write-Host "Setup Complete!" -ForegroundColor Green
