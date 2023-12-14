# Prompt the user to enter the port number or "all"
$portInput = Read-Host "Enter the port number to check (e.g., 53) or 'all' for all ports:"

if ($portInput -eq "all") {
    # Run the netstat command to find all open ports
    $result = netstat -ano
    Write-Host "Processes listening on all ports:"
} elseif ($portInput -match "^\d+$") {
    $portNumber = [int]$portInput
    # Run the netstat command to find the process listening on the specified port
    $result = netstat -ano | Select-String -Pattern ":$portNumber"
    Write-Host ("Processes listening on port " + $portNumber + ":")
} else {
    Write-Host "Invalid input. Please enter a valid numeric port number or 'all'."
    exit
}

if ($result) {
    foreach ($line in $result) {
        $line = $line -split "\s+" | Where-Object { $_ -ne '' }
        $processId = $line[-1]
        $ipAndPort = $line[1]
        
        # Get the process information using the PID
        $process = Get-Process -Id $processId
        
        if ($process) {
            Write-Host ("  IP and Port: " + $ipAndPort + ", PID: " + $processId + ", Name: " + $process.ProcessName)
        } else {
            Write-Host ("  IP and Port: " + $ipAndPort + ", PID: " + $processId + ", Process not found")
        }
    }
} else {
    Write-Host "No processes found."
}
