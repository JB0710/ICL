CREATE DATABASE IF NOT EXISTS fuel_tracker;
USE fuel_tracker;

CREATE TABLE IF NOT EXISTS fuel_entries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fill_date DATE NOT NULL,
    odometer DECIMAL(10, 2) NOT NULL,
    liters DECIMAL(10, 2) NOT NULL,
    price_per_liter DECIMAL(10, 3) NOT NULL,
    total_cost DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
