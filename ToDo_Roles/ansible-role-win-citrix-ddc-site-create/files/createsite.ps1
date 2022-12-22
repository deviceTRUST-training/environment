#==========================================================================
#
# Configure the Citrix XenDeskop Site
#
# AUTHOR: Dennis Span (https://dennisspan.com)
# DATE  : 05.04.2017
#
# Editor: Sven Jansen
# DATE  : 05.2022
#
#==========================================================================

# define Error handling
# note: do not change these values
$global:ErrorActionPreference = "Stop"
if($verbose){ $global:VerbosePreference = "Continue" }

# FUNCTION DS_WriteLog
#==========================================================================
Function DS_WriteLog {
    [CmdletBinding()]
	Param( 
        [Parameter(Mandatory=$true, Position = 0)][String]$InformationType,
        [Parameter(Mandatory=$true, Position = 1)][AllowEmptyString()][String]$Text,
        [Parameter(Mandatory=$true, Position = 2)][AllowEmptyString()][String]$LogFile
    )

	$DateTime = (Get-Date -format dd-MM-yyyy) + " " + (Get-Date -format HH:mm:ss)
	
    if ( $Text -eq "" ) {
        Add-Content $LogFile -value ("") # Write an empty line
    } Else {
        Add-Content $LogFile -value ($DateTime + " " + $InformationType + " - " + $Text)
        Write-Output ($DateTime + " " + $InformationType + " - " + $Text)
    }
}
#==========================================================================

################
# Main section #
################

# Disable File Security
$env:SEE_MASK_NOZONECHECKS = 1

# Custom variables [edit]
$BaseLogDir = "C:\Logs"                                         # [edit] add the location of your log directory here
$PackageName = "Citrix XenDesktop Site (configure)"             # [edit] enter the display name of the software (e.g. 'Arcobat Reader' or 'Microsoft Office')

# Global variables
$ComputerName = $env:ComputerName
if (!($Installationtype -eq "Uninstall")) { $Installationtype = "Install" }
$LogDir = (Join-Path $BaseLogDir $PackageName).Replace(" ","_")
$LogFileName = "$($Installationtype)_$($PackageName).log"
$LogFile = Join-path $LogDir $LogFileName

# Create the log directory if it does not exist
if (!(Test-Path $LogDir)) { New-Item -Path $LogDir -ItemType directory | Out-Null }

# Create new log file (overwrite existing one)
New-Item $LogFile -ItemType "file" -force | Out-Null

DS_WriteLog "I" "START SCRIPT - $PackageName" $LogFile
DS_WriteLog "-" "" $LogFile

#################################################
# WAIT FOR SQL SERVICE BEING AVAILABLE          #
#################################################

DS_WriteLog "I" "Wait for Service MSSQL" $LogFile
DS_WriteLog "-" "" $LogFile

$running = "false"
$i = 0
while($running -ne "true"){
    if((get-service MSSQL*).Status -eq "Running"){$running = "true"}

    DS_WriteLog "-" "" $LogFile
    DS_WriteLog "Iteration: $i" "" $LogFile
    DS_WriteLog "Status: $running" "" $LogFile

    start-sleep -seconds 5
    $i++
}

#################################################
# INSTALL CITRIX DELIVERY CONTROLLER            #
#################################################

DS_WriteLog "I" "Create and configure the XenDesktop site" $LogFile

DS_WriteLog "-" "" $LogFile

# Define the variables needed in this script:
DS_WriteLog "I" "Define the variables needed in this script:" $LogFile

# -----------------------------------
# CUSTOMIZE THE FOLLOWING VARIABLES TO YOUR REQUIREMENTS
# -----------------------------------
$SiteName = $env:SiteName
$DatabaseServer = $env:DatabaseServer
$DatabaseServerPort = $env:DatabaseServerPort
$DatabaseName_Site = $env:DatabaseName_Site
$DatabaseName_Logging = $env:DatabaseName_Logging
$DatabaseName_Monitoring = $env:DatabaseName_Monitoring
$LicenseServer = $env:LicenseServer
$LicenseServerPort = $env:LicenseServerPort
$LicensingModel = $env:LicensingModel
$ProductCode = $env:ProductCode
$ProductEdition = $env:ProductEdition
$AdminGroup = $env:AdminGroup 
$Role = $env:Role
$Scope = $env:Scope
$GroomingDays = $env:GroomingDays
# -----------------------------------

# Log Variables
DS_WriteLog "I" "-Site name = $SiteName" $LogFile
DS_WriteLog "I" "-Database server (+ instance) = $DatabaseServer" $LogFile
DS_WriteLog "I" "-Database server port = $DatabaseServerPort" $LogFile
DS_WriteLog "I" "-Database name for site DB = $DatabaseName_Site" $LogFile
DS_WriteLog "I" "-Database name for logging DB = $DatabaseName_Logging" $LogFile
DS_WriteLog "I" "-Database name for monitoring DB = $DatabaseName_Monitoring" $LogFile
DS_WriteLog "I" "-License server = $DatabaseServer" $LogFile
DS_WriteLog "I" "-License server port = $LicenseServerPort" $LogFile
DS_WriteLog "I" "-Licensing model = $LicensingModel" $LogFile
DS_WriteLog "I" "-Product code = $ProductCode" $LogFile
DS_WriteLog "I" "-Product edition = $ProductEdition" $LogFile
DS_WriteLog "I" "-Administrator group name = $AdminGroup" $LogFile
DS_WriteLog "I" "-Administrator group role = $Role" $LogFile
DS_WriteLog "I" "-Administrator group scope = $Scope" $LogFile
DS_WriteLog "I" "-Grooming days = $GroomingDays" $LogFile

DS_WriteLog "-" "" $LogFile

# IMPORT MODULES AND SNAPINS
# --------------------------

# Import the XenDesktop Admin module
DS_WriteLog "I" "Import the XenDesktop Admin module" $LogFile
try {
    Import-Module Citrix.XenDesktop.Admin
    DS_WriteLog "S" "The XenDesktop Admin module was imported successfully" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to import the XenDesktop Admin module (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# Load the Citrix snap-ins
DS_WriteLog "I" "Load the Citrix snap-ins" $LogFile
try {
    Add-PSSnapIn citrix.*
    DS_WriteLog "S" "The Citrix snap-ins were loaded successfully" $LogFile
} catch {
    DS_WriteLog "E"  "An error occurred trying to load the Citrix snap-ins (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# CREATE DATABASES
# ----------------

# Create the site database (the classical try / catch statement does not work for some reason, so I had to use an "uglier" method for error handling)
DS_WriteLog "I" "Create the site database" $LogFile
try {
    New-XDDatabase -AdminAddress $ComputerName -SiteName $SiteName -DataStore Site -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName_Site -ErrorAction Stop | Out-Null
    DS_WriteLog "S" "The site database '$DatabaseName_Site' was created successfully" $LogFile
} catch {
    [string]$ErrorText = $Error[0]
    If ( $ErrorText.Contains("already exists")) {
        DS_WriteLog "I" "The site database '$DatabaseName_Site' already exists. Nothing to do." $LogFile
    } else {
        DS_WriteLog "E" "An error occurred trying to create the site database '$DatabaseName_Site' (error: $($Error[0]))" $LogFile
        # Exit 1
    }
}

DS_WriteLog "-" "" $LogFile

# Create the logging database
DS_WriteLog "I" "Create the logging database" $LogFile
try {
    New-XDDatabase -AdminAddress $ComputerName -SiteName $SiteName -DataStore Logging -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName_Logging -ErrorAction Stop | Out-Null
    DS_WriteLog "S" "The logging database '$DatabaseName_Logging' was created successfully" $LogFile
} catch {
    [string]$ErrorText = $Error[0]
    If ( $ErrorText.Contains("already exists")) {
        DS_WriteLog "I" "The logging database '$DatabaseName_Logging' already exists. Nothing to do." $LogFile
    } else {
        DS_WriteLog "E" "An error occurred trying to create the logging database '$DatabaseName_Logging' (error: $($Error[0]))" $LogFile
        Exit 1
    }
}

DS_WriteLog "-" "" $LogFile

# Create the monitoring database
DS_WriteLog "I" "Create the monitoring database" $LogFile
try {
    New-XDDatabase -AdminAddress $ComputerName -SiteName $SiteName -DataStore Monitor -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName_Monitoring -ErrorAction Stop | Out-Null
    DS_WriteLog "S" "The monitoring database '$DatabaseName_Monitoring' was created successfully" $LogFile
} catch {
    [string]$ErrorText = $Error[0]
    If ( $ErrorText.Contains("already exists")) {
        DS_WriteLog "I" "The monitoring database '$DatabaseName_Monitoring' already exists. Nothing to do." $LogFile
    } else {
        DS_WriteLog "E" "An error occurred trying to create the monitoring database '$DatabaseName_Monitoring' (error: $($Error[0]))" $LogFile
        Exit 1
    }
}

DS_WriteLog "-" "" $LogFile


# CREATE XENDESKTOP SITE
# ------------------------------

DS_WriteLog "-" "" $LogFile

# Create a new site
# -----------
DS_WriteLog "I" "Create the XenDesktop site '$SiteName'" $LogFile
try {
    New-XDSite -DatabaseServer $DatabaseServer -LoggingDatabaseName $DatabaseName_Logging -MonitorDatabaseName $DatabaseName_Monitoring -SiteDatabaseName $DatabaseName_Site -SiteName $SiteName -AdminAddress $ComputerName -ErrorAction Stop  | Out-Null
    DS_WriteLog "S" "The site '$SiteName' was created successfully" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to create the site '$SiteName' (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# LICENSE SERVER CONFIG
# ---------------------
# Configure license server
DS_WriteLog "I" "Configure licensing" $LogFile
DS_WriteLog "I" "Set the license server" $LogFile
try {
    Set-XDLicensing -AdminAddress $ComputerName -LicenseServerAddress $LicenseServer -LicenseServerPort $LicenseServerPort -Force  | Out-Null
    DS_WriteLog "S" "The license server '$LicenseServer' was configured successfully" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to configure the license server '$LicenseServer' (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# Configure the licensing model, product and edition
DS_WriteLog "I" "Configure the licensing model, product and edition" $LogFile
try {  
    Set-ConfigSite  -AdminAddress $ComputerName -LicensingModel $LicensingModel -ProductCode $ProductCode -ProductEdition $ProductEdition | Out-Null
    DS_WriteLog "I" "The licensing model, product and edition have been configured correctly" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to configure the licensing model, product and edition (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# CREATE ADMINISTRATORS
# ---------------------
# Create a full admin group "CTXAdmins"
DS_WriteLog "I" "Create the Citrix administrator $AdminGroup" $LogFile
try {
    Get-AdminAdministrator $AdminGroup | Out-Null
    DS_WriteLog "I" "The Citrix administrator $AdminGroup already exists. Nothing to do." $LogFile
} catch { 
    try {
        New-AdminAdministrator -AdminAddress $ComputerName -Name $AdminGroup | Out-Null
        DS_WriteLog "S" "The Citrix administrator $AdminGroup has been created successfully" $LogFile
    } catch {
        DS_WriteLog "E" "An error occurred trying to create the Citrix administrator $AdminGroup (error: $($Error[0]))" $LogFile
        Exit 1
    }
}

# Assign full admin rights to the admin group "CTXAdmins"
DS_WriteLog "I" "Assign full admin rights to the Citrix administrator $AdminGroup" $LogFile
try {  
    Add-AdminRight -AdminAddress $ComputerName -Administrator $AdminGroup -Role 'Full Administrator' -Scope "All" | Out-Null
    DS_WriteLog "S" "Successfully assigned full admin rights to the Citrix administrator $AdminGroup" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to assign full admin rights to the Citrix administrator $AdminGroup (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# ADDITIONAL SITE CONFIGURATIONS
# ------------------------------
# Configure grooming settings
DS_WriteLog "I" "Configure grooming settings" $LogFile
try {  
    Set-MonitorConfiguration -GroomApplicationInstanceRetentionDays $GroomingDays -GroomDeletedRetentionDays $GroomingDays -GroomFailuresRetentionDays $GroomingDays -GroomLoadIndexesRetentionDays $GroomingDays -GroomMachineHotfixLogRetentionDays $GroomingDays -GroomNotificationLogRetentionDays $GroomingDays -GroomResourceUsageDayDataRetentionDays $GroomingDays -GroomSessionsRetentionDays $GroomingDays -GroomSummariesRetentionDays $GroomingDays | Out-Null
    DS_WriteLog "S" "Successfully changed the grooming settings to $GroomingDays days" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to change the grooming settings to $GroomingDays days (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# Enable the Delivery Controller to trust XML requests sent from StoreFront (https://docs.citrix.com/en-us/receiver/windows/4-7/secure-connections/receiver-windows-configure-passthrough.html)
DS_WriteLog "I" "Enable the Delivery Controller to trust XML requests sent from StoreFront" $LogFile
try {  
    Set-BrokerSite -TrustRequestsSentToTheXmlServicePort $true | Out-Null
    DS_WriteLog "S" "Successfully enabled trusted XML requests" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to enable trusted XML requests (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# Disable connection leasing (enabled by default in a new site)
DS_WriteLog "I" "Disable connection leasing" $LogFile
try {
    Set-BrokerSite -ConnectionLeasingEnabled $false | Out-Null
    DS_WriteLog "S" "Connection leasing was disabled successfully" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to disable connection leasing (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# Enable Local Host Cache (disabled by default in a new site)
DS_WriteLog "I" "Enable Local Host Cache" $LogFile
try {
    Set-BrokerSite -LocalHostCacheEnabled $true | Out-Null
    DS_WriteLog "S" "Local Host Cache was enabled successfully" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to enable Local Host Cache (error: $($Error[0]))" $LogFile
    Exit 1
}

DS_WriteLog "-" "" $LogFile

# Disable the Customer Experience Improvement Program (CEIP)
DS_WriteLog "I" "Disable the Customer Experience Improvement Program (CEIP)" $LogFile
try {
    Set-AnalyticsSite -Enabled $false | Out-Null
    DS_WriteLog "S" "The Customer Experience Improvement Program (CEIP) was disabled successfully" $LogFile
} catch {
    DS_WriteLog "E" "An error occurred trying to disable the Customer Experience Improvement Program (CEIP) (error: $($Error[0]))" $LogFile
    Exit 1
}


# Enable File Security  
Remove-Item env:\SEE_MASK_NOZONECHECKS

DS_WriteLog "-" "" $LogFile
DS_WriteLog "I" "End of script" $LogFile

"complete"  >> c:\logs\sitedone.txt