# Fuel Tracker Windows Offline Setup Script
# This script configures PHP, MariaDB, and phpMyAdmin for the Fuel Tracker app.
# Target Directory: C:\IT\Apps\FuelTracker

$targetDir = "C:\IT\Apps\FuelTracker"
$phpDir = "$targetDir\php"
$mariadbDir = "$targetDir\mariadb"
$appDir = "$targetDir\www"
$pmaDir = "$appDir\phpmyadmin"

Write-Host "Starting Fuel Tracker Setup..." -ForegroundColor Cyan

# 1. Create Directory Structure
if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

foreach ($dir in @($phpDir, $mariadbDir, $appDir, $pmaDir)) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# 2. Configure PHP
$phpIni = "$phpDir\php.ini"
if (Test-Path "$phpDir\php.ini-development") {
    if (!(Test-Path $phpIni)) {
        Copy-Item "$phpDir\php.ini-development" $phpIni
    }

    Write-Host "Configuring php.ini..."
    $content = Get-Content $phpIni
    $content = $content -replace ';extension_dir = "ext"', 'extension_dir = "ext"'
    $content = $content -replace ';extension=pdo_mysql', 'extension=pdo_mysql'
    $content = $content -replace ';extension=mysqli', 'extension=mysqli'
    $content = $content -replace ';extension=mbstring', 'extension=mbstring'
    $content | Set-Content $phpIni
} else {
    Write-Warning "php.ini-development not found in $phpDir. Please ensure PHP binaries are present."
}

# 3. Database Initialization (MariaDB)
$mariadbInstallDb = "$mariadbDir\bin\mariadb-install-db.exe"
if (Test-Path $mariadbInstallDb) {
    Write-Host "Initializing MariaDB data directory..."
    Start-Process -FilePath $mariadbInstallDb -ArgumentList "--datadir=$mariadbDir\data" -Wait
}

# 4. Copy Application Files
Write-Host "Copying application files..."
$currentDir = Get-Location
Copy-Item -Path "$currentDir\index.php", "$currentDir\add.php", "$currentDir\schema.sql", "$currentDir\README.md", "$currentDir\start_app.bat" -Destination $appDir -Force
Copy-Item -Path "$currentDir\includes", "$currentDir\css" -Destination $appDir -Recurse -Force

# 5. Configure phpMyAdmin (if files are present)
if (Test-Path "$currentDir\phpmyadmin_config.inc.php") {
    Copy-Item -Path "$currentDir\phpmyadmin_config.inc.php" -Destination "$pmaDir\config.inc.php" -Force
}

Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "Please ensure PHP, MariaDB, and phpMyAdmin binaries are placed in their respective folders."
