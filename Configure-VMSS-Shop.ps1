
$htmlDoc = @"
<!DOCTYPE html>
<title>Demo Traffic Managment</title>
<body>
<br />
<h1 style="color:LimeGreen;text-align:center;">VMSS - SHOP</h1>
<p style="text-align:center";>This is instance $($env:computername).</p>
</body>
"@

if ( (Get-Windowsfeature -Name 'Web-Server' ).InstallState -ne 'Installed' ) 
{
    Install-Windowsfeature -Name 'Web-Server'
}

Set-Location c:\inetpub\wwwroot
Remove-Item *.* -Force
Set-Content -Value $htmlDoc -Path .\index.html
