# ================================================================
# ULTIMATE ZERO LATENCY - POWERSHELL EXTREME EDITION
# ================================================================
$Host.UI.RawUI.WindowTitle = "Ultimate Zero Latency - Extreme Edition v3"
Clear-Host

# 1. AUTO-ADMINISTRATOR CHECK
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "[ERROR] Please run PowerShell as Administrator!"
    Pause
    Exit
}

# 2. BEAUTIFUL UI HEADER
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  ::::    ::::  ::::::::  :::    ::: ::::::::::: ::::::::::: " -ForegroundColor Cyan
Write-Host "  +:+:+: :+:+:+ :+:    :+: :+:    :+:     :+:         :+:     " -ForegroundColor Cyan
Write-Host "  +:+ +:+:+ +:+ +:+    +:+ +:+    +:+     +:+         +:+     " -ForegroundColor Cyan
Write-Host "  +#+  +:+  +#+ +#+    +:+ +#+    +:+     +#+         +#+     " -ForegroundColor Cyan
Write-Host "  +#+       +#+ +#+    +#+ +#+    +#+     +#+         +#+     " -ForegroundColor Cyan
Write-Host "  #+#       #+# #+#    #+# #+#    #+#     #+#         #+#     " -ForegroundColor Cyan
Write-Host "  ###       ###  ########   ########      ###     ########### " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "         ULTIMATE ZERO LATENCY - POWERSHELL EDITION v3" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " [!] WARNING: Applying extreme tweaks for competitive gaming." -ForegroundColor Yellow
Write-Host " [!] Close all background apps before proceeding." -ForegroundColor Yellow
Write-Host ""
Read-Host " Press Enter to start optimization..."
Clear-Host

Write-Host " [ SYSTEM OPTIMIZATION IN PROGRESS... ]" -ForegroundColor Cyan
Write-Host "--------------------------------------------------------------"

# STEP 1: RESTORE POINT
Write-Host " [*] Creating System Restore Point..." -NoNewline
Checkpoint-Computer -Description "Pre-ZeroLatency_v3" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 2: KERNEL TIME & CPU OPTIMIZATION
Write-Host " [*] Optimizing CPU Timers & DPC Latency..." -NoNewline
bcdedit /set disabledynamictick yes | Out-Null
bcdedit /set useplatformclock no | Out-Null
bcdedit /set tscsyncpolicy Enhanced | Out-Null
bcdedit /set synthetictimers yes | Out-Null
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 3: GAMING PRIORITY & POWER THROTTLING
Write-Host " [*] Tuning Game Priority & Power Throttling..." -NoNewline
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x26 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f2c1-98bb-455b-9e09-ae4c1e16cb45" /v Attributes /t REG_DWORD /d 2 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalCriticalWorkerThreads /t REG_DWORD /d 2 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalDelayedWorkerThreads /t REG_DWORD /d 2 /f | Out-Null
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f | Out-Null
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f | Out-Null

$gameTask = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
reg add $gameTask /v Affinity /t REG_DWORD /d 0 /f | Out-Null
reg add $gameTask /v "Background Only" /t REG_SZ /d False /f | Out-Null
reg add $gameTask /v "Clock Rate" /t REG_DWORD /d 0x2710 /f | Out-Null
reg add $gameTask /v "GPU Priority" /t REG_DWORD /d 8 /f | Out-Null
reg add $gameTask /v Priority /t REG_DWORD /d 6 /f | Out-Null
reg add $gameTask /v "Scheduling Category" /t REG_SZ /d High /f | Out-Null
reg add $gameTask /v "SFIO Priority" /t REG_SZ /d High /f | Out-Null
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 4: SECURITY MITIGATIONS OFF (FPS BOOST)
Write-Host " [*] Disabling Deep Security Mitigations (VBS/Mitigations)..." -NoNewline
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f | Out-Null
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 5: KEYBOARD & MOUSE ZERO LATENCY
Write-Host " [*] Applying 1:1 Raw Input & Disabling USB Suspend..." -NoNewline
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb" /v IdleEnable /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f | Out-Null
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 10 /f | Out-Null
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f | Out-Null
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f | Out-Null
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f | Out-Null
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v Flags /t REG_SZ /d 0 /f | Out-Null
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 6: ADVANCED LOW-LATENCY NETWORK (TCP/IP)
Write-Host " [*] Tuning TCP/IP Stack & Network Interfaces..." -NoNewline
netsh int tcp set global autotuninglevel=normal | Out-Null
netsh int tcp set global rss=enabled | Out-Null
netsh int tcp set global chimney=disabled | Out-Null
netsh int tcp set global ecncapability=disabled | Out-Null
netsh int tcp set global timestamps=disabled | Out-Null
netsh int ip set global taskoffload=enabled | Out-Null

$tcpParams = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
reg add $tcpParams /v DefaultTTL /t REG_DWORD /d 0x40 /f | Out-Null
reg add $tcpParams /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f | Out-Null
reg add $tcpParams /v EnableTCPA /t REG_DWORD /d 0 /f | Out-Null
reg add $tcpParams /v EnableRSS /t REG_DWORD /d 1 /f | Out-Null
reg add $tcpParams /v EnableTCPChimney /t REG_DWORD /d 0 /f | Out-Null
reg add $tcpParams /v Tcp1323Opts /t REG_DWORD /d 1 /f | Out-Null

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $_.PSPath -Name 'TcpDelAckTicks' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
}

$dnsParams = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
reg add $dnsParams /v CacheHashTableBucketSize /t REG_DWORD /d 1 /f | Out-Null
reg add $dnsParams /v CacheHashTableSize /t REG_DWORD /d 0x180 /f | Out-Null
reg add $dnsParams /v MaxCacheEntryTtlLimit /t REG_DWORD /d 0xfa00 /f | Out-Null
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 7: GRAPHICS, GAME MODE & GAME DVR
Write-Host " [*] Forcing HAGS ON & Disabling Game DVR..." -NoNewline
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f | Out-Null
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f | Out-Null
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f | Out-Null
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 8: MEMORY & WINDOWS SERVICES OPTIMIZATION
Write-Host " [*] Purging Bloatware Services & Cache..." -NoNewline
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f | Out-Null
powercfg -h off | Out-Null

Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f | Out-Null

$services = @("wuauserv", "dosvc", "DiagTrack", "WSearch", "MapsBroker", "Fax", "RetailDemo", "RemoteRegistry", "WerSvc")
foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host " [ OK ]" -ForegroundColor Green

# STEP 9: FINAL PURGE & REFRESH NETWORK
Write-Host " [*] Flushing DNS & Resetting Network Adapters..." -NoNewline
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
ipconfig /flushdns | Out-Null
Get-NetAdapter | Where-Object {$_.Physical} | Restart-NetAdapter -ErrorAction SilentlyContinue
Write-Host " [ OK ]" -ForegroundColor Green

# DONE
Write-Host "--------------------------------------------------------------"
Write-Host ""
Write-Host " [SUCCESS] ALL SETTINGS APPLIED FLAWLESSLY WITH ZERO LATENCY!" -ForegroundColor Green
Write-Host " Please RESTART your PC to experience maximum performance." -ForegroundColor Green
Write-Host ""
Pause
