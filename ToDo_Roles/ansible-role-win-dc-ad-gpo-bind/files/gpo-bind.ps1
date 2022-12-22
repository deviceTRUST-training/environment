function link-gpos {

    [Parameter(Mandatory=$true)][String]$GPOs
    [Parameter(Mandatory=$true)][String]$target
    
    $GPOs | ForEach-Object {
        New-GPLink -Name $_ -Domain democloud.local -Target $target -LinkEnabled Yes
    }
}

$target = "DC=democloud,DC=local"
$GPOs = "GPO_C_Disable_LLMNR","GPO_C_IPv6","GPO_C_PowerSettings","GPO_U_Optics_Wallpaper"
link-gpos -target $target -GPOs $GPOs

$target = "OU=Computer,OU=Objects,DC=democloud,DC=local"
$GPOs = "GPO_C_DisableServerManagerOnStartup","GPO_C_LoopbackProcessing","GPO_C_NewsAndInterests","GPO_C_RDSH"
link-gpos -target $target -GPOs $GPOs

$target = "OU=Citrix,OU=03_Environment,OU=Computer,OU=Objects,DC=democloud,DC=local"
$GPOs = "GPO_UC_RDSH_Democloud"
link-gpos -target $target -GPOs $GPOs

$target = "OU=VMware,OU=03_Environment,OU=Computer,OU=Objects,DC=democloud,DC=local"
$GPOs = "GPO_UC_RDSH_Democloud"
link-gpos -target $target -GPOs $GPOs