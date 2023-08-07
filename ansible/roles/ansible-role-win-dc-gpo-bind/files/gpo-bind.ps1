function link-gpos {

    [Parameter(Mandatory=$true)][String]$GPOs
    [Parameter(Mandatory=$true)][String]$target
    
    $GPOs | ForEach-Object {
        New-GPLink -Name $_ -Domain dt.democloud -Target $target -LinkEnabled Yes
    }
}

$target = "OU=Objects,DC=dt,DC=democloud"
$GPOs = "GPO_C_IPv6","GPO_C_PowerSettings","GPO_U_Optics_Wallpaper","GPO_U_Optics_User"
link-gpos -target $target -GPOs $GPOs

$target = "OU=Computer,OU=Objects,DC=dt,DC=democloud"
$GPOs = "GPO_C_DisableServerManagerOnStartup","GPO_C_LoopbackProcessing","GPO_C_NewsAndInterests","GPO_C_deviceTRUST_Geolocation_Google","GPO_C_RegionSettings","GPO_C_deviceTRUST_Basic","GPO_C_deviceTRUST_Demo_Demobox"
link-gpos -target $target -GPOs $GPOs