
# Create Storagepool - Virtual Disk - Partition - Format
$physicalDisks = Get-PhysicalDisk -CanPool $true
$StoragePool = New-StoragePool -FriendlyName HyperV -StorageSubSystemFriendlyName "Windows Storage*" -PhysicalDisks $physicalDisks
$virtualDisk = New-VirtualDisk -FriendlyName HyperV -StoragePoolFriendlyName $storagepool.FriendlyName -ResiliencySettingName Simple -Size 510GB
Initialize-Disk -FriendlyName $virtualDisk.FriendlyName -PartitionStyle GPT
New-Partition -DiskId $virtualDisk.UniqueId -UseMaximumSize -DriveLetter V
Format-Volume -DriveLetter v -FileSystem ReFS -NewFileSystemLabel 'HyperV-VMs'

# Create Folder
New-Item -Path v:\ -Name VMs -ItemType Directory
New-Item -Path V:\ -Name Tools -ItemType Directory
New-Item -Path C:\ -Name Temp -ItemType Directory

# Install AzCopy
Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile C:\Temp\AzCopy.zip -UseBasicParsing
Expand-Archive C:\Temp\AzCopy.zip C:\Temp\Azcopy -Force
Get-ChildItem C:\Temp\AzCopy\*\azcopy.exe | Move-Item -Destination "V:\Tools\AzCopy.exe"
$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
[System.Environment]::SetEnvironmentVariable("PATH", $userenv + ";V:\Tools\AzCopy", "User")

# Download VM to D:\
$env:AZCOPY_CRED_TYPE = "Anonymous";
V:/tools/azcopy.exe copy "https://distsacoursestaff.blob.core.windows.net/azaadvms/*?sv=2019-02-02&st=2020-05-20T19%3A39%3A02Z&se=2030-05-21T19%3A39%3A00Z&sr=c&sp=rl&sig=xppFWg3Zs9bX1mWhwZUHccEBFcKU7eDrppUTcuZnSMw%3D" "D:\" --% --overwrite=prompt --from-to=BlobLocal --check-md5 "FailIfDifferent"
$env:AZCOPY_CRED_TYPE = "";

# Expand VMs
$vmnames = 'saa2ABS.zip','saa2ADC.zip','saa2DC.zip','saa2FS.zip','saa2SQL.zip','saa2VPN.zip','saa2Web.zip','saa2Win10-2.zip','saa2Win10.zip'
foreach ($vmname in $vmnames)
{
    Expand-Archive -Path D:\$vmname -DestinationPath "V:\VMs"
}

# Import VMs
New-VMSwitch -Name 'Private Switch' -SwitchType Private
New-VMSwitch -Name 'Default Switch' -SwitchType Internal

$vmcxs = Get-ChildItem V:\VMs -Recurse -Filter *.vmcx
foreach ( $vmcx in $vmcxs )
{
    Import-VM -Path $vmcx.fullname
}

# New DHCP Scope
Add-DhcpServerv4Scope -Name ScopeSAA2 -StartRange '10.203.2.100' -EndRange '10.203.2.119' -State Active -SubnetMask '255.255.255.0' -LeaseDuration '0.1:00:00'
Set-DhcpServerv4OptionValue -ScopeId '10.203.2.0' -Router '10.203.2.4'

# Configure NIC
$nic = Get-NetIPInterface | Where-Object { $_.InterfaceAlias -like '*(Default Switch)' -and $_.AddressFamily -eq 'IPV4' }
New-NetIPAddress -InterfaceIndex $nic.ifIndex -IPAddress '10.203.2.4' -AddressFamily IPv4 -PrefixLength 24


