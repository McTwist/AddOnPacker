@echo off
:: Blockland Add-On packer
:: Creates an archive as Add-On for Blockland in Windows
:: Requires 7zip

setlocal

:: Namecheck filename
set NAMECHECK=namecheck.txt

:: Verify 7zip
where 7z >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
	echo %ERRORLEVEL%
	echo "7zip is required and put in PATH"
	goto :end
)

:: Get all paths
shift
if "%0"=="" (
	set SRC_PATHS="."
) else (
	set SRC_PATHS=%*
)

:: Go through all paths
for %%P in (%SRC_PATHS%) do (
	call :create_addon %%P
)

goto :end

:: Create an Add-On from a path
:: %1 - The path to zip down
:create_addon
	set SRC_PATH=%1
	:: Move to location
	set PREV=%cd%
	cd %SRC_PATH%

	:: Handle the name of the Add-On
	if exist %NAMECHECK% (
		set /p NAME=<%NAMECHECK%
	) else (
		for %%* in (.) do set NAME=%%~nx*
	)
	:: Save the name to file
	echo %NAME%> %NAMECHECK%

	:: Prepare archive name
	set ARCHIVE=%NAME%.zip

	:: Remove previous archive
	if exist %ARCHIVE% del %ARCHIVE%

	:: Package everything
	7z a -tzip -r %ARCHIVE% .\* -xr@%~dp0exclude.txt

	:: Move back
	cd %PREV%
goto :eof

:end
