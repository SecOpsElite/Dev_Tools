# Windows 10 Development Tools Installer
# This script automates the installation of common development tools on Windows 10

# Function to check if running as administrator
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Check for admin rights
if (-not (Test-Administrator)) {
    Write-Host "This script requires administrator privileges. Please run as administrator." -ForegroundColor Red
    exit
}

# Create a temporary directory for downloads
$tempDir = "$env:TEMP\dev-tools-installer"
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# Function to download a file
function Download-File {
    param (
        [string]$Url,
        [string]$OutputFile
    )
    
    Write-Host "Downloading $Url..." -ForegroundColor Yellow
    
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutputFile)
        return $true
    }
    catch {
        Write-Host "Failed to download $Url. Error: $_" -ForegroundColor Red
        return $false
    }
}

# Function to add a directory to system PATH
function Add-ToPath {
    param (
        [string]$PathToAdd
    )
    
    if (-not $PathToAdd) {
        return
    }
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    
    if ($currentPath -notlike "*$PathToAdd*") {
        Write-Host "Adding $PathToAdd to system PATH" -ForegroundColor Yellow
        $newPath = "$currentPath;$PathToAdd"
        [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::Machine)
        $env:Path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    }
    else {
        Write-Host "$PathToAdd is already in PATH" -ForegroundColor Green
    }
}

# Function to install a tool using the installer
function Install-Tool {
    param (
        [string]$InstallerPath,
        [string]$Arguments,
        [string]$ToolName
    )
    
    Write-Host "Installing $ToolName..." -ForegroundColor Yellow
    
    try {
        if ($Arguments) {
            Start-Process -FilePath $InstallerPath -ArgumentList $Arguments -Wait
        }
        else {
            Start-Process -FilePath $InstallerPath -Wait
        }
        
        Write-Host "$ToolName installed successfully." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Failed to install $ToolName. Error: $_" -ForegroundColor Red
        return $false
    }
}

# Install XAMPP
function Install-Xampp {
    $xamppUrl = "https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/8.2.4/xampp-windows-x64-8.2.4-0-VS16-installer.exe/download"
    $xamppInstaller = "$tempDir\xampp-installer.exe"
    
    if (Download-File -Url $xamppUrl -OutputFile $xamppInstaller) {
        if (Install-Tool -InstallerPath $xamppInstaller -Arguments "--mode unattended" -ToolName "XAMPP") {
            Add-ToPath -PathToAdd "C:\xampp\php"
            Add-ToPath -PathToAdd "C:\xampp\mysql\bin"
        }
    }
}

# Install Strawberry Perl
function Install-StrawberryPerl {
    $perlUrl = "https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit.msi"
    $perlInstaller = "$tempDir\strawberry-perl.msi"
    
    if (Download-File -Url $perlUrl -OutputFile $perlInstaller) {
        if (Install-Tool -InstallerPath "msiexec.exe" -Arguments "/i `"$perlInstaller`" /qn" -ToolName "Strawberry Perl") {
            Add-ToPath -PathToAdd "C:\Strawberry\perl\bin"
        }
    }
}

# Install Ruby
function Install-Ruby {
    $rubyUrl = "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.2.2-1/rubyinstaller-3.2.2-1-x64.exe"
    $rubyInstaller = "$tempDir\ruby-installer.exe"
    
    if (Download-File -Url $rubyUrl -OutputFile $rubyInstaller) {
        if (Install-Tool -InstallerPath $rubyInstaller -Arguments "/verysilent /dir=C:\Ruby32 /tasks=`"assocfiles,modpath`"" -ToolName "Ruby") {
            Add-ToPath -PathToAdd "C:\Ruby32\bin"
        }
    }
}

# Install Python
function Install-Python {
    $pythonUrl = "https://www.python.org/ftp/python/3.11.3/python-3.11.3-amd64.exe"
    $pythonInstaller = "$tempDir\python-installer.exe"
    
    if (Download-File -Url $pythonUrl -OutputFile $pythonInstaller) {
        if (Install-Tool -InstallerPath $pythonInstaller -Arguments "/quiet InstallAllUsers=1 PrependPath=1" -ToolName "Python") {
            # Python installer already adds to PATH
            Write-Host "Python added to PATH automatically by the installer." -ForegroundColor Green
        }
    }
}

# Install Node.js
function Install-NodeJS {
    $nodeUrl = "https://nodejs.org/dist/v18.16.0/node-v18.16.0-x64.msi"
    $nodeInstaller = "$tempDir\node-installer.msi"
    
    if (Download-File -Url $nodeUrl -OutputFile $nodeInstaller) {
        if (Install-Tool -InstallerPath "msiexec.exe" -Arguments "/i `"$nodeInstaller`" /qn ADDLOCAL=ALL" -ToolName "Node.js") {
            # Node.js installer already adds to PATH
            Write-Host "Node.js added to PATH automatically by the installer." -ForegroundColor Green
        }
    }
}

# Install MSYS2
function Install-MSYS2 {
    $msys2Url = "https://github.com/msys2/msys2-installer/releases/download/2023-05-26/msys2-x86_64-20230526.exe"
    $msys2Installer = "$tempDir\msys2-installer.exe"
    
    if (Download-File -Url $msys2Url -OutputFile $msys2Installer) {
        if (Install-Tool -InstallerPath $msys2Installer -Arguments "install --root C:\msys64 --confirm-command" -ToolName "MSYS2") {
            Add-ToPath -PathToAdd "C:\msys64\usr\bin"
            Add-ToPath -PathToAdd "C:\msys64\mingw64\bin"
        }
    }
}

# Install Go
function Install-Go {
    $goUrl = "https://go.dev/dl/go1.20.4.windows-amd64.msi"
    $goInstaller = "$tempDir\go-installer.msi"
    
    if (Download-File -Url $goUrl -OutputFile $goInstaller) {
        if (Install-Tool -InstallerPath "msiexec.exe" -Arguments "/i `"$goInstaller`" /qn" -ToolName "Go") {
            Add-ToPath -PathToAdd "C:\Go\bin"
            
            # Create Go workspace directory
            $goWorkspace = "$env:USERPROFILE\go"
            if (-not (Test-Path $goWorkspace)) {
                New-Item -ItemType Directory -Path $goWorkspace | Out-Null
                New-Item -ItemType Directory -Path "$goWorkspace\src" | Out-Null
                New-Item -ItemType Directory -Path "$goWorkspace\bin" | Out-Null
                New-Item -ItemType Directory -Path "$goWorkspace\pkg" | Out-Null
            }
            
            # Set GOPATH environment variable
            [Environment]::SetEnvironmentVariable("GOPATH", $goWorkspace, [EnvironmentVariableTarget]::Machine)
            Add-ToPath -PathToAdd "$goWorkspace\bin"
        }
    }
}

# Install Git
function Install-Git {
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/Git-2.40.1-64-bit.exe"
    $gitInstaller = "$tempDir\git-installer.exe"
    
    if (Download-File -Url $gitUrl -OutputFile $gitInstaller) {
        if (Install-Tool -InstallerPath $gitInstaller -Arguments "/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS=`"icons,ext\reg\shellhere,assoc,assoc_sh`"" -ToolName "Git") {
            Add-ToPath -PathToAdd "C:\Program Files\Git\cmd"
        }
    }
}

# Main installation process
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Windows 10 Development Tools Installer" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "This script will install the following tools:" -ForegroundColor White
Write-Host "- XAMPP" -ForegroundColor White
Write-Host "- Strawberry Perl" -ForegroundColor White
Write-Host "- Ruby" -ForegroundColor White
Write-Host "- Python" -ForegroundColor White
Write-Host "- Node.js" -ForegroundColor White
Write-Host "- MSYS2" -ForegroundColor White
Write-Host "- Go" -ForegroundColor White
Write-Host "- Git" -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Cyan

# Prompt for confirmation
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "Installation cancelled." -ForegroundColor Yellow
    exit
}

# Start installation process
Write-Host "Starting installation process..." -ForegroundColor Green

# Install each tool
Install-Xampp
Install-StrawberryPerl
Install-Ruby
Install-Python
Install-NodeJS
Install-MSYS2
Install-Go
Install-Git

# Clean up
Write-Host "Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "You may need to restart your computer for all path settings to take effect." -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

# Wait for user to press a key before exiting
Write-Host "Press any key to exit..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")