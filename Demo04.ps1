
# Role Capability File
New-PSRoleCapabilityFile -Path C:\PSScripts\ADView.psrc -Guid ([guid]::NewGuid()) -Author DIST -CompanyName ETC `
                         -VisibleCmdlets 'ActiveDirectory\Get-*' -ModulesToImport ActiveDirectoy


# Module anlegen
md 'C:\Program Files\WindowsPowerShell\Modules\ADView'
md 'C:\Program Files\WindowsPowerShell\Modules\ADView\RoleCapabilities'

New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\ADView' -Name ADView.psm1 -ItemType File
New-ModuleManifest -Path 'C:\Program Files\WindowsPowerShell\Modules\ADView\ADView.psd1' -Author DIST -CompanyName ETC

Copy-Item C:\PSScripts\ADView.psrc -Destination 'C:\Program Files\WindowsPowerShell\Modules\ADView\RoleCapabilities'


# SessionConfiguration
New-ADGroup -Name ADViewGroup -Path 'cn=Users,dc=adatum,dc=com' -SamAccountName ADViewGroup -GroupCategory Security -GroupScope Global
Add-ADGroupMember -Identity ADViewGroup -Members Adam


New-PSSessionConfigurationFile -Path C:\PSScripts\ADView.pssc -Author DIST -CompanyName ETC `
                               -RoleDefinitions @{ 'ADViewGroup' = @{ 'RoleCapabilities' = 'ADView' } } `
                               -RequiredGroups @{ 'AND' = 'ADViewGroup'}
                              
Test-PSSessionConfigurationFile -Path C:\PSScripts\ADView.pssc -Verbose

Register-PSSessionConfiguration -Path C:\PSScripts\ADView.pssc -Name ADView
