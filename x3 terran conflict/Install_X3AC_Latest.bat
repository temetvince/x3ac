@echo off
echo Installing X3AC - This REQUIRES Litcube's Universe!

:: Check if the necessary file exists
if not exist "addon\scripts\Menu.DWM.xml" (
    cls
    echo Error: LU not detected! Alaankwa must be installed on an existing Litcube's Universe codebase.
    echo If you know for sure LU is installed, then please ensure that you are running this script from inside the 'x3 terran conflict' folder.
    pause
    exit /b 1
)

setlocal

:: Define the URL and the destination file
set "url=https://github.com/temetvince/x3ac/archive/refs/heads/main.zip"
set "zipfile=%TEMP%\x3ac.zip"

:: Check for internet connection
cls
echo Checking for an active internet connection...
ping -n 1 github.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: No internet connection.
    pause
    exit /b 1
)

:: Download the file using PowerShell
cls
echo Downloading X3AC from %url%...
PowerShell -Command "try { Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%' -ErrorAction Stop } catch { exit 1 }"
if %errorlevel% neq 0 (
    echo Error: Download failed. Please check your internet connection and the URL.
    pause
    exit /b 1
)

:: Define the destination folder
set "destination=%TEMP%\x3ac"

:: Unzip the file using PowerShell
cls
echo Unzipping the downloaded file...
PowerShell -Command "try { Expand-Archive -Path '%zipfile%' -DestinationPath '%destination%' -Force -ErrorAction Stop } catch { exit 1 }"
if %errorlevel% neq 0 (
    echo Error: Unzipping failed. The downloaded file might be corrupted.
    pause
    exit /b 1
)

:: Copy the files to the current directory, excluding specific files and folders
cls
echo Copying files to the installation directory, excluding .gitattributes, .gitignore, and .git...
robocopy "%destination%\x3ac-main\x3 terran conflict" . /E /XD .git /XF .gitattributes .gitignore README.md
if %errorlevel% GEQ 8 (
    echo Error: File copying failed. Ensure you have the necessary permissions.
    pause
    exit /b 1
)

:: Copy and rename README.md to Readme_X3AC.md in 'x3 terran conflict' folder
cls
echo Copying and renaming README.md to Readme_X3AC.md...
copy "%destination%\x3ac-main\README.md" ".\Readme_X3AC.md"
if %errorlevel% neq 0 (
    echo Error: Copying and renaming README.md failed.
    pause
    exit /b 1
)

:: Clean up
cls
echo Cleaning up temporary files...
del /Q "%zipfile%"
rmdir /S /Q "%destination%"

endlocal

cls
echo Installation complete. You have the latest version of X3AC!
pause
