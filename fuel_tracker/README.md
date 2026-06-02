# Fuel Tracker (US Version)

A simple, self-hosted PHP website to track fuel consumption for a single vehicle using US measurements (Miles, Gallons, MPG). Supports Light and Dark modes based on system settings.

## Features
- Dashboard with statistics:
  - Total Distance (Miles)
  - Efficiency (MPG)
  - Total Cost
  - Average Price per Gallon
- Fueling History table
- Easy-to-use "Add Entry" form
- Dark Mode support

## Requirements
- PHP 7.4 or higher
- MySQL / MariaDB
- A web server

## Setup Instructions
1. **Database Setup**:
   - Create a MySQL database named `fuel_tracker`.
   - Run the contents of `schema.sql` to create the necessary table.
   - Example: `mysql -u root -p fuel_tracker < schema.sql`

2. **Configuration**:
   - Open `includes/db.php`.
   - Update the database credentials to match your environment.

3. **Deployment**:
   - Place the `fuel_tracker` folder in your web server's document root.
   - Access the site via your browser.

## How to use
- **First Entry**: Enter your current odometer reading and fill the tank.
- **Subsequent Entries**: Enter the date, new odometer reading, gallons added, and the price per gallon. The system will automatically calculate MPG.
