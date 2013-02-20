[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null

function AttachDatabase($serverName, $databaseDirectory, $databaseName) {
    $databaseDirectoryPath = Resolve-Path $databaseDirectory
    $mdfPath = "$databaseDirectoryPath\$databaseName.mdf"
    $ldfPath = "$databaseDirectoryPath\$databaseName.ldf"

    $server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $serverName
    
	$stringCollection = New-Object System.Collections.Specialized.StringCollection
	$stringCollection.Add($mdfPath) | Out-Null
	$stringCollection.Add($ldfPath) | Out-Null

	$server.AttachDatabase($databaseName, $stringCollection)
}

function CopyDatabaseFiles($fromDirectoryPath, $fromDatabaseName, $toDirectoryPath, $toDatabaseName) {
    Copy-Item "$fromDirectoryPath\$fromDatabaseName.mdf" "$toDirectoryPath\$toDatabaseName.mdf" -ErrorAction Stop
    Copy-Item "$fromDirectoryPath\$fromDatabaseName.ldf" "$toDirectoryPath\$toDatabaseName.ldf" -ErrorAction Stop
}

function DetachDatabase($serverName, $databaseName) {
    $server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $serverName

    if ($server.databases[$databaseName] -eq $NULL) {
        return
    }

    ExecuteSql $serverName "master" "ALTER DATABASE [$databaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
    ExecuteSql $serverName "master" "EXEC sp_detach_db @dbname = [$databaseName];"
}

function ExecuteSql($serverName, $databaseName, $sql) {
    sqlcmd -S $serverName -d $databaseName -Q $sql
}

function ExecutrSqlScript($serverName, $databaseName, $sqlScriptPath) {
    sqlcmd -S $serverName -d $databaseName -i $sqlScriptPath
}

Export-ModuleMember -function AttachDatabase
Export-ModuleMember -function CopyDatabaseFiles
Export-ModuleMember -function DetachDatabase
Export-ModuleMember -function ExecutrSql
Export-ModuleMember -function ExecutrSqlScript