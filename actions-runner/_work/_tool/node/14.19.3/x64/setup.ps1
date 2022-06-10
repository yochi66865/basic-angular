$ErrorActionPreference = "Stop"

[Version]$Version = "14.19.3"
[string]$Architecture = "x64"

$ToolcacheRoot = $env:AGENT_TOOLSDIRECTORY
if ([string]::IsNullOrEmpty($ToolcacheRoot)) {
    # GitHub images don't have `AGENT_TOOLSDIRECTORY` variable
    $ToolcacheRoot = $env:RUNNER_TOOL_CACHE
}
$NodeToolcachePath = Join-Path -Path $ToolcacheRoot -ChildPath "node"
$NodeToolcacheVersionPath = Join-Path -Path $NodeToolcachePath -ChildPath $Version.ToString()
$NodeToolcacheArchitecturePath = Join-Path $NodeToolcacheVersionPath $Architecture

Write-Host "Check if Node.js hostedtoolcache folder exist..."
if (-not (Test-Path $NodeToolcachePath)) {
    New-Item -ItemType Directory -Path $NodeToolcachePath | Out-Null
}

Write-Host "Delete Node.js $Version if installed"
if (Test-Path $NodeToolcacheVersionPath) {
    Remove-Item $NodeToolcachePath -Recurse -Force | Out-Null
}

Write-Host "Create Node.js $Version folder"
if (-not (Test-Path $NodeToolcacheArchitecturePath)) {
    New-Item -ItemType Directory -Path $NodeToolcacheArchitecturePath | Out-Null
}

Write-Host "Copy Node.js binaries to hostedtoolcache folder"
Copy-Item -Path * -Destination $NodeToolcacheArchitecturePath -Recurse
Remove-Item $NodeToolcacheArchitecturePath\setup.ps1 -Force | Out-Null

Write-Host "Create complete file"
New-Item -ItemType File -Path $NodeToolcacheVersionPath -Name "$Architecture.complete" | Out-Null
