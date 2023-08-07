param 
( 
    [Parameter(Mandatory=$True)][String]$computername,
    [Parameter(Mandatory=$True)][String]$ou
)

import-module *Active*
    
$ComputerObjectDN = (Get-ADComputer $computername).DistinguishedName
Move-ADObject -Identity $ComputerObjectDN -TargetPath $ou