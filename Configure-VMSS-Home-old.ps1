
$htmlDoc = @"
<br />
<h1 style="color:Red;text-align:center;">VMSS - HOME</h1>
<p style="text-align:center";>This is instance $($env:computername).</p>
"@

if ( (Get-Windowsfeature -Name 'Web-Server' ).InstallState -ne 'Installed' ) 
{
    Install-Windowsfeature -Name 'Web-Server'
}

Set-Location c:\inetpub\wwwroot
Remove-Item *.* -Force
Set-Content -Value $htmlDoc -Path .\index.html
