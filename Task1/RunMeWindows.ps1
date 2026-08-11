#Var Dump (Copied from installation script)
$miniCondaPath = "$HOME\miniconda3"
#Bools
$vsIsInstalled = $false
$condaIsInstalled = $false

#Installation Verification
Write-Host "Verifying Installation.." -ForegroundColor Green
    #VSCode
If (Get-Command "code" -ErrorAction SilentlyContinue) {
    Write-Host "VSCode is installed." -ForegroundColor Green
    $vsIsInstalled = $true
} Else {
    Write-Host "VSCode isn't installed." -ForegroundColor Red
}
Write-Host "VSCode connection established, proceeding" -ForegroundColor Green

    #Conda
if((Test-Path -path $miniCondaPath)) { #If no miniconda, mark bool
    Write-Host "Conda is installed!"
    $condaIsInstalled = $true
} Else {
    Write-Host "Conda isn't installed" -ForegroundColor Red
}

#Run/Install
if($vsIsInstalled -and $condaIsInstalled ) {
    # FEATURE TO ADD: Ability to reset the virtual environment if all pieces are installed correctly
    Write-Host "Booting VSCode..." -ForegroundColor Red
    cd ".\PackageSet1"
    code -n "."
} Else {
    $userResponse = Read-Host -prompt "Error: Installation not completed, begin installation process? y/n"
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