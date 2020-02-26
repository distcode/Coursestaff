Configuration saa2BaseVMConfig
{
    param ($VMName)

    node $VMName
    {
        WindowsFeature DHCPSrv {
            Ensure = 'Present'
            Name   = 'DHCP'
        }

        WindowsFeature RSATDHCP {
            Ensure = 'Present'
            Name   = 'RSAT-DHCP'
        }

        WindowsFeature RSATHyperV {
            Ensure               = 'Present'
            Name                 = 'RSAT-Hyper-V-Tools'
            IncludeAllSubFeature = $true
        }
    }
}