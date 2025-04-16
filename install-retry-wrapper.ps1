# This script installs the Augment Retry Wrapper by replacing the extension.js file
# It needs to be run with administrator privileges

# Define paths
$extensionPath = "C:\Users\John\.cursor\extensions\augment.vscode-augment-0.404.1\out\extension.js"
$modifiedPath = "C:\Users\John\Documents\augment-projects\MCPInstaller\modified-extension.js"
$backupPath = "C:\Users\John\.cursor\extensions\augment.vscode-augment-0.404.1\out\extension.js.backup"

# Check if backup exists, if not create one
if (-not (Test-Path $backupPath)) {
    Write-Host "Creating backup of original extension.js file..."
    Copy-Item -Path $extensionPath -Destination $backupPath -Force
    Write-Host "Backup created at $backupPath"
}

# Copy the modified file to the extension directory
Write-Host "Installing modified extension.js with retry functionality..."
Copy-Item -Path $modifiedPath -Destination $extensionPath -Force

Write-Host "Installation complete!"
Write-Host "The Augment extension will now automatically retry failed requests."
Write-Host "If you experience any issues, you can restore the original file by running:"
Write-Host "Copy-Item -Path `"$backupPath`" -Destination `"$extensionPath`" -Force"
