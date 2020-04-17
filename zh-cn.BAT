@echo off
color 57
setlocal EnableExtensions
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
title 树莓派4 windows10arm64安装一键包
echo ******************************************************************************************************************
echo *windows10arm64 for Pi4 一键包，
echo *3B和+可能无法启动，但不一定                                                    
echo *USB无法使用，请把键鼠插入到供电接口，否则无法使用！！！！！！！！！！！！！！       
echo *UEFI BOIS我已经改正，避免IO供电时因电源过低而无法使用！                                          
echo *内存我已经行限制为1G！                                                                                               
echo *感谢使用  
echo ******************************************************************************************************************                                                                                                                   
set /p W=请输入windows分区盘符:
set /p E=请输入UEFI分区盘符：
cd /d %~dp0 
:menu
title 树莓派4 windows10arm64安装一键包
cls
echo -输入S进行17763的win10arm64（Pro）部署
echo -输入H查看帮助
echo -输入E退出

set /p choice=请输入要选择的项目:
if "%choice%"=="S" goto START
if "%choice%"=="E" goto EXIT
if "%choice%"=="s" goto START
if "%choice%"=="e" goto EXIT

if "%choice%"=="H" goto help
if "%choice%"=="h" goto help

:START
cls
echo 准备就绪
title 正在进行wim10arm映像部署......
dism /apply-image /imagefile:windows10arm64.wim /index:1 /applydir:%W%: 
echo 正在建立引导
title 正在进行引导建立
bcdboot "%W%":\Windows /s "%E%": /f UEFI /l en-us
bcdedit /store "%E%":\efi\microsoft\boot\bcd /set {Default} nointegritychecks on
bcdedit /store "%E%":\efi\microsoft\boot\bcd /set {Default} testsigning on
bcdedit /store "%E%":\EFI\Microsoft\Boot\bcd /set {default} truncatememory 0x40000000
echo 正在关闭RECOVERY
title 正在关闭RECOVERY
bcdedit /store "%E%":\efi\microsoft\boot\bcd /set {Default} recoveryenabled off
echo 正在刷写UEFI
title 正在刷写UEFI
XCOPY UEFI\ "%E%":\ /s /f /h
echo 按回车键回到菜单。
pause>nul
goto menu

:EXIT
exit

:help
echo step1 新建分区，128mb，格式化为fat32

echo step2 新建分区，剩余大小，格式化为NTFS

echo step3 下载，，右键以管理员身份运行

echo step4 选择新建的NTFS分区盘符

echo step5 选择新建的FAT32分区盘符

echo step6 输入S经行部署镜像

echo step7 待应用镜像完成之后输入E退出

echo 按回车键回到菜单。
pause>nul
goto menu
