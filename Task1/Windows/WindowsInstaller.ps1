# Run this script as Admin to install Miniconda3 to your machine

#Var Dump
$installerPath = ".\Miniconda3-latest-Windows-x86_64.exe"
$miniCondaPath = "C:\miniconda3" #Fixed, space-free path - NOT $HOME\miniconda3. conda's own conda.exe launcher shim builds its internal "python.exe ... conda-script.py" call as a raw, unquoted string; if the install path contains a space (e.g. a Windows username like "The Dean"), that shim breaks with "Unable to create process using...". This is a known, longstanding conda/distlib launcher bug, not something fixable from our side of the call - avoiding a space in the install path entirely is the standard workaround #AI genned fix
$condaExe = "$miniCondaPath\Scripts\conda.exe" #This pathing is necessary for compatibility
$pythonVer = "3.11" #For modularities sake
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
mkdir "PackageSet1" -Force #-Force so re-running the script after a failure doesn't hard-error on an already-existing folder #AI genned line
cd ".\PackageSet1"
& $condaExe create --prefix ".\.venv" python=$pythonVer pip --solver=libmamba --yes
if ($LASTEXITCODE -ne 0) { #AI genned check - stop if the environment itself couldn't be created
    Write-Host "Error: failed to create the conda environment" -ForegroundColor Red
    exit 1
}

#Mayavi/VTK - installed from conda-forge as prebuilt binaries, NOT via pip #AI genned block
#pip has to build mayavi==4.8.3 from source on Windows, which runs mayavi's TVTK code generator against
#the installed VTK. Against vtk 9.3.x/9.4.x that generator calls a getter on vtkUniformHyperTreeGrid
#before it's safe to, which segfaults (shows up here as "Windows fatal exception: access violation").
#This is a known upstream bug (enthought/mayavi issues #1324, #1328, #1345), not something specific to
#this machine. conda-forge ships mayavi as an already-built binary, so it never runs that step.
Write-Host "Installing mayavi/vtk via conda-forge (avoids a known pip build crash on Windows)..." -ForegroundColor Green
& $condaExe install --prefix ".\.venv" -c conda-forge mayavi vtk --solver=libmamba --yes
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: failed to install mayavi/vtk via conda-forge" -ForegroundColor Red
    exit 1
}

#Remaining packages via pip - mayavi/vtk lines are stripped out first so pip doesn't try to rebuild
#them from source and overwrite the working conda-forge install above #AI genned line
Get-Content "..\packages.txt" | Where-Object { $_ -notmatch '^(mayavi|vtk)==' } | Set-Content ".\packages_filtered.txt"
& ".\.venv\python.exe" -m pip install -r ".\packages_filtered.txt" #Switched from `conda install --file` to pip - packages.txt is pip-format (==) and conda's solver was choking trying to SAT-solve 200+ pinned packages against the defaults channel, spiking CPU/RAM and crashing with "bad variant access" #--name removed, conda rejects --prefix and --name used together
if ($LASTEXITCODE -ne 0) { #AI genned check - stop if the packages failed to install
    Write-Host "Error: failed to install packages into the conda environment" -ForegroundColor Red
    exit 1
}
Remove-Item ".\packages_filtered.txt" #AI genned line - tidy up the temp file

#VSCode Setup
mkdir ".\.vscode" -Force #AI genned line - same re-run safety as above
Copy-Item -Path "..\settings.json" -Destination ".\.vscode" 
code -n "."

#Completion
cd ..
Write-Host "Sucessfully installed conda, generated an environment, and booted VSCode" -ForegroundColor Green
Write-Host "Cleaning up..." -ForegroundColor Green
rm $installerPath
rm ".\VSCodeUserSetup.exe"

Write-Host "Cleanup complete" -ForegroundColor Red
