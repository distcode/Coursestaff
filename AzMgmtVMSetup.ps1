#
# Install PowerShell 7.0
#
Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting"

#
# Install Azure CLI
#
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile "$env:Temp\AzureCLI.msi"
Start-Process msiexec.exe -Wait -ArgumentList "/I $env:Temp\AzureCLI.msi /quiet"
Remove-Item C:\Temp\AzureCLI.msi -Force

#
# Install Azure PowerShell Modules
#
& 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Install-Module Az -Force } 

#
# Install VSCode
#
& 'C:\Program Files\PowerShell\7\pwsh.exe' -command { Save-Script -Path c:\Temp -Name Install-VSCode -Force }
& 'C:\Program Files\PowerShell\7\pwsh.exe' -command { C:\Temp\Install-VSCode.ps1 -EnableContextMenus -AdditionalExtensions @('ms-vscode.powershell','msazurermtools.azurerm-vscode-tools','ms-vscode.azurecli') }

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
