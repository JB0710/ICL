@echo off
SET APP_DIR=C:\IT\Apps\FuelTracker
SET PHP_BIN=%APP_DIR%\php\php.exe
SET MYSQL_BIN=%APP_DIR%\mariadb\bin\mysqld.exe

echo Starting Fuel Tracker...

:: Start MariaDB
echo Starting MariaDB...
start "MariaDB" /B "%MYSQL_BIN%" --datadir="%APP_DIR%\mariadb\data" --console

:: Wait a few seconds for DB to initialize
timeout /t 5 /nobreak > nul

:: Start PHP Web Server
echo Starting Web Server at http://localhost:8080
echo phpMyAdmin is available at http://localhost:8080/phpmyadmin
cd /d "%APP_DIR%\www"
"%PHP_BIN%" -S localhost:8080
