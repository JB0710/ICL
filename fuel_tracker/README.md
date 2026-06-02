# Fuel Tracker (US Version)

A simple, self-hosted PHP website to track fuel consumption for a single vehicle using US measurements (Miles, Gallons, MPG). Supports Light and Dark modes.

## Features
- Dashboard with statistics: Total Distance (mi), Efficiency (MPG), Total Cost, Avg Price ($/gal).
- Fueling History table.
- Add Entry form.
- Dark Mode support (automatic based on system settings).

## Windows Offline Installation (Standalone)

To run this on an offline Windows computer at `C:\IT\Apps\FuelTracker`:

1. **Prerequisites**:
   - Download portable PHP for Windows.
   - Download portable MariaDB for Windows.

2. **Folder Structure**:
   - Create `C:\IT\Apps\FuelTracker`.
   - Place PHP binaries in `C:\IT\Apps\FuelTracker\php`.
   - Place MariaDB binaries in `C:\IT\Apps\FuelTracker\mariadb`.
   - Place this application folder content in a temporary location.

3. **Setup**:
   - Open PowerShell as Administrator.
   - Navigate to the application folder.
   - Run: `.\setup_windows.ps1`
   - This script will configure `php.ini`, initialize the database, and move application files to `C:\IT\Apps\FuelTracker\www`.

4. **Running the App**:
   - Double-click `start_app.bat` in `C:\IT\Apps\FuelTracker\www` (or your source folder).
   - Open your browser to `http://localhost:8080`.

## Manual Setup (Generic)
1. **Database Setup**: Create a MySQL database `fuel_tracker` and run `schema.sql`.
2. **Configuration**: Update `includes/db.php` with your credentials.
3. **Deployment**: Place files in your web server's root.

## How to use
- **First Entry**: Enter your current odometer reading and fill the tank.
- **Subsequent Entries**: Enter the date, new odometer reading, gallons added, and the price per gallon.
