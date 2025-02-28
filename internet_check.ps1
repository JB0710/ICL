# Infinite loop to keep checking for internet connectivity
while ($true) {
  try {
      # Check connectivity to Google's DNS server (8.8.8.8) on port 53 (DNS)
      $connection = Test-NetConnection -ComputerName "8.8.8.8" -Port 53 -InformationLevel Quiet -ErrorAction Stop

      if ($connection) {
          Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Internet connection detected!" -ForegroundColor Green

          Set-ExecutionPolicy -ExecutionPolicy Bypass

          # Setup
          $url = "https://github.com/JB0710/ICL/archive/refs/heads/main.zip"
          $zipPath = "C:\Temp\InitialSetup.zip"
          $extractPath = "C:\Temp\ExtractedFiles\"

        # Create download directory if it doesn't exist
        if (-not (Test-Path (Split-Path $zipPath))) {
          New-Item -ItemType Directory -Path (Split-Path $zipPath) | Out-Null
        }

        # Download the ZIP file
        try {
            Write-Host "Downloading file..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
            Write-Host "Download completed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "Error downloading file: $_" -ForegroundColor Red
            exit 1
        }

        # Verify the ZIP file was downloaded
        if (-not (Test-Path $zipPath)) {
            Write-Host "Downloaded file not found!" -ForegroundColor Red
            exit 1
        }

        # Extract the ZIP file
        try {
            Write-Host "Extracting files..." -ForegroundColor Cyan
            if (-not (Test-Path $extractPath)) {
                New-Item -ItemType Directory -Path $extractPath | Out-Null
            }

            # Requires PowerShell 5.0+
            Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
            Write-Host "Extraction completed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "Error extracting files: $_" -ForegroundColor Red
            exit 1
        }

        # Clean up ZIP file
        Remove-Item -Path $zipPath -Force

        Write-Host "Process completed!" -ForegroundColor Green


      break  # Exit the loop after successful execution
    }
  }
  catch {
      # This catch block handles any errors from Test-NetConnection
  }

  # If no connection
  Write-Host "[$(Get-Date -Format 'HH:mm:ss')] No internet connection. Retrying in 5 seconds..." -ForegroundColor Red
  Start-Sleep -Seconds 5
}
