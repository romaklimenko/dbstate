Param(
    $serverName=".",
    $databaseName="Sitecore.Analytics")

. .\config.ps1

# import modules
Import-Module "$modulesDirectoryPath\Db.psm1" -Force
Import-Module "$modulesDirectoryPath\Utils.psm1" -Force

# if any database with name what we want to use is attached to the server, detach it
DetachDatabase $serverName $databaseName

# remove all files from databases directory
CleanDirectory $databasesDirectoryPath

# copy *.mdf and *.ldf files to .\Databases
CopyDatabaseFiles $resourcesDirectoryPath $databaseName $databasesDirectoryPath $databaseName

# attach databases, use *.mdf and *.ldf files under .\Databases
AttachDatabase $serverName $databasesDirectoryPath $databaseName

function Iterate-Updates ($functionName) {
    $files = Get-ChildItem $updatesDirectoryPath
    foreach ($file in $files) {
        if ($file.PSIsContainer) {
            $modulePath = Join-Path -ChildPath \Update.psm1 -Path $file.FullName
            if (-Not (Test-Path $modulePath)) {
                Continue
            }
            echo "$functionName $file"
            echo "===================="
            $customObject = Import-Module $modulePath -AsCustomObject -Force
            $expression = "`$CustomObject.$functionName(`$serverName, `$databaseName)"
            Invoke-Expression $expression
        }
    }
}

function Run-Updates() {
    Iterate-Updates "Run"
}

function Test-Updates() {
    Iterate-Updates "Test"
}

Run-Updates
Test-Updates