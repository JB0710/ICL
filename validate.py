import json
import os
import sys

def test_config():
    print("Testing config.json...")
    config_path = "weather-app/config.json"
    if not os.path.exists(config_path):
        print(f"FAIL: {config_path} not found")
        return False

    try:
        with open(config_path, "r") as f:
            data = json.load(f)

        required_keys = ["latitude", "longitude", "locationName", "units", "radarZoom", "updateIntervalMinutes"]
        for key in required_keys:
            if key not in data:
                print(f"FAIL: Missing key '{key}' in config.json")
                return False

        float(data["latitude"])
        float(data["longitude"])

        print("PASS: config.json is valid!")
        return True
    except Exception as e:
        print(f"FAIL: {e}")
        return False

def test_html():
    print("Testing index.html...")
    html_path = "weather-app/index.html"
    if not os.path.exists(html_path):
        print(f"FAIL: {html_path} not found")
        return False

    try:
        with open(html_path, "r") as f:
            content = f.read()

        essentials = [
            "<!DOCTYPE html>",
            "leaflet.css",
            "leaflet.js",
            "tailwind",
            "lucide",
            "id=\"radar-map\"",
            "id=\"forecast-panel\"",
            "id=\"forecast-cards\"",
            "config.json",
            "https://api.open-meteo.com/v1/forecast",
            "https://api.rainviewer.com/public/weather-maps.json"
        ]

        for item in essentials:
            if item not in content:
                print(f"FAIL: Missing reference '{item}' in index.html")
                return False

        print("PASS: index.html contains all necessary components and tags!")
        return True
    except Exception as e:
        print(f"FAIL: {e}")
        return False

def test_install_script():
    print("Testing install.sh...")
    install_path = "install.sh"
    if not os.path.exists(install_path):
        print(f"FAIL: {install_path} not found")
        return False

    try:
        with open(install_path, "r") as f:
            content = f.read()

        essentials = [
            "#!/bin/bash",
            "apt-get install",
            "weather-app.service",
            "weather-app-kiosk.desktop",
            "launch-kiosk.sh",
            "http.server 8080"
        ]

        for item in essentials:
            if item not in content:
                print(f"FAIL: Missing installation sequence for '{item}' in install.sh")
                return False

        print("PASS: install.sh is structured properly!")
        return True
    except Exception as e:
        print(f"FAIL: {e}")
        return False

def main():
    success = True
    success &= test_config()
    success &= test_html()
    success &= test_install_script()

    if success:
        print("\nALL TESTS PASSED SUCCESSFULLY!")
    else:
        print("\nSOME TESTS FAILED!")
        sys.exit(1)

if __name__ == "__main__":
    main()
