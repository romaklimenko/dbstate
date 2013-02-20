function CleanDirectory($directoryPath) {
    Remove-Item "$directoryPath\*"
}

Export-ModuleMember -function CleanDirectory