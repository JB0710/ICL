# Fuel Tracker (US Version)

A simple, self-hosted PHP website to track fuel consumption for a single vehicle using US measurements (Miles, Gallons, MPG). Supports Light and Dark modes.

## Features
- Dashboard with statistics: Total Distance (mi), Efficiency (MPG), Total Cost, Avg Price ($/gal).
- Fueling History table.
- Add Entry form.
- Dark Mode support.
- phpMyAdmin included for database management.

## Downloads (Portable Versions)
To run this offline, download the following components:
- **PHP 8.x (Windows x64 Thread Safe)**: [https://windows.php.net/download/](https://windows.php.net/download/) (Download the "Zip" file)
- **MariaDB (Windows x64 ZIP)**: [https://mariadb.org/download/](https://mariadb.org/download/) (Select "ZIP file" under Package Type)
- **phpMyAdmin**: [https://www.phpmyadmin.net/downloads/](https://www.phpmyadmin.net/downloads/) (Download the "all-languages.zip")

## Windows Offline Installation (Standalone)

Target Directory: `C:\IT\Apps\FuelTracker`

1. **Folder Structure Setup**:
   - Create `C:\IT\Apps\FuelTracker`.
   - Extract PHP into `C:\IT\Apps\FuelTracker\php`.
   - Extract MariaDB into `C:\IT\Apps\FuelTracker\mariadb`.
   - Extract phpMyAdmin into this application's folder as a subfolder named `phpmyadmin` (so it becomes `.../fuel_tracker/phpmyadmin`).

2. **Run Setup**:
   - Open PowerShell as Administrator.
   - Navigate to the `fuel_tracker` application folder.
   - Run: `.\setup_windows.ps1`
   - This script configures PHP, initializes the database, and moves everything to `C:\IT\Apps\FuelTracker\www`.

3. **Running the App**:
   - Run `C:\IT\Apps\FuelTracker\www\start_app.bat`.
   - Application: [http://localhost:8080](http://localhost:8080)
   - phpMyAdmin: [http://localhost:8080/phpmyadmin](http://localhost:8080/phpmyadmin)

## Manual Setup (Generic)
1. **Database**: Create `fuel_tracker` DB and run `schema.sql`.
2. **Configuration**: Update `includes/db.php`.
3. **Web Server**: Deploy files to your server's root.

## How to use
- **First Entry**: Enter current odometer reading and fill the tank.
- **Subsequent Entries**: Enter date, new odometer, gallons added, and price per gallon.
