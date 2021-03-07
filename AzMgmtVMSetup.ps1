

#
# Some preparation
#
$ErrorActionPreference = 'Stop'
if ( -not ((Get-EventLog -List).Log -contains 'PSScript' )) {
    New-EventLog -LogName PSScript -Source CustomScriptExtension
}
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#
# Install PowerShell 7.0
#
try {
    # Invoke-Expression -Command "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting" 
    Write-Eventlog -Message 'Installing PS7 ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    Invoke-Command -Scriptblock { Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting" }
}
catch {
    Out-Host -InputObject 'Error PS7 installation'
    Write-Eventlog -Message 'Error Installing PS7 ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information

}

#
# Install Azure CLI
#
try {
    Write-Eventlog -Message 'Installing AzCLI ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile "$env:Temp\AzureCLI.msi" 
    Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\AzureCLI.msi /quiet"
    Remove-Item "$env:temp\AzureCLI.msi" -Force
}
catch {
    Out-Host -InputObject 'Error Az CLI Installation'
    Write-Eventlog -Message 'Error Installing AzCLI ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
}

#
# Install Azure PowerShell Modules
#
try {
    Write-Eventlog -Message 'Installing AzPS Modules ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    & 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Install-Module Az -Scope AllUsers -Force } 
}
catch {
    Out-Host -InputObject 'Error PS Module Installation'
    Write-Eventlog -Message 'Error Installing AzPS Modules ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
}

#
# Install Chrome
#

try {
    Write-Eventlog -Message 'Installing Chrome ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    $Installer = "$env:temp\chrome_installer.exe"
    $url = 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe'
    Invoke-WebRequest -Uri $url -OutFile $Installer -UseBasicParsing
    Start-Process -FilePath $Installer -Args '/silent /install' -Wait
    Remove-Item -Path $Installer  
}
catch {
    Out-Host -InputObject 'Error Crome installation'
    Write-Eventlog -Message 'Error Installing Chrome ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
}

#
# Install Edge
#
try {
    Write-Eventlog -Message 'Installing Edge ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    Save-Script -Name Download-MicrosoftEdge -Path $env:Temp
    & "$env:Temp\Download-MicrosoftEdge.ps1" -Folder $env:Temp -Channel Stable
    Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\MicrosoftEdgeEnterpriseX64 /quiet /noRestart"
}
catch {
    Out-Host -InputObject 'Error Edge installation'
    Write-Eventlog -Message 'Error Installing Edge ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
}

#
# Install VSCode
#

try { 
    Write-Eventlog -Message 'Installing VSCode ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    Save-Script -Path $Env:Temp -Name Install-VSCode -Force 
    & "$env:temp\Install-VSCode.ps1" -buildEdition 'Stable-System' -EnableContextMenus -AdditionalExtensions @('msazurermtools.azurerm-vscode-tools','ms-vscode.azurecli') -ErrorAction SilentlyContinue
}
catch {
    Out-Host -InputObject 'Error VSCode installation.'
    Write-Eventlog -Message 'Error Installing VSCode ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
}


#
# Install Git, Sysinternals
#
try {
    Write-Eventlog -Message 'Installing Git ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco install git -y
    choco install Sysinternals -y
}
catch {
    Out-Host -InputObject 'Error Git Installation'
    Write-Eventlog -Message 'Error Installing Git ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
}
