
try
{
    
    $AnzahlMitglieder = Read-Host "Wie viele Mitglieder gibt es"
    $Gewinn = Get-Random -Minimum 1000 -Maximum 100000
    
    $Anteil = $Gewinn / $AnzahlMitglieder
    "Die $AnzahlMitglieder Mitglieder haben je € $Anteil gewonnen."
}
catch
{
    Write-Host 'Other exception'
}
finally # Wird auch ausgeführt, wenn Crtl+C gedrückt wird.
{
  Write-Host 'cleaning up ...'
}
