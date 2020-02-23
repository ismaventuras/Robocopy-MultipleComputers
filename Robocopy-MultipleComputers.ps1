<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>

[CmdletBinding()]
  PARAM (
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [String[]]$ComputerName,
    [Parameter(Mandatory=$True)][ValidateScript({if ($_){  Test-Path $_}})]
    [String]$Source,
    [Parameter(Mandatory=$True)]
    [String]$DestinationFolder
  )

    if(Test-Path $Source){
    foreach($computer in $ComputerName){
        if(Test-Connection $computer -Quiet -Count 1){
            #format remote folder
            $splittedDest = $DestinationFolder.Split("\\")[1]
            $dest = "\\$computer\c$\$splittedDest"

            # Copy to remote computer
            Robocopy.exe $Source $dest /E /R:0 /W:0 /nfl /ndl /njh /njs /ns /nc
            if($LASTEXITCODE -eq 0){
                write-host "$Source copied $computer" 
            }
            else {
                write-host "Copy failed on $computer" 
            }
        }
        else {
            Write-Host "$computer is offline"
        }
    }
    }
    else {
        Write-Host "Source path not found"
    }
