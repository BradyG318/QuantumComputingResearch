#Var Dump (Copied from installation script)
$miniCondaPath = "$HOME\miniconda3"
$venvPath = ".\PackageSet1\.venv"
#Bools
$vsIsInstalled = $false
$condaIsInstalled = $false
$venvSetup = $false

#Installation Verification
Write-Host "Verifying Installation.." -ForegroundColor Green
    #VSCode
If (Get-Command "code" -ErrorAction SilentlyContinue) {
    Write-Host "VSCode is installed!" -ForegroundColor Green
    $vsIsInstalled = $true
    Write-Host "VSCode connection established, proceeding" -ForegroundColor Green
} Else {
    Write-Host "VSCode isn't installed" -ForegroundColor Red
}

    #Conda
if((Test-Path -path $miniCondaPath)) { #If miniconda, mark bool
    Write-Host "Conda is installed!" -ForegroundColor Green
    $condaIsInstalled = $true
} Else {
    Write-Host "Conda isn't installed" -ForegroundColor Red
}
    #Virtual Environment
if((Test-Path -path $venvPath)) { #If virtual environment exists
    Write-Host "Virtual Environment is Established!" -ForegroundColor Green
    $venvSetup = $true
}

#Run/Install
if($vsIsInstalled -and $condaIsInstalled -and $venvSetup) {
    # FEATURE TO ADD: Ability to reset the virtual environment if all pieces are installed correctly
    Write-Host "Booting VSCode..." -ForegroundColor Cyan
    cd ".\PackageSet1"
    code -n "."
} Else {
    $userResponse = Read-Host -prompt "Error: Installation not completed, begin installation process? (Expected Installation time ~5mins) y/n"
    if($userResponse -eq "y") {
        Write-Host "Beginning installation Process..." -ForegroundColor Green
        ./WindowsInstaller.ps1
    } elseIf($userResponse -eq "n") {
        Write-Host "Script shutting down" -ForegroundColor Red
    } else {
        Write-Host "Invalid Response" -ForegroundColor Red
    }
}
Write-Host "Goodbye" -ForegroundColor Red