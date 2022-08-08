$prepo=$env:userprofile+"\Repos\Templates"
$pstage=$env:userprofile+"\Repos\Templates\Script\PowerShell"
$plocal=$env:userprofile+"\Scripts"
$ts=Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$pdump_local=$env:userprofile+"\Downloads\Dump\Script\Local\"+$ts
$pdump_repo=$env:userprofile+"\Downloads\Dump\Script\Repo\"+$ts

# System::Path: $Get-EnvPath Machine
# User::Path: $Get-EnvPath User
function Get-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Machine', 'User')]
        [string] $Container
    )

    $containerMapping = @{
        Machine = [EnvironmentVariableTarget]::Machine
        User = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]

    [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';' |
        where { $_ }
}

function Remove-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -contains $Path) {
            $persistedPaths = $persistedPaths | where { $_ -and $_ -ne $Path }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -contains $Path) {
        $envPaths = $envPaths | where { $_ -and $_ -ne $Path }
        $env:Path = $envPaths -join ';'
    }
}

# Add if not existing
# $Add-EnvPath Machine C:\test
function Add-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | where { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | where { $_ }
        $env:Path = $envPaths -join ';'
    }
}

function Add-Local-Script-To-EnvPath{
    & Write-Host "Add local script to env::path..."
    & Add-EnvPath $plocal User
    & Write-Host "Add local script to env::path...done"
}

function Re-Create-Local-Script{
    # Dump
    # Create local script folder if not exist
    New-Item -ItemType Directory -Force -Path $plocal
    # Create dump folder if not exisit
    New-Item -ItemType Directory -Force -Path $pdump_local
    # Move current local script to dump
    & mv $plocal $pdump_local

    # Create local script folder if not exist
    New-Item -ItemType Directory -Force -Path $plocal
}

function Sync-Local-Script-From-Template-Repo{
    & Re-Create-Local-Script

    # Copy scripts from pstage(template repo/script folder)
    & cp $pstage/* $plocal

    # Add local script to env::path
    & Add-Local-Script-To-EnvPath

    # Close and restart
    & powershell

    & Write-Host "Init/Sync local script folder...done"
}

function Re-Create-Template-Repo{
    # Dump
    # Create dump repo folder if not exisit
    New-Item -ItemType Directory -Force -Path $pdump_repo
    # Move current repo script to dump repo folder
    mv $pstage/* $pdump_repo

    # Create local script folder if not exist
    New-Item -ItemType Directory -Force -Path $pstage
}

function Sync-Template-Repo-From-Local-Script{
    & Re-Create-Template-Repo

    # Copy scripts from local to repo
    & cp $plocal/* $pstage

    # CD to repo
    & cd $prepo

    & Write-Host "Sync repo script folder...done"
}

function Run{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('1', '2', '3', '0')]
        [string] $Choice
    )
    if($Choice -eq '1'){
        & Sync-Local-Script-From-Template-Repo
    }
    elseif($Choice -eq '2'){
        & Sync-Template-Repo-From-Local-Script
    }
    elseif($Choice -eq '0'){
        #& Re-Create-Template-Repo
    }
    else{
        & Write-Host "Choice no-op yet."
    }
}

& Write-Host "Select from:"
& Write-Host "  1. Init/Sync local from template repo."
& Write-Host "  2. Sync repo from local script folder."
& Write-Host "  3. ???"
& Write-Host "  0. Test"
& Run
