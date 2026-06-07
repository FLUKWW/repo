# ================================================================
# ULTIMATE ZERO LATENCY - TERMINAL EDITION v3
# ================================================================

# 1. ตรวจสอบสิทธิ์ Administrator 
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] ERROR: Please Run PowerShell as Administrator!" -ForegroundColor Red
    Start-Sleep -Seconds 3
    Exit
}

# 2. ปรับแต่งหน้าจอ Console
$Host.UI.RawUI.WindowTitle = "Ultimate Zero Latency - Extreme Edition v3"
Clear-Host

Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "    ULTIMATE ZERO LATENCY - POWERSHELL EDITION v3 (TERMINAL VERSION)     " -ForegroundColor Green
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[!] WARNING: Applying extreme tweaks for competitive gaming." -ForegroundColor Yellow
Write-Host "[!] Close all background apps before proceeding." -ForegroundColor Yellow
Write-Host ""

# รอให้ผู้ใช้กด Enter ก่อนเริ่ม
Read-Host "Press Enter to start optimization..."

Write-Host "`n[+] STARTING SYSTEM OPTIMIZATION ENGINE..." -ForegroundColor Cyan

# ====================================
# STEP 1: KERNEL TIME & CPU OPTIMIZATION
# ====================================
Write-Host "[*] Step 1: Optimizing Kernel Time & CPU Latency..." -ForegroundColor White
& bcdedit /set disabledynamictick yes | Out-Null
& bcdedit /set useplatformclock no | Out-Null
& bcdedit /set tscsyncpolicy Enhanced | Out-Null
& bcdedit /set synthetictimers yes | Out-Null

# ====================================
# STEP 2: GAMING PRIORITY & POWER THROTTLING
# ====================================
Write-Host "[*] Step 2: Tuning Gaming Priority & Power States..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x26 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f2c1-98bb-455b-9e09-ae4c1e16cb45" /v Attributes /t REG_DWORD /d 2 /f | Out-Null

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalCriticalWorkerThreads /t REG_DWORD /d 2 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalDelayedWorkerThreads /t REG_DWORD /d 2 /f | Out-Null

& reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f | Out-Null
& reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f | Out-Null

$gameTask = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
& reg.exe add $gameTask /v Affinity /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add $gameTask /v "Background Only" /t REG_SZ /d False /f | Out-Null
& reg.exe add $gameTask /v "Clock Rate" /t REG_DWORD /d 0x2710 /f | Out-Null
& reg.exe add $gameTask /v "GPU Priority" /t REG_DWORD /d 8 /f | Out-Null
& reg.exe add $gameTask /v Priority /t REG_DWORD /d 6 /f | Out-Null
& reg.exe add $gameTask /v "Scheduling Category" /t REG_SZ /d High /f | Out-Null
& reg.exe add $gameTask /v "SFIO Priority" /t REG_SZ /d High /f | Out-Null

# ====================================
# STEP 3: SECURITY MITIGATIONS OFF
# ====================================
Write-Host "[*] Step 3: Disabling Security Mitigations (Spectre/Meltdown/VBS)..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f | Out-Null

# ====================================
# STEP 4: KEYBOARD & MOUSE ZERO LATENCY
# ====================================
Write-Host "[*] Step 4: Forcing 1:1 Raw Input & Removing USB Latency..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb" /v IdleEnable /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f | Out-Null

& reg.exe add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 10 /f | Out-Null

& reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatDelay /t REG_SZ /d 125 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatRate /t REG_SZ /d 11 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v BounceTime /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v Flags /t REG_SZ /d 0 /f | Out-Null

# ====================================
# STEP 5: ADVANCED LOW-LATENCY NETWORK
# ====================================
Write-Host "[*] Step 5: Recalibrating TCP/IP Architecture..." -ForegroundColor White
& netsh int tcp set global autotuninglevel=disabled | Out-Null
& netsh int tcp set global rss=enabled | Out-Null
& netsh int tcp set global chimney=disabled | Out-Null
& netsh int tcp set global ecncapability=disabled | Out-Null
& netsh int tcp set global timestamps=disabled | Out-Null
& netsh int tcp set supplemental template=custom icw=10 | Out-Null
& netsh int ip set global taskoffload=enabled | Out-Null

$tcpParams = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
& reg.exe add $tcpParams /v DefaultTTL /t REG_DWORD /d 0x40 /f | Out-Null
& reg.exe add $tcpParams /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add $tcpParams /v EnableTCPA /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add $tcpParams /v EnableRSS /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add $tcpParams /v EnableTCPChimney /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add $tcpParams /v Tcp1323Opts /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add $tcpParams /v TcpTimedWaitDelay /t REG_DWORD /d 0x1e /f | Out-Null

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $_.PSPath -Name 'TcpDelAckTicks' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
}

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v CacheHashTableBucketSize /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v CacheHashTableSize /t REG_DWORD /d 0x180 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheEntryTtlLimit /t REG_DWORD /d 0xfa00 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxSOACacheEntryTtlLimit /t REG_DWORD /d 0x12d /f | Out-Null

& netsh winsock reset | Out-Null
& netsh int ip reset | Out-Null
& ipconfig /flushdns | Out-Null

# ====================================
# STEP 6: GRAPHICS, GAME MODE & GAME DVR
# ====================================
Write-Host "[*] Step 6: Forcing HAGS & Killing Game DVR..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f | Out-Null
& reg.exe add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null

& reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f | Out-Null

# ====================================
# STEP 7: MEMORY & SYSTEM TWEAKS
# ====================================
Write-Host "[*] Step 7: Optimizing Memory Cache & Killing OneDrive..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f | Out-Null
& powercfg -h off | Out-Null

Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
& reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f 2>$null | Out-Null

# ====================================
# STEP 8: WINDOWS SERVICES OPTIMIZATION
# ====================================
Write-Host "[*] Step 8: Overhauling Background Services..." -ForegroundColor White
# ปิด Service ขยะ (แทนที่ for %%S ของเดิมด้วย foreach ของ PowerShell)
$disableSvcs = @("wuauserv", "dosvc", "DiagTrack", "WSearch", "MapsBroker", "XblAuthManager", "XblGameSave", "XboxNetApiSvc", "Fax", "RetailDemo", "RemoteRegistry", "WerSvc")
foreach ($svc in $disableSvcs) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

# เปิด Service สำคัญ
$autoSvcs = @("Audiosrv", "AudioEndpointBuilder", "Dhcp", "NlaSvc", "Netman", "WlanSvc", "RpcSs", "EventLog", "PlugPlay", "LanmanWorkstation", "LanmanServer")
foreach ($svc in $autoSvcs) {
    Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $svc -ErrorAction SilentlyContinue
}

# ====================================
# STEP 9: JUNK CLEANUP & ADAPTER RESET
# ====================================
Write-Host "[*] Step 9: Flushing Cache & Hot-Restarting Network Interfaces..." -ForegroundColor White
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

Get-NetAdapter | Where-Object {$_.Physical} | Restart-NetAdapter -ErrorAction SilentlyContinue

Write-Host "`n=========================================================================" -ForegroundColor Green
Write-Host " [SUCCESS] ALL EXTREME SETTINGS APPLIED FULLY!" -ForegroundColor Yellow
Write-Host " Please RESTART your PC to run the engine fully." -ForegroundColor Cyan
Write-Host "=========================================================================`n" -ForegroundColor Green

Read-Host "Press Enter to exit"
