#
# Install PowerShell 7.0
#
# Invoke-Expression -Command "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting" 
$cred = New-Object -TypeName pscredential -ArgumentList 'localadmin', (ConvertTo-SecureString -Force -AsPlainText -String 'securePa$$w0rd')
Invoke-Command -Scriptblock { Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting" } -Credential $cred

#
# Install Azure CLI
#

    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile "$env:Temp\AzureCLI.msi" 
    Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\AzureCLI.msi /quiet"
    Remove-Item "$env:temp\AzureCLI.msi" -Force -Credential $cred


#
# Install Azure PowerShell Modules
#
& 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Install-Module Az -Scope AllUsers -Force } 

#
# Install VSCode
#
# & 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Save-Script -Path c:\Temp -Name Install-VSCode -Force }
# & 'C:\Program Files\PowerShell\7\pwsh.exe' -command { C:\Temp\Install-VSCode.ps1 -buildEdition 'Stable-System' -EnableContextMenus -AdditionalExtensions @('ms-vscode.powershell','msazurermtools.azurerm-vscode-tools','ms-vscode.azurecli') *>&1 }
Save-Script -Path $Env:Temp -Name Install-VSCode -Force 
& "$env:temp\Install-VSCode.ps1" -buildEdition 'Stable-System' -EnableContextMenus

#
# Install Chrome
#
$Installer = "$env:temp\chrome_installer.exe"
$url = 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe'
Invoke-WebRequest -Uri $url -OutFile $Installer -UseBasicParsing
Start-Process -FilePath $Installer -Args '/silent /install' -Wait
Remove-Item -Path $Installer  

#
# Install Edge
#
Save-Script -Name Download-MicrosoftEdge -Path $env:Temp
& "$env:Temp\Download-MicrosoftEdge.ps1" -Folder $env:Temp -Channel Stable
Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\MicrosoftEdgeEnterpriseX64 /quiet /noRestart"
