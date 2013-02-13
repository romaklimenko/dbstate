. .\config.ps1

function Iterate-Modules ($FunctionName) {
    $files = Get-ChildItem $ModulesDirectory
    foreach ($file in $files) {
        if ($file.PSIsContainer) {
            $ModulePath = Join-Path -ChildPath \Module.psm1 -Path $file.FullName
            if (-Not (Test-Path $ModulePath)) {
                Continue
            }
            $CustomObject = Import-Module $ModulePath -AsCustomObject -Force
            $Expression = "$" + "CustomObject." + $FunctionName + "()"
            Invoke-Expression $Expression

        }
    }
}

function Run-Modules() {
    Iterate-Modules "Run"
}

function Test-Modules() {
    Iterate-Modules "Test"
}

Run-Modules
Test-Modules