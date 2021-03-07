
$ErrorActionPreference = 'Stop'

#
# Install PowerShell 7.0
#
try {
    # Invoke-Expression -Command "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting" 
    'Installing PS7 ...' | Out-Host
    $cred = New-Object -TypeName pscredential -ArgumentList 'localadmin', (ConvertTo-SecureString -Force -AsPlainText -String 'securePa$$w0rd')
    Invoke-Command -Scriptblock { Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting" }
}
catch {
    Out-Host -InputObject 'Error PS7 installation'
}

#
# Install Azure CLI
#
try {
    'Installing AzCLI ...' | Out-Host
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile "$env:Temp\AzureCLI.msi" 
    Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\AzureCLI.msi /quiet"
    Remove-Item "$env:temp\AzureCLI.msi" -Force
}
catch {
    Out-Host -InputObject 'Error Az CLI Installation'
}

#
# Install Azure PowerShell Modules
#
try {
    'Installing AzPS Modules ...' | Out-Host
    & 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Install-Module Az -Scope AllUsers -Force } 
}
catch {
    Out-Host -InputObject 'Error PS Module Installation'
}

<# #
# Install VSCode
#

try { 
    'Installing VSCode ...' | Out-Host
    # & 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Save-Script -Path c:\Temp -Name Install-VSCode -Force }
    # & 'C:\Program Files\PowerShell\7\pwsh.exe' -command { C:\Temp\Install-VSCode.ps1 -buildEdition 'Stable-System' -EnableContextMenus -AdditionalExtensions @('ms-vscode.powershell','msazurermtools.azurerm-vscode-tools','ms-vscode.azurecli') *>&1 }
    Save-Script -Path $Env:Temp -Name Install-VSCode -Force 
    & "$env:temp\Install-VSCode.ps1" -buildEdition 'Stable-System' -EnableContextMenus
}
catch {
    Out-Host -InputObject 'Error VSCode installation.'
}
 #>
#
# Install Chrome
#

try {
    'Installing Chrome ...' | Out-Host
    $Installer = "$env:temp\chrome_installer.exe"
    $url = 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe'
    Invoke-WebRequest -Uri $url -OutFile $Installer -UseBasicParsing
    Start-Process -FilePath $Installer -Args '/silent /install' -Wait
    Remove-Item -Path $Installer  
}
catch {
    Out-Host -InputObject 'Error Crome installation'
}

#
# Install Edge
#
try {
    'Installing Edge ...' | Out-Host
    Save-Script -Name Download-MicrosoftEdge -Path $env:Temp
    & "$env:Temp\Download-MicrosoftEdge.ps1" -Folder $env:Temp -Channel Stable
    Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\MicrosoftEdgeEnterpriseX64 /quiet /noRestart"
}
catch {
    Out-Host -InputObject 'Error Edge installation'
}


<# #
# Install Git
#
try {
    'Installing Git ...' | Out-Host
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco install git
}
catch {
    Out-Host -InputObject 'Error Git Installation'
} #>
