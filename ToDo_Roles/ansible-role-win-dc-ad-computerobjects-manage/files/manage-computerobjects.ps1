function move-computer {

    [Parameter(Mandatory=$true)][String]$ComputerObject
    [Parameter(Mandatory=$true)][String]$TargetOU
    
    $ComputerObjectDN = (Get-ADComputer $ComputerObject).DistinguishedName
    Move-ADObject -Identity $ComputerObjectDN -TargetPath $TargetOU

}

$ComputerObject = "citrix-ctrl-01"
$TargetOU = "OU=Citrix,OU=03_Environment,OU=Computer,OU=Objects,DC=democloud,DC=local"
Move-computer -ComputerObject $ComputerObject -TargetOU $TargetOU

$ComputerObject = "citrix-rdsh-01"
$TargetOU = "OU=RDSH,OU=Citrix,OU=03_Environment,OU=Computer,OU=Objects,DC=democloud,DC=local"
Move-computer -ComputerObject $ComputerObject -TargetOU $TargetOU

$ComputerObject = "vmware-ctrl-01"
$TargetOU = "OU=RDSH,OU=VMware,OU=03_Environment,OU=Computer,OU=Objects,DC=democloud,DC=local"
#Move-computer -ComputerObject $ComputerObject -TargetOU $TargetOU

$ComputerObject = "vmware-rdsh-01"
$TargetOU = "OU=RDSH,OU=VMware,OU=03_Environment,OU=Computer,OU=Objects,DC=democloud,DC=local"
#Move-computer -ComputerObject $ComputerObject -TargetOU $TargetOU