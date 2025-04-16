# This script restores the original Augment extension.js file
# It needs to be run with administrator privileges

# Define paths
$extensionPath = "C:\Users\John\.cursor\extensions\augment.vscode-augment-0.404.1\out\extension.js"
$backupPath = "C:\Users\John\.cursor\extensions\augment.vscode-augment-0.404.1\out\extension.js.backup"

# Check if backup exists
if (Test-Path $backupPath) {
    Write-Host "Restoring original extension.js file..."
    Copy-Item -Path $backupPath -Destination $extensionPath -Force
    Write-Host "Original file restored successfully!"
} else {
    Write-Host "Error: Backup file not found at $backupPath"
    Write-Host "Cannot restore the original file."
}
