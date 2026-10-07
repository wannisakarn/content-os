@echo off
set "DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=[Environment]::GetFolderPath('Desktop'); $s=(New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $d 'Content OS.lnk')); $s.TargetPath=(Join-Path $env:WINDIR 'System32\wscript.exe'); $s.Arguments='\"'+$env:DIR+'start.vbs\"'; $s.IconLocation=$env:DIR+'app\contentos.ico'; $s.WorkingDirectory=$env:DIR; $s.Description='Content OS - Marketing System'; $s.Save()"
echo.
echo Done! "Content OS" icon is now on your Desktop.
pause
