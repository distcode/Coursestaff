Configuration OnPremSimBaseConfig
{
    param ($VMName)

    node $VMName
    {
        WindowsFeature Hypv {
            Ensure = 'Present'
            Name = 'Hyper-V'
        }
        
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

        WindowsFeature Routing {
            Ensure = 'Present'
            Name   = 'Routing'
        }

        WindowsFeature RoutingRSAT {
            Ensure = 'Present'
            Name   = 'RSAT-RemoteAccess-Mgmt'
        }
    }
}