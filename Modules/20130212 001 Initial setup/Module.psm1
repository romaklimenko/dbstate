function Run() {
    echo "Run package #0"
}

function Test() {
    echo "Test package #0"
}

Export-ModuleMember -function Run
Export-ModuleMember -function Test