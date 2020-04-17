@echo off
color 57
setlocal EnableExtensions
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
title windows on raspberrypi4
echo ******************************************************************************************************************
echo *windows10arm64 for Pi4 
echo *Note: 3B£¨3B+£© may not be available, but it may also start
echo ******************************************************************************************************************                                                                                                                   
set /p W=Please select the "windows" disc character£º
set /p E=Please select the "Boot" disc character£º
cd /d %~dp0 
:menu
title windows on rpi4
cls
echo -S to adding image
echo -H to help
echo -E to exit

set /p choice=Please enter the item you want to select:
if "%choice%"=="S" goto START
if "%choice%"=="E" goto EXIT
if "%choice%"=="s" goto START
if "%choice%"=="e" goto EXIT
if "%choice%"=="H" goto help
if "%choice%"=="h" goto help

:START
cls
title In progress wim10arm image deployment...
dism /apply-image /imagefile:windows10arm64.wim /index:1 /applydir:%W%: 
title Boot ingress in progress
bcdboot "%W%":\Windows /s "%E%": /f UEFI /l en-us
bcdedit /store "%E%":\efi\microsoft\boot\bcd /set {Default} nointegritychecks on
bcdedit /store "%E%":\efi\microsoft\boot\bcd /set {Default} testsigning on
bcdedit /store "%E%":\EFI\Microsoft\Boot\bcd /set {default} truncatememory 0x40000000
bcdedit /store "%E%":\efi\microsoft\boot\bcd /set {Default} recoveryenabled off
title Brushing UEFI
XCOPY UEFI\ "%E%":\ /s /f /h
echo Press enter key back to menu¡£
pause>nul
goto menu

:EXIT
exit

:help
echo step1 New partition, 128mb, formatted as fat32

echo step2 New partition, remaining size, formatted as NTFS

echo step3 Download, right-click to run as an administrator

echo step4 Select a new NTFS partition disc character

echo step5 Select a new FAT32 partition disc

echo step6 Enter s line deployment mirror

echo step7 Enter E exit after the application image is complete
echo Press enter key back to menu¡£
pause>nul
goto menu