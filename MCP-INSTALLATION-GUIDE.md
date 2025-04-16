# Browser Tools MCP Installation Guide

This guide will help you install and set up the Browser Tools MCP (Mission Control Panel) for use with AI-powered applications.

## Components Installed

1. **browser-tools-mcp**: The MCP server that provides standardized tools for AI clients
2. **browser-tools-server**: An intermediary server that facilitates communication between the Chrome extension and the MCP server
3. **Chrome Extension**: A browser extension that captures screenshots, console logs, network activity, and DOM elements

## Installation Steps

### 1. Install browser-tools-server

Open a terminal and run:

```bash
npx @agentdeskai/browser-tools-server@latest
```

This will start the server on port 3025 by default.

### 2. Install browser-tools-mcp

Open another terminal and run:

```bash
npx @agentdeskai/browser-tools-mcp@latest
```

This will connect to the browser-tools-server.

### 3. Install Chrome Extension

1. The Chrome extension has been downloaded and extracted to:
   `C:\Users\John\Documents\augment-projects\MCPInstaller\BrowserTools-Extension\chrome-extension`

2. To install it in Chrome:
   - Open Chrome
   - Go to `chrome://extensions/`
   - Enable "Developer mode" by toggling the switch in the top-right corner
   - Click "Load unpacked"
   - Navigate to the extracted extension folder
   - Click "Select Folder"

3. After installing the extension:
   - Open Chrome DevTools (F12 or right-click and select "Inspect")
   - Look for the "BrowserToolsMCP" panel in the DevTools

## Usage

Once all components are installed and running:

1. The MCP server will be available to any compatible MCP client
2. You can use the Chrome extension to capture browser data
3. The browser-tools-server will facilitate communication between the extension and the MCP server

## Troubleshooting

If you encounter any issues:

1. Make sure both servers are running
2. Check that the Chrome extension is properly installed
3. Restart Chrome if necessary
4. Ensure the browser-tools-server is running on port 3025

## Additional Resources

For more information, visit the [Browser Tools MCP GitHub repository](https://github.com/AgentDeskAI/browser-tools-mcp).
