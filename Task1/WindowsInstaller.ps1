# Run this script as Admin to install Miniconda3 to your machine

#Var Dump
$installerPath = ".\Miniconda3-latest-Windows-x86_64.exe"
$miniCondaPath = "$HOME\miniconda3"
$condaExe = "$miniCondaPath\Scripts\conda.exe" #This pathing is necessary for compatibility
$pythonVer = 3.11 #For modularities sake

Write-Host "Please ignore all Powershell Pop-ups" -ForegroundColor Red

#Software Setup
    #VsCode
If (Get-Command "code" -ErrorAction SilentlyContinue) {
    Write-Host "VSCode is installed." -ForegroundColor Green
} Else {
    Write-Host "VSCode isn't installed." -ForegroundColor Red
    Write-Host "Beginning Installation..." -ForegroundColor Green
    winget install -e --id Microsoft.VisualStudioCode #AI-Genned Line
}
Write-Host "VSCode connection established, proceeding" -ForegroundColor Green

    #Conda
if(-not(Test-Path -path $installerPath)) { #If the installer doesn't exist, install it
    Write-Host "Downloading Miniconda installer..." -ForegroundColor Green
    Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -OutFile $installerPath
}
Write-Host "Keeping all default configuration options within the MiniConda installer" -ForegroundColor Green
if(-not(Test-Path -path $miniCondaPath)) { #If you don't have miniconda, install it
    $installArgs = @('/S', "/D=$miniCondaPath") #AI-Genned Line
    Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -NoNewWindow #NoNewWindow is AI-Genned
}
Write-Host "Do not restart Powershell" -ForegroundColor Red

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
& $condaExe create --prefix ".\.venv" python=$pythonVer --yes
& $condaExe install --prefix ".\.venv" --file "..\packages.txt" --name PackageSet1 --yes

#VSCode Setup
mkdir ".\.vscode"
Copy-Item -Path "..\settings.json" -Destination ".\.vscode" 
code -n "."

#Completion
cd ..
Write-Host "Sucessfully installed conda, generated an environment, and booted VSCode" -ForegroundColor Green
Write-Host "Cleaning up..." -ForegroundColor Green
rm $installerPath
Write-Host "Cleanup complete, Goodbye" -ForegroundColor Red