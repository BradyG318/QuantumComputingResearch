# This installer will load all necessary Python and VSCode dependencies for Task _X_

## Steps
### Step 1
#### Powershell Scripts Pre-enabled
If you've previously used a Powershell script, and have them enabled system-wide already, simply run the RunMeWindows.ps1 file, and the installation process will begin.

#### Powershell Scripts disabled
If you have Powershell scripts disabled, you can either:
A. Enable them by searching for Powershell in the taskbar, selecting "Run as Administrator", and inputting this command: *Set-ExecutionPolicy RemoteSigned*

B. Simply running the *RunMeScriptless.bat* file included in this package

Changing the execution policy is preferred, as it will make future assignments simpler to initialize, but if for whatever reason you feel uncomfortable doing this, RunMeScriptless will work just fine. 

### Step 2
Allow the installer to work, the script will run through all necessary components for the task, verify their installation, and install anything that's missing. If at any point Powershell asks for permission to run something, allow it, but on most machines this will be unnecessary

### Step 3
Begin the assignment, VSCode will boot automatically at the end, as well as any time the script is run with the environment preloaded. 