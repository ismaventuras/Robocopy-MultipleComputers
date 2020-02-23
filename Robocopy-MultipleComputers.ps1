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

    foreach($computer in $ComputerName){
        #Check if computer is online
        if(Test-Connection $computer -Quiet -Count 1){
            #format remote folder
            $splittedDest = $DestinationFolder.Split("\\")[1]
            $dest = "\\$computer\c$\$splittedDest"
            # Copy to remote computer
            Robocopy.exe $Source $dest /E /R:0 /W:0 /nfl /ndl /njh /njs /ns /nc
            #Manage robocopy execution
            switch ($LASTEXITCODE) {
                0 {write-host "$computer : The source and destination directory trees are completely synchronized"   }
                1 {write-host "$computer : One or more files were copied successfully " }
                2 {write-host "$computer : Some Extra files or directories were detected. No files were copied "}
                4 {write-host "$computer : Some Mismatched files or directories were detected "}
                16 {write-host "$computer :  Serious error. Robocopy did not copy any files.
                Either a usage error or an error due to insufficient access privileges
                on the source or destination directories "}

                Default {}
            }
        }
        else {
            Write-Host "$computer : Offline"
        }
    }

