function Get-Fun
{
  <#
    .SYNOPSIS
    Short Description
    .DESCRIPTION
    Detailed Description
    .EXAMPLE
    Get-Fun
    explains how to use the command
    can be multiple lines
    .EXAMPLE
    Get-Fun
    another example
    can have as many examples as you like
  #>
  $fun = Get-Random -Minimum 1 -Maximum 11
  
  
  if ($fun -gt 5 )
  {
    for ( $i = 0; $i -le 3; $i++)
    {
      $i
    }
  }
  else
  {
    do
    {
      $Eingabe = Read-Host "Bitte einen Text eingeben"
    } while ($Eingabe -ne "aus")
  }
  
  "FINISHED"
}

