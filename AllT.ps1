# ================================================================
# ULTIMATE ZERO LATENCY - PURE POWERSHELL EDITION v4
# ================================================================

# 1. ตรวจสอบสิทธิ์ Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] ERROR: Please Run PowerShell as Administrator!" -ForegroundColor Red
    Start-Sleep -Seconds 3
    Exit
}

Clear-Host
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "    ULTIMATE ZERO LATENCY - EXTREME ENGINE v4          " -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

# ====================================
# STEP 1: KERNEL & SYSTEM RESPONSIVENESS
# ====================================
Write-Host "[*] Step 1: Optimizing Kernel Time..." -ForegroundColor White
& bcdedit /set disabledynamictick yes | Out-Null
& bcdedit /set useplatformclock no | Out-Null
& bcdedit /set tscsyncpolicy Enhanced | Out-Null
& bcdedit /set synthetictimers yes | Out-Null

# ====================================
# STEP 2: GAMING PRIORITY & POWER THROTTLING
# ====================================
Write-Host "[*] Step 2: Tuning Gaming Priority..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0xfa332a /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f2c1-98bb-455b-9e09-ae4c1e16cb45" /v Attributes /t REG_DWORD /d 2 /f | Out-Null

$SysProfile = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
& reg.exe add $SysProfile /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f | Out-Null
& reg.exe add $SysProfile /v SystemResponsiveness /t REG_DWORD /d 0 /f | Out-Null

$GameTask = "$SysProfile\Tasks\Games"
& reg.exe add $GameTask /v Affinity /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add $GameTask /v "Background Only" /t REG_SZ /d False /f | Out-Null
& reg.exe add $GameTask /v "Clock Rate" /t REG_DWORD /d 0x2710 /f | Out-Null
& reg.exe add $GameTask /v "GPU Priority" /t REG_DWORD /d 8 /f | Out-Null
& reg.exe add $GameTask /v Priority /t REG_DWORD /d 6 /f | Out-Null
& reg.exe add $GameTask /v "Scheduling Category" /t REG_SZ /d High /f | Out-Null
& reg.exe add $GameTask /v "SFIO Priority" /t REG_SZ /d High /f | Out-Null

# ====================================
# STEP 3: GRAPHICS & HAGS (CRITICAL FOR GPU USAGE)
# ====================================
Write-Host "[*] Step 3: Forcing HAGS & Game Mode..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f | Out-Null
& reg.exe add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f | Out-Null

# ====================================
# STEP 4: MOUSE & KEYBOARD 1:1 RAW INPUT
# ====================================
Write-Host "[*] Step 4: Forcing 1:1 Raw Input..." -ForegroundColor White
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v Flags /t REG_SZ /d 0 /f | Out-Null

# ====================================
# STEP 5: NETWORK OPTIMIZATION
# ====================================
Write-Host "[*] Step 5: Recalibrating TCP/IP Architecture..." -ForegroundColor White
& netsh int tcp set global autotuninglevel=disabled | Out-Null
& netsh int tcp set global rss=enabled | Out-Null
& netsh int tcp set global chimney=disabled | Out-Null
& netsh int tcp set global ecncapability=disabled | Out-Null
& netsh int tcp set global timestamps=disabled | Out-Null

$TcpParams = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
& reg.exe add $TcpParams /v DefaultTTL /t REG_DWORD /d 0x40 /f | Out-Null
& reg.exe add $TcpParams /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add $TcpParams /v EnableRSS /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add $TcpParams /v EnableTCPChimney /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add $TcpParams /v Tcp1323Opts /t REG_DWORD /d 1 /f | Out-Null

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "`n=======================================================" -ForegroundColor Green
Write-Host " [SUCCESS] EXTREME PROFILE APPLIED SUCCESSFULLY" -ForegroundColor Yellow
Write-Host " Please RESTART your PC to apply all changes." -ForegroundColor Cyan
Write-Host "=======================================================`n" -ForegroundColor Green
