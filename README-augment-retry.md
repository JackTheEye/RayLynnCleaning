# Augment Auto-Retry Functionality

This package adds automatic retry functionality to the Augment extension for Cursor/VS Code. When the extension encounters network errors or other failures, it will automatically retry the operation indefinitely until it succeeds, using an exponential backoff strategy.

## Features

- Automatically retries failed network requests (both fetch and XMLHttpRequest) indefinitely
- Uses exponential backoff between retry attempts (1s, 2s, 4s, 8s, 16s, etc.) with a maximum delay of 30 seconds
- Never gives up - keeps retrying until the request succeeds
- Logs retry attempts to the console for debugging
- Works with all Augment extension functionality

## Installation

1. Close Cursor/VS Code if it's currently running
2. Run PowerShell as Administrator
3. Navigate to this directory
4. Run the installation script:

```powershell
.\install-retry-wrapper.ps1
```

5. Restart Cursor/VS Code

## Restoring the Original Extension

If you encounter any issues with the modified extension, you can restore the original version:

1. Close Cursor/VS Code
2. Run PowerShell as Administrator
3. Navigate to this directory
4. Run the restore script:

```powershell
.\restore-original.ps1
```

5. Restart Cursor/VS Code

## How It Works

The wrapper script intercepts all network requests made by the Augment extension and adds retry logic to them. When a request fails, it will automatically retry indefinitely with increasing delays between attempts (using exponential backoff) until the request succeeds.

## Customization

You can modify the retry behavior by editing the `augment-retry-wrapper.js` file:

- `MAX_DELAY`: Maximum delay between retries in milliseconds (default: 30000)
- `getRetryDelay`: Function that calculates the delay between retries in milliseconds

After making changes, run the installation script again to apply them.
