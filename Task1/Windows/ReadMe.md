# This installer will load all necessary Python and VSCode dependencies for Task _X_

## Steps
### Step 1
#### Powershell Scripts Pre-enabled
If you've previously used a Powershell script, and have them enabled system-wide already, simply right click and run the RunMeWindows.ps1 file, and the installation process will begin.

#### Powershell Scripts disabled
If you have Powershell scripts disabled, you can either:

A. Enable them by searching for Powershell in the taskbar, selecting "Run as Administrator", and inputting this command: *Set-ExecutionPolicy RemoteSigned* then hit enter. After that, type (A) for "Yes to All"
Once this change is made, revert to "Powershell Scripts Pre-enabled"

B. Simply running the *RunMeScriptless.bat* file included in this package

Changing the execution policy is preferred, as it will make future assignments simpler to initialize, but if for whatever reason you feel uncomfortable doing this, RunMeScriptless will work just fine. 

### Step 2
Allow the installer to work, the script will run through all necessary components for the task, verify their installation, and install anything that's missing. If at any point Powershell asks for permission to run something, allow it, but on most machines this will be unnecessary

### Step 3
Once the installer finishes, you will immediately boot into VSCode, click through the initial installation steps to set your preferences (color profile, optional account integration, etc).
#### Note: VSCode may request for you to install the Python extension, this is unnecessary, as the extension has already been automatically installed. This can be verified by running the cmdlet *code --list-extensions*

### Step 4
Begin the assignment, VSCode will boot automatically at the end, as well as any time the script is run with the environment preloaded. 