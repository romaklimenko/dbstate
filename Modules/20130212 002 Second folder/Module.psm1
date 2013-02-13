function Run() {
    return "Run package #1"
}

function Test() {
    return "Test package #1"
}

Export-ModuleMember -function Run
Export-ModuleMember -function Test