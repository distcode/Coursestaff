$funcPS7 = { function Install-distPS7 {
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
    } }
$funcAzCLI = { function Install-distAzCLI {
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
    } }
$funcAzPSModules = { function Install-distAzPSModules {
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
    } }
$funcChrome = { function Install-distChrome {
        #
        # Install Chrome
        #

        try {
            Write-Eventlog -Message 'Installing Chrome ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
            choco install googlechrome  
        }
        catch {
            Out-Host -InputObject 'Error Crome installation'
            Write-Eventlog -Message 'Error Installing Chrome ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
        }
    } }
$funcEdge = { function Install-distEdge {
        #
        # Install Edge
        #
        try {
            Write-Eventlog -Message 'Installing Edge ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
            choco install microsoft-edge
        }
        catch {
            Out-Host -InputObject 'Error Edge installation'
            Write-Eventlog -Message 'Error Installing Edge ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
        }
    } }
$funcVSCode = { function Install-distVSCode {
        #
        # Install VSCode
        #
        try { 
            Write-Eventlog -Message 'Installing VSCode ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
            Save-Script -Path $Env:Temp -Name Install-VSCode -Force 
            & "$env:temp\Install-VSCode.ps1" -buildEdition 'Stable-System' -EnableContextMenus -AdditionalExtensions @('msazurermtools.azurerm-vscode-tools', 'ms-vscode.azurecli') -ErrorAction SilentlyContinue
        }
        catch {
            Out-Host -InputObject 'Error VSCode installation.'
            Write-Eventlog -Message 'Error Installing VSCode ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
        }
    } }
$funcGIT = { function Install-distGIT {
        #
        # Install Git, Sysinternals
        #
        try {
            Write-Eventlog -Message 'Installing Git ...' -Logname PSScript -Source CustomScriptExtension -EventID 7 -EntryType Information
            choco install git -y
            choco install Sysinternals -y
        }
        catch {
            Out-Host -InputObject 'Error Git Installation'
            Write-Eventlog -Message 'Error Installing Git ...' -Logname PSScript -Source CustomScriptExtension -EventID 9 -EntryType Information
        }
    } }

#
# Some preparation
#
$ErrorActionPreference = 'Stop'

if ( -not ((Get-EventLog -List).Log -contains 'PSScript' )) {
    New-EventLog -LogName PSScript -Source CustomScriptExtension
}

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#
# Main
#

Start-Job -ScriptBlock { Install-distPS7 } -InitializationScript $funcPS7
Start-Job -ScriptBlock { Install-distAzCLI } -InitializationScript $funcAzCLI
Start-Job -ScriptBlock { Install-distAzPSModules } -InitializationScript $funcAzPSModules
Start-Job -ScriptBlock { Install-distChrome } -InitializationScript $funcChrome 
Start-Job -ScriptBlock { Install-distEdge } -InitializationScript $funcEdge
Start-Job -ScriptBlock { Install-distVSCode } -InitializationScript $funcVSCode
Start-Job -ScriptBlock { Install-distGIT } -InitializationScript $funcGIT

Get-Job | Wait-Job
