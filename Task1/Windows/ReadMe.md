# This installer will load all necessary Python and VSCode dependencies for Task _X_

## Steps
### Step 1
Simply run the *RunMeScriptless.bat* file included in this package


### Step 2
Allow the installer to work, the script will run through all necessary components for the task, verify their installation, and install anything that's missing. If at any point Powershell asks for permission to run something, allow it, but on most machines this will be unnecessary

### Step 3
Once the installer finishes, you will immediately boot into VSCode, click through the initial installation steps to set your preferences (color profile, optional account integration, etc).
#### Note: VSCode may request for you to install the Python extension, this is unnecessary, as the extension has already been automatically installed. This can be verified by running the cmdlet *code --list-extensions*

### Step 4
Begin the assignment, VSCode will boot automatically at the end, as well as any time the script is run with the environment preloaded. VSCode can be rebooted in the future by running the script again, or by simply booting VSCode and opening the generated folder.