#requires -version 2
<#
.SYNOPSIS
  <Overview of script>
.DESCRIPTION
  <Brief description of script>
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development

.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

#region Declarations
#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"
$sScriptAuthor = "Jonathan Wood / JWOOD1"

#Log File Info
$sLogPath = "C:\IT\Logs\"
$scriptName = $MyInvocation.MyCommand.Name
$sLogName = "$scriptName.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#Variables
$sScriptTimestamp = $(Get-Date -Format 'dddd, MMMM dd, yyyy')
$sScriptCurrentUser = $(Get-WMIobject -Class Win32_Computersystem | Select-Object -ExpandProperty Username)
$sScriptRunAsUser = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)

#endregion

#region Initialisations
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

function Write-Log {
  param (
      [Parameter(Mandatory=$False, Position=0)]
      [String]$Entry
  )

  "TimeStamp [$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff')] - $Entry" | Out-File -FilePath $sLogFile -Append
}

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Create Folder Structure
Write-Log -Entry "------------Checking Folder Structure------------"
$folders = @(
    "C:\Temp",
    "C:\Temp\Apps",
    "C:\Temp\Logs",
    "C:\Temp\Scripts",
    "C:\IT",
    "C:\IT\Apps",
    "C:\IT\Logs",
    "C:\IT\Scripts"
)

# Loop through each folder in the list
foreach ($folder in $folders) {
    # Check if the folder exists
    if (-not (Test-Path -Path $folder)) {
        Write-Log -Entry "------------Creating Folder Structure------------"
        Write-Host "Folder '$folder' does not exist. Creating..." -ForegroundColor Yellow
        Write-Log -Entry "Folder '$folder' does not exist. Creating..."
        try {
            # Create the folder
            New-Item -Path $folder -ItemType Directory -ErrorAction Stop
            Write-Host "Folder '$folder' created successfully." -ForegroundColor Green
            Write-Log -Entry "Folder '$folder' created successfully."
        } catch {
            Write-Host "Failed to create folder '$folder'. Error: $_" -ForegroundColor Red
            Write-Log -Entry "Failed to create folder '$folder'. Error: $_"
        }
    } else {
        Write-Host "Folder '$folder' already exists." -ForegroundColor Cyan
        Write-Log -Entry "Folder '$folder' already exists."
    }
}
Write-Log -Entry "------------Folder Structure Setup Complete------------`n"

#Get Needed Modules
Write-Log -Entry "------------Checking Required Modules------------"
$modules = @(
    "PSLogging",
    "PSWindowsUpdate",
    "Pester",
    "PSFramework",
    "PSDepend",
    "PSReadLine",
    "ThreadJob",
    "ImportExcel",
    "PSWriteColor"
)

# Loop through each module in the list
foreach ($module in $modules) {
    # Check if the module is already installed
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Log -Entry "------------Installings Required Modules------------"
        Write-Host "Module '$module' is not installed. Installing..." -ForegroundColor Yellow
        Write-Log -Entry "Module '$module' is not installed. Installing..."
        try {
            # Install the module
            Install-Module -Name $module -Force -AllowClobber -ErrorAction Stop
            Write-Host "Module '$module' installed successfully." -ForegroundColor Green
            Write-Log -Entry "Module '$module' installed successfully."
        } catch {
            Write-Host "Failed to install module '$module'. Error: $_" -ForegroundColor Red
            Write-Log -Entry "Failed to install module '$module'. Error: $_"
        }
    } else {
        Write-Host "Module '$module' is already installed." -ForegroundColor Cyan
        Write-Log -Entry "Module '$module' is already installed."
    }
}
Write-Log -Entry "------------Install Modules Complete------------`n"
#endregion

#region Functions
#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Test_Function{
  Param()

  Begin{
    Write-Log -Entry "------------Script Details-------------"
    Write-Log -Entry "Script Details:"
    Write-Log -Entry "  Script Name: $scriptName"
    Write-Log -Entry "  Version: $sScriptVersion"
    Write-Log -Entry "  Author: $sScriptAuthor"
    Write-Log -Entry "  Current User: $sScriptCurrentUser"
    Write-Log -Entry "  RunAs: $sScriptRunAsUser"
    Write-Log -Entry "  Started: $sScriptTimestamp"
    Write-Log -Entry "----------End of Details--------------`n"
  }

  Process{
    Try{
      Get-Service "SolarWinds TFTP Server"
    }

    Catch{
      Write-Log -Entry -ErrorDesc $_.Exception -ExitGracefully $True
      Break
    }
  }

  End{
    If($?){
      Write-Log -Entry "Script [$scriptName] Completed Successfully."

    }
  }
}

#endregion

#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

Test_Function

#endregion


