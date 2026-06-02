# Fuel Tracker

A simple, self-hosted PHP website to track fuel consumption for a single vehicle.

## Features
- Dashboard with statistics:
  - Total Distance
  - Average Consumption (L/100km)
  - Total Cost
  - Average Price per Liter
- Fueling History table
- Easy-to-use "Add Entry" form

## Requirements
- PHP 7.4 or higher
- MySQL / MariaDB
- A web server (Apache, Nginx, or PHP's built-in server)

## Setup Instructions
1. **Database Setup**:
   - Create a MySQL database named `fuel_tracker`.
   - Run the contents of `schema.sql` to create the necessary table.
   - Example: `mysql -u root -p fuel_tracker < schema.sql`

2. **Configuration**:
   - Open `includes/db.php`.
   - Update the database credentials (`$host`, `$db`, `$user`, `$pass`) to match your environment.

3. **Deployment**:
   - Place the `fuel_tracker` folder in your web server's document root (e.g., `/var/www/html`).
   - Access the site via your browser (e.g., `http://localhost/fuel_tracker`).

## How to use
- **First Entry**: Enter your current odometer reading and fill the tank. The first entry is used as a baseline for distance.
- **Subsequent Entries**: Every time you refuel, enter the date, new odometer reading, liters added, and the price per liter. The system will automatically calculate your consumption and statistics.
