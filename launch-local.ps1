# Launch-Local.ps1
# This script launches the website locally using Python's built-in HTTP server

Write-Host "Starting local web server for RAYLYNN CLEANING SERVICES website..." -ForegroundColor Cyan
Write-Host "-------------------------------------------------------------" -ForegroundColor Cyan

# Check if Python is installed
$pythonInstalled = $false
try {
    $pythonVersion = python --version
    $pythonInstalled = $true
    Write-Host "Python detected: $pythonVersion" -ForegroundColor Green
} catch {
    try {
        $pythonVersion = python3 --version
        $pythonInstalled = $true
        Write-Host "Python3 detected: $pythonVersion" -ForegroundColor Green
    } catch {
        Write-Host "Python is not installed or not in PATH. Please install Python to use this script." -ForegroundColor Red
        exit 1
    }
}

# Get the current directory
$currentDir = Get-Location

# Start the server
Write-Host "Starting server in directory: $currentDir" -ForegroundColor Yellow
Write-Host "Website will be available at: http://localhost:8000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "-------------------------------------------------------------" -ForegroundColor Cyan

# Try to start the server with python or python3
if ($pythonInstalled) {
    try {
        python -m http.server 8000
    } catch {
        try {
            python3 -m http.server 8000
        } catch {
            Write-Host "Failed to start the server. Please check your Python installation." -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "Python is required to run this script." -ForegroundColor Red
    exit 1
}