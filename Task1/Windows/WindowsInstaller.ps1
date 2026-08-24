# Run this script as Admin to install Miniconda3 to your machine

#Var Dump
$installerPath = ".\Miniconda3-latest-Windows-x86_64.exe"
$miniCondaPath = "$HOME\miniconda3"
$condaExe = "$miniCondaPath\Scripts\conda.exe" #This pathing is necessary for compatibility
$pythonVer = 3.13 #For modularities sake
$downloadUserAgent = "Mozilla/5.0 (compatible; InstallerScript/1.0)" #Some CDNs 403 requests without a browser-like User-Agent #AI genned line

#Preferences
$ProgressPreference = 'SilentlyContinue' #As nice as the progress bar is, it is tanking the download speed, this changes download time from 20 minutes on a low end machine to ~1.5

Write-Host "Please ignore all Powershell Pop-ups" -ForegroundColor Red

#Software Setup
    #VsCode
If (Get-Command "code" -ErrorAction SilentlyContinue) {
    Write-Host "VSCode is installed." -ForegroundColor Green
} Else {
    Write-Host "VSCode isn't installed." -ForegroundColor Red
    Write-Host "Beginning Download..." -ForegroundColor Green
        #Install
    Invoke-WebRequest -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -OutFile ".\VSCodeUserSetup.exe" -UserAgent $downloadUserAgent
    Write-Host "Installer download complete, beginning installation..." -ForegroundColor Green
    $vsProc = Start-Process -FilePath ".\VSCodeUserSetup.exe" -ArgumentList "/SILENT", "/MERGETASKS=!runcode" -Wait -PassThru #PassThru added so the exit code can be checked #AI genned line
    if ($vsProc.ExitCode -ne 0) { #AI genned check - stop if the VSCode installer itself failed
        Write-Host "Error: VSCode installer exited with code $($vsProc.ExitCode)" -ForegroundColor Red
        exit 1
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") #AI genned line
    Write-Host "VSCode is installed." -ForegroundColor Green
}
Write-Host "VSCode connection established, proceeding" -ForegroundColor Green

    #Conda
if(-not(Test-Path -path $installerPath)) { #If the installer doesn't exist, install it
    Write-Host "Downloading Miniconda installer..." -ForegroundColor Green
    Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -OutFile $installerPath -UserAgent $downloadUserAgent
}
Write-Host "Keeping all default configuration options within the MiniConda installer" -ForegroundColor Green
if(-not(Test-Path -path $miniCondaPath)) { #If you don't have miniconda, install it
    $installArgs = @('/S', "/D=$miniCondaPath") #AI-Genned Line
    Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -NoNewWindow #NoNewWindow is AI-Genned
}
Write-Host "Do not restart Powershell" -ForegroundColor Red

#Sanity check - if the Miniconda installer didn't actually succeed (e.g. ran out of disk space), stop here instead of continuing on a broken install #AI genned check
if (-not (Test-Path -path $condaExe)) {
    Write-Host "Error: Miniconda installation failed - $condaExe was not created. Check the installer output above (e.g. disk space) and re-run this script" -ForegroundColor Red
    exit 1
}

#Conda Initialization
Write-Host "Sucessfully setup MiniConda... Initializing to Powershell" -ForegroundColor Green
& $condaExe init powershell
& $condaExe clean --all --force-pkgs-dirs --yes

#VSCode Initialization
Get-Content vsExtensions.txt | ForEach-Object { code --install-extension $_ } #AI-Genned Line

#Accepting TOS
& $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
& $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
& $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2
# conda clean --all --force-pkgs-dirs


#Dir Setup
Write-Host "Miniconda Initialized, Generating subdirectory" -ForegroundColor Green
mkdir "PackageSet1"
cd ".\PackageSet1"
& $condaExe create --prefix ".\.venv" python=$pythonVer --solver=libmamba --yes
if ($LASTEXITCODE -ne 0) { #AI genned check - stop if the environment itself couldn't be created
    Write-Host "Error: failed to create the conda environment" -ForegroundColor Red
    exit 1
}
& $condaExe install --prefix ".\.venv" --file "..\packages.txt" --solver=libmamba --yes #--name removed, conda rejects --prefix and --name used together
if ($LASTEXITCODE -ne 0) { #AI genned check - stop if the packages failed to install
    Write-Host "Error: failed to install packages into the conda environment" -ForegroundColor Red
    exit 1
}

#VSCode Setup
mkdir ".\.vscode"
Copy-Item -Path "..\settings.json" -Destination ".\.vscode" 
code -n "."

#Completion
cd ..
Write-Host "Sucessfully installed conda, generated an environment, and booted VSCode" -ForegroundColor Green
Write-Host "Cleaning up..." -ForegroundColor Green
rm $installerPath
rm ".\VSCodeUserSetup.exe"

Write-Host "Cleanup complete" -ForegroundColor Red
