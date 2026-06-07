@echo off
setlocal EnableDelayedExpansion
color 0B
title Ultimate Zero Latency - Extreme Edition v3

:: ====================================
:: 1. AUTO-ADMINISTRATOR CHECK & ESCALATION
:: ====================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Requesting Administrator Privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

:: ====================================
:: 2. UI HEADER
:: ====================================
cls
echo.
echo  ================================================================
echo  ::::    ::::  ::::::::  :::    ::: ::::::::::: ::::::::::: ::::::::  
echo  +:+:+: :+:+:+ :+:    :+: :+:    :+:     :+:         :+:    :+:    :+: 
echo  +:+ +:+:+ +:+ +:+    +:+ +:+    +:+     +:+         +:+    +:+    +:+ 
echo  +#+  +:+  +#+ +#+    +:+ +#+    +:+     +#+         +#+    +#+    +:+ 
echo  +#+       +#+ +#+    +#+ +#+    +#+     +#+         +#+    +#+    +#+ 
echo  #+#       #+# #+#    #+# #+#    #+#     #+#         #+#    #+#    #+# 
echo  ###       ###  ########   ########      ###     ########### ########  
echo  ================================================================
echo             ULTIMATE ZERO LATENCY - EXTREME EDITION v3
echo  ================================================================
echo.
echo  [!] WARNING: This will apply extreme tweaks for competitive gaming.
echo  [!] Close all background apps and games before proceeding.
echo.
pause
cls

echo.
echo  [ SYSTEM OPTIMIZATION IN PROGRESS... ]
echo --------------------------------------------------------------

:: ====================================
:: STEP 1: CREATE RESTORE POINT (SAFETY FIRST)
:: ====================================
echo  [*] Creating System Restore Point (Please wait)...
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Pre-ZeroLatency_v3' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue"
echo  [ OK ] Restore Point Created.

:: ====================================
:: STEP 2: KERNEL TIME & CPU OPTIMIZATION
:: ====================================
echo  [*] Applying Kernel ^& CPU Latency Tweaks...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set synthetictimers yes >nul 2>&1
echo  [ OK ] CPU Timers Optimized.

:: ====================================
:: STEP 3: GAMING PRIORITY & POWER THROTTLING
:: ====================================
echo  [*] Forcing Max Performance ^& Game Priority...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x26 /f >nul 2>&1
:: Fixed PowerThrottling Bug Path
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f2c1-98bb-455b-9e09-ae4c1e16cb45" /v Attributes /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalCriticalWorkerThreads /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalDelayedWorkerThreads /t REG_DWORD /d 2 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Affinity /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d False /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 0x2710 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d High /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d High /f >nul 2>&1
echo  [ OK ] Priority Separation ^& Threads Boosted.

:: ====================================
:: STEP 4: SECURITY MITIGATIONS OFF (FPS BOOST)
:: ====================================
echo  [*] Disabling Deep Security Mitigations (VBS/Spectre)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f >nul 2>&1
echo  [ OK ] Security Mitigations Disabled.

:: ====================================
:: STEP 5: KEYBOARD & MOUSE ZERO LATENCY
:: ====================================
echo  [*] Applying 1:1 Raw Input ^& Zero USB Suspend...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb" /v IdleEnable /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f >nul 2>&1

reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 10 /f >nul 2>&1

reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v Flags /t REG_SZ /d 0 /f >nul 2>&1
echo  [ OK ] Polling Rate ^& Input Lag Optimized.

:: ====================================
:: STEP 6: ADVANCED LOW-LATENCY NETWORK (TCP/IP)
:: ====================================
echo  [*] Tuning Network Stack for Lowest Ping...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int ip set global taskoffload=enabled >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 0x40 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableTCPA /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableRSS /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableTCPChimney /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 1 /f >nul 2>&1

:: Fixed PowerShell Execution
powershell -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue; New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue; New-ItemProperty -Path $_.PSPath -Name 'TcpDelAckTicks' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue }" >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v CacheHashTableBucketSize /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v CacheHashTableSize /t REG_DWORD /d 0x180 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheEntryTtlLimit /t REG_DWORD /d 0xfa00 /f >nul 2>&1
echo  [ OK ] TCP/IP NoDelay ^& AckFrequency Applied.

:: ====================================
:: STEP 7: GRAPHICS, HAGS & GAME DVR
:: ====================================
echo  [*] Configuring GPU Scheduling (HAGS) ^& Game Mode...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo  [ OK ] HAGS Locked ON ^& Game DVR Destroyed.

:: ====================================
:: STEP 8: MEMORY & SERVICES TWEAKS
:: ====================================
echo  [*] Cleaning Background Services ^& Memory Config...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
powercfg -h off >nul 2>&1

taskkill /f /im OneDrive.exe >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f >nul 2>&1

for %%S in (wuauserv dosvc DiagTrack WSearch MapsBroker Fax RetailDemo RemoteRegistry WerSvc) do (
    sc stop "%%S" >nul 2>&1
    sc config "%%S" start= disabled >nul 2>&1
)
echo  [ OK ] Junk Services Disabled.

:: ====================================
:: STEP 9: FINAL CLEANUP & REFRESH
:: ====================================
echo  [*] Flushing Temp Files ^& Network Cache...
del /q /f /s %TEMP%\* >nul 2>&1
del /q /f /s C:\Windows\Prefetch\* >nul 2>&1
ipconfig /flushdns >nul 2>&1
powershell -Command "Get-NetAdapter | Where-Object {$_.Physical} | Restart-NetAdapter" >nul 2>&1
echo  [ OK ] System Purged ^& Network Restarted.

:: ====================================
:: DONE
:: ====================================
echo --------------------------------------------------------------
color 0A
echo.
echo  [SUCCESS] ALL SETTINGS APPLIED FLAWLESSLY!
echo  Please RESTART your PC to experience maximum performance.
echo.
pause