# Fuel Tracker (US Version)

A simple, self-hosted PHP website to track fuel consumption for a single vehicle using US measurements (Miles, Gallons, MPG). Supports Light and Dark modes.

## Windows Standalone Setup (C:\IT\Apps\FuelTracker)

This project includes an automated setup script that downloads all required software (PHP, MariaDB, phpMyAdmin) and configures the environment.

### Steps:

1. **Copy Files**: Place the `fuel_tracker` folder on your Windows computer.
2. **Run Setup**:
   - Open PowerShell as **Administrator**.
   - Navigate to the `fuel_tracker` folder.
   - Run: `.\setup_windows.ps1`
   - *This will download about 150MB of data and set up everything at `C:\IT\Apps\FuelTracker`.*
3. **Start the App**:
   - Go to `C:\IT\Apps\FuelTracker\www`.
   - Run `start_app.bat`.
4. **Access**:
   - Website: [http://localhost:8080](http://localhost:8080)
   - Database (phpMyAdmin): [http://localhost:8080/phpmyadmin](http://localhost:8080/phpmyadmin)

## Features
- Dashboard with statistics: Total Distance (mi), Efficiency (MPG), Total Cost, Avg Price ($/gal).
- Fueling History table.
- Add Entry form.
- Automatic Dark Mode support.
- Automated installer and standalone configuration.

## Manual Setup
1. **Database**: Create `fuel_tracker` DB and run `schema.sql`.
2. **Configuration**: Update `includes/db.php`.
3. **Web Server**: Deploy files to your server's root.
