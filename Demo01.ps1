
Set-StrictMode -Version latest


# Verwenden von nicht-initialisierten Variablen
$a = 100
$a + $b

# Verwenden von nicht existierenden Eigenschaften eines Objekts
$myFile = Get-ChildItem C:\Windows\win.ini
$myFile.Lenght

# Referenzieren eines nicht vorhandenen Index im Array
$arr = "Eiles","Sperl","Landtmann"
$arr[3]



