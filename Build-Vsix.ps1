# Build VSIX package from component folder
# This script compresses all files in the component folder into a VSIX file

# Define paths
$componentFolder = Join-Path $PSScriptRoot "component"
$vsixFolder = Join-Path $PSScriptRoot "vsix"
$zipFile = Join-Path $vsixFolder "MinimalisticView2026.zip"
$vsixFile = Join-Path $vsixFolder "MinimalisticView2026.vsix"

# Check if component folder exists
if (-not (Test-Path $componentFolder)) {
    Write-Error "Component folder not found: $componentFolder"
    exit 1
}

# Create vsix folder if it doesn't exist
if (-not (Test-Path $vsixFolder)) {
    Write-Host "Creating vsix folder..."
    New-Item -Path $vsixFolder -ItemType Directory | Out-Null
}

# Remove existing files if they exist
if (Test-Path $zipFile) {
    Write-Host "Removing existing ZIP file..."
    Remove-Item $zipFile -Force
}

if (Test-Path $vsixFile) {
    Write-Host "Removing existing VSIX file..."
    Remove-Item $vsixFile -Force
}

# Compress component folder contents to ZIP
Write-Host "Compressing component folder to ZIP..."
try {
    # Get all items in the component folder
    $items = Get-ChildItem -Path $componentFolder -Recurse
    
    # Create the ZIP archive
    Compress-Archive -Path (Join-Path $componentFolder "*") -DestinationPath $zipFile -CompressionLevel Optimal
    
    Write-Host "ZIP file created successfully: $zipFile"
} catch {
    Write-Error "Failed to create ZIP file: $_"
    exit 1
}

# Rename ZIP to VSIX
Write-Host "Renaming ZIP to VSIX..."
try {
    Rename-Item -Path $zipFile -NewName "MinimalisticView2026.vsix"
    Write-Host "VSIX file created successfully: $vsixFile"
} catch {
    Write-Error "Failed to rename ZIP to VSIX: $_"
    exit 1
}

Write-Host "Build completed successfully!"
