#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Helper functions for logs
log() {
    echo -e "\e[1;32m[+] $1\e[0m"
}

warn() {
    echo -e "\e[1;33m[!] $1\e[0m"
}

error() {
    echo -e "\e[1;31m[-] $1\e[0m"
}

# Real user and home determination
if [ "$EFFECTIVE_USER" = "" ]; then
    REAL_USER=${SUDO_USER:-$USER}
else
    REAL_USER=$EFFECTIVE_USER
fi

REAL_HOME=$(eval echo ~$REAL_USER)
INSTALL_DIR="$REAL_HOME/weather-app"

log "Starting Weather Radar & Forecast App Installation for Raspberry Pi 5"
log "Installing to directory: $INSTALL_DIR"
log "Running as user: $REAL_USER (Home: $REAL_HOME)"

# -------------------------------------------------------------
# INTERACTIVE LOCATION SETUP
# -------------------------------------------------------------
echo "================================================================="
echo "                  LOCATION & PREFERENCES SETUP"
echo "================================================================="
echo "Please enter details for your location to configure your weather radar."
echo "If you press ENTER, the default value in brackets [like this] will be used."
echo ""

# Prompt for Location Name
read -p "Enter Location Name (e.g., Seattle, WA) [New York, NY]: " USER_LOC_NAME
if [ -z "$USER_LOC_NAME" ]; then
    USER_LOC_NAME="New York, NY"
fi

# Prompt for Latitude
read -p "Enter Latitude (e.g., 47.6062) [40.7128]: " USER_LAT
if [ -z "$USER_LAT" ]; then
    USER_LAT="40.7128"
fi

# Prompt for Longitude
read -p "Enter Longitude (e.g., -122.3321) [-74.0060]: " USER_LON
if [ -z "$USER_LON" ]; then
    USER_LON="-74.0060"
fi

# Prompt for Units
read -p "Enter Units (imperial/metric) [imperial]: " USER_UNITS
if [ -z "$USER_UNITS" ]; then
    USER_UNITS="imperial"
else
    USER_UNITS=$(echo "$USER_UNITS" | tr '[:upper:]' '[:lower:]')
    if [ "$USER_UNITS" != "imperial" ] && [ "$USER_UNITS" != "metric" ]; then
        warn "Invalid units. Defaulting to imperial."
        USER_UNITS="imperial"
    fi
fi

log "Configuration selected:"
echo "  Location Name: $USER_LOC_NAME"
echo "  Latitude:      $USER_LAT"
echo "  Longitude:     $USER_LON"
echo "  Units:         $USER_UNITS"
echo "================================================================="

# 1. Update system and install required packages
log "Updating package list and installing dependencies..."
sudo apt-get update -y || warn "apt-get update failed, attempting to proceed anyway"

PACKAGES="python3 unclutter"
if apt-cache show chromium-browser &>/dev/null; then
    PACKAGES="$PACKAGES chromium-browser"
elif apt-cache show chromium &>/dev/null; then
    PACKAGES="$PACKAGES chromium"
else
    warn "Chromium package not found in cache. Attempting to install 'chromium-browser' anyway."
    PACKAGES="$PACKAGES chromium-browser"
fi

sudo apt-get install -y $PACKAGES || warn "Some packages failed to install. Please ensure python3, unclutter, and chromium-browser are installed."

# 2. Create target directory and copy application files
log "Creating application directory structure..."
mkdir -p "$INSTALL_DIR"

if [ -f "weather-app/index.html" ]; then
    cp "weather-app/index.html" "$INSTALL_DIR/"
elif [ -f "index.html" ]; then
    cp "index.html" "$INSTALL_DIR/"
else
    error "Source files index.html not found in current directory!"
    exit 1
fi

# Generate customized config.json based on user inputs
log "Generating customized config.json..."
cat << CONFIG > "$INSTALL_DIR/config.json"
{
  "latitude": $USER_LAT,
  "longitude": $USER_LON,
  "locationName": "$USER_LOC_NAME",
  "units": "$USER_UNITS",
  "radarZoom": 8,
  "updateIntervalMinutes": 10
}
CONFIG

sudo chown -R $REAL_USER:$REAL_USER "$INSTALL_DIR"

# 3. Create helper launcher script
log "Creating launcher script..."
cat << 'LAUNCHER' > "$INSTALL_DIR/launch-kiosk.sh"
#!/bin/bash

# Allow some time for X/Wayland and local server to fully load
sleep 5

# Hide cursor
unclutter -idle 0.5 &

# Determine Chromium binary name
if command -v chromium-browser &> /dev/null; then
    BROWSER="chromium-browser"
elif command -v chromium &> /dev/null; then
    BROWSER="chromium"
else
    BROWSER="chromium-browser"
fi

# Run Chromium in Kiosk mode
$BROWSER --kiosk --noerrdialogs --disable-infobars --no-first-run --ozone-platform-hint=auto http://localhost:8080
LAUNCHER

chmod +x "$INSTALL_DIR/launch-kiosk.sh"
sudo chown $REAL_USER:$REAL_USER "$INSTALL_DIR/launch-kiosk.sh"

# 4. Create local HTTP web server systemd service
log "Creating systemd web server service..."
cat << SYSTEMD | sudo tee /etc/systemd/system/weather-app.service > /dev/null
[Unit]
Description=Weather App Local Python HTTP Server
After=network.target

[Service]
Type=simple
User=$REAL_USER
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/python3 -m http.server 8080
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SYSTEMD

# Enable and start the systemd service
log "Enabling and starting systemd service..."
sudo systemctl daemon-reload || true
sudo systemctl enable weather-app.service || true
sudo systemctl restart weather-app.service || true

# 5. Create autostart entry for graphical Kiosk Mode on login
log "Configuring graphical Kiosk Autostart..."
AUTOSTART_DIR="$REAL_HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat << AUTOSTART > "$AUTOSTART_DIR/weather-app-kiosk.desktop"
[Desktop Entry]
Type=Application
Name=Weather Radar & Forecast Kiosk
Exec=$INSTALL_DIR/launch-kiosk.sh
X-GNOME-Autostart-enabled=true
AUTOSTART

sudo chown -R $REAL_USER:$REAL_USER "$REAL_HOME/.config"

log "================================================================="
log "Installation Successful!"
log "================================================================="
log "The weather application has been installed in: $INSTALL_DIR"
log "The application server runs locally at: http://localhost:8080"
log "You can customize settings like Lat/Lon in: $INSTALL_DIR/config.json"
log "The application will auto-launch on reboot."
log "================================================================="
