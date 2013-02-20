function Run($serverName, $databaseName) {
    echo "Insert 8 rows in [Automations] table"
    $sqlScriptPath = Resolve-Path ".\Updates\20130218 001 Automations\Automations.sql"
    ExecutrSqlScript $serverName $databaseName $sqlScriptPath
}

function Test() {
    echo "Test 8 rows in [Automations] table"
    $sqlScriptPath = Resolve-Path ".\Updates\20130218 001 Automations\AutomationsTest.sql"
    ExecutrSqlScript $serverName $databaseName $sqlScriptPath
}

Export-ModuleMember -function Run
Export-ModuleMember -function Test