# Start-MCP.ps1
# This script starts both components of the Browser Tools MCP

Write-Host "Starting Browser Tools MCP..." -ForegroundColor Cyan
Write-Host "------------------------------" -ForegroundColor Cyan

# Function to check if a process is running
function Test-ProcessRunning {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )
    
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    return ($null -ne $process)
}

# Create a folder for logs if it doesn't exist
$logFolder = Join-Path $PSScriptRoot "logs"
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
    Write-Host "Created logs folder: $logFolder" -ForegroundColor Gray
}

# Define log file paths
$serverLogPath = Join-Path $logFolder "browser-tools-server.log"
$mcpLogPath = Join-Path $logFolder "browser-tools-mcp.log"

# Start the browser-tools-server in a new PowerShell window
Write-Host "Starting browser-tools-server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npx @agentdeskai/browser-tools-server@latest | Tee-Object -FilePath '$serverLogPath'"

# Wait for the server to start
Write-Host "Waiting for server to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Start the browser-tools-mcp in a new PowerShell window
Write-Host "Starting browser-tools-mcp..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npx @agentdeskai/browser-tools-mcp@latest | Tee-Object -FilePath '$mcpLogPath'"

Write-Host "`nBrowser Tools MCP is now running!" -ForegroundColor Cyan
Write-Host "Server logs: $serverLogPath" -ForegroundColor Gray
Write-Host "MCP logs: $mcpLogPath" -ForegroundColor Gray
Write-Host "`nReminder: Make sure to install the Chrome extension if you haven't already." -ForegroundColor Yellow
Write-Host "Extension location: C:\Users\John\Documents\augment-projects\MCPInstaller\BrowserTools-Extension\chrome-extension" -ForegroundColor Yellow
