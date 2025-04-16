# Simple HTTP Server using PowerShell
# This script creates a simple HTTP server to serve the website files

$Hso = New-Object Net.HttpListener
$Hso.Prefixes.Add("http://localhost:8000/")
$Hso.Start()

Write-Host "Server started at http://localhost:8000/"
Write-Host "Press Ctrl+C to stop the server"

while ($Hso.IsListening) {
    $HC = $Hso.GetContext()
    $HRes = $HC.Response
    
    $FilePath = Join-Path (Get-Location).Path $HC.Request.RawUrl.Replace("/", "\")
    
    if ($HC.Request.RawUrl -eq "/") {
        $FilePath = Join-Path (Get-Location).Path "index.html"
    }
    
    if (Test-Path $FilePath -PathType Leaf) {
        $File = [System.IO.File]::ReadAllBytes($FilePath)
        $HRes.ContentLength64 = $File.Length
        $HRes.OutputStream.Write($File, 0, $File.Length)
    } else {
        $HRes.StatusCode = 404
    }
    
    $HRes.Close()
}

$Hso.Stop()
