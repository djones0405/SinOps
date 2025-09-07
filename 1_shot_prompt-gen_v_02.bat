@echo off
setlocal enabledelayedexpansion

:: --------------------------------------------------------------------------
:: Copilot Codeblock Request Helper with Safe Save
::
:: README:
::
:: This Windows batch script helps you create detailed, well-formatted code requests
:: for GitHub Copilot or Copilot Chat, and saves your prompt to a uniquely named file,
:: preventing accidental overwrites.
::
:: HOW TO USE:
:: 1. Place this script in any folder and run it (double-click or from Command Prompt).
:: 2. The script suggests a default filename such as "copilot_request_helper.v_01.bat".
::    - If this file already exists, it automatically increments the version (v_02, v_03, ...).
::    - You can also enter any custom filename.
::    - If you choose an existing filename, you'll be asked for overwrite confirmation.
:: 3. Answer the interactive prompts about your desired code (language, framework, etc.).
:: 4. Your Copilot request will be saved to the chosen file.
:: 5. Open the saved file to copy/paste your prompt into Copilot or share as needed.
::
:: FAQ:
:: Q: How does the script prevent overwrites?
::    A: It creates a new versioned file each time, unless you specify an existing name and confirm overwrite.
:: Q: Can I use a custom filename?
::    A: Yes, just type your preferred name when prompted.
:: Q: Where is my prompt saved?
::    A: In the same folder as this script, using the chosen filename.
:: Q: Can I skip any prompt?
::    A: Yes, just press Enter to leave any answer blank.
:: Q: Does this work on Linux/macOS?
::    A: No, this script is for Windows (batch). For other platforms, use a shell script.
::
:: License: MIT. Adapt and share freely!
:: --------------------------------------------------------------------------

:: Get the base script name (without extension)
set SCRIPTNAME=%~n0

:: Set initial version
set VERSION=01

:find_unique_filename
set OUTFILE=%SCRIPTNAME%.v_%VERSION%.bat
if exist "%OUTFILE%" (
    set /a VERSION+=1
    if %VERSION% lss 10 (
        set VERSION=0%VERSION%
    )
    goto find_unique_filename
)

:: Prompt user to accept the default filename or choose custom
echo Default save filename is: %OUTFILE%
set /p CUSTOMNAME=Press Enter to accept or type a different filename to use/save as: 

if not "%CUSTOMNAME%"=="" (
    set OUTFILE=%CUSTOMNAME%
    if exist "%OUTFILE%" (
        echo WARNING: %OUTFILE% already exists!
        choice /m "Do you want to overwrite it?"
        if errorlevel 2 (
            echo Please choose a different filename.
            goto :eof
        )
    )
)

echo.
echo === Copilot Codeblock Request Helper ===
echo.

:: Gather details for a Copilot code request
set /p LANGUAGE=What programming language (e.g., Python, Node.js)?
set /p FRAMEWORK=Framework (if any, else leave blank)?
set /p VERSIONINFO=Version (if relevant, else leave blank)?
set /p FILETYPE=What file type or output do you need (e.g., docker-compose.yml, main.py, code snippet)?
set /p GOAL=Briefly describe what the code should do:
set /p CONSTRAINTS=Any ports, dependencies, or special requirements?
set /p LEVEL=Minimal example or production-ready? (Enter "minimal" or "production")
set /p COMMENTS=Do you want comments or explanation in the output? (yes/no)
set /p CONTEXT=Are you extending any previous code/context? If yes, describe. (Else leave blank)
set /p EXAMPLES=Any example endpoints, data, or config to include? (Else leave blank)

echo.
echo === YOUR OPTIMIZED COPILOT REQUEST ===
echo.

(
echo Please generate a %LEVEL% %LANGUAGE% %FRAMEWORK% (%VERSIONINFO%) %FILETYPE%.
if not "%GOAL%"=="" echo The code should: %GOAL%.
if not "%CONSTRAINTS%"=="" echo Special requirements: %CONSTRAINTS%.
if /I "%COMMENTS%"=="yes" echo Please include comments or explanations in the output.
if not "%CONTEXT%"=="" echo This should extend or modify previous context: %CONTEXT%.
if not "%EXAMPLES%"=="" echo Include this sample data/config: %EXAMPLES%.
) > "%OUTFILE%"

echo.
echo === Copilot request has been saved to %OUTFILE% ===
echo   (You can open or copy from this file at any time)
pause