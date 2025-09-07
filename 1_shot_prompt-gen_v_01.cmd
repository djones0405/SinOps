@echo off
setlocal enabledelayedexpansion

:: Gather details for a Copilot code request

echo === Copilot Codeblock Request Helper ===
echo.

:: Ask for environment
set /p LANGUAGE=What programming language (e.g., Python, Node.js)?
set /p FRAMEWORK=Framework (if any, else leave blank)?
set /p VERSION=Version (if relevant, else leave blank)?

:: Ask for output format
set /p FILETYPE=What file type or output do you need (e.g., docker-compose.yml, main.py, code snippet)?

:: Ask for use case/goal
set /p GOAL=Briefly describe what the code should do:

:: Ask for constraints or special requirements
set /p CONSTRAINTS=Any ports, dependencies, or special requirements?

:: Ask for minimal or production-ready
set /p LEVEL=Minimal example or production-ready? (Enter "minimal" or "production")

:: Ask for comments/explanation
set /p COMMENTS=Do you want comments or explanation in the output? (yes/no)

:: Ask for context extension
set /p CONTEXT=Are you extending any previous code/context? If yes, describe. (Else leave blank)

:: Ask for example data or structure
set /p EXAMPLES=Any example endpoints, data, or config to include? (Else leave blank)

echo.
echo === YOUR OPTIMIZED COPILOT REQUEST ===
echo.

(
echo Please generate a %LEVEL% %LANGUAGE% %FRAMEWORK% (%VERSION%) %FILETYPE%.
if not "%GOAL%"=="" echo The code should: %GOAL%.
if not "%CONSTRAINTS%"=="" echo Special requirements: %CONSTRAINTS%.
if /I "%COMMENTS%"=="yes" echo Please include comments or explanations in the output.
if not "%CONTEXT%"=="" echo This should extend or modify previous context: %CONTEXT%.
if not "%EXAMPLES%"=="" echo Include this sample data/config: %EXAMPLES%.
) | tee copilot_request.txt

echo.
echo === Copilot request has been saved to copilot_request.txt ===
echo   (You can open or copy from this file at any time)
pause