# ================================================================
# ULTIMATE ZERO LATENCY - PURE POWERSHELL EDITION v5.3
# Fixed & Upgraded (No PowerPlan / No Core Unparking)
# ================================================================

# ---- Admin Check -----------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] ERROR: Please Run PowerShell as Administrator!" -ForegroundColor Red
    Start-Sleep -Seconds 3
    Exit
}

$StartTime = Get-Date
$OSCaption = (Get-CimInstance Win32_OperatingSystem).Caption
$OSBuild   = (Get-CimInstance Win32_OperatingSystem).BuildNumber

Clear-Host
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "    ULTIMATE ZERO LATENCY - EXTREME ENGINE v5.3        " -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  OS    : $OSCaption"          -ForegroundColor DarkGray
Write-Host "  Build : $OSBuild"            -ForegroundColor DarkGray
Write-Host ""

# ====================================
# STEP 1: KERNEL & SYSTEM RESPONSIVENESS
# ====================================
Write-Host "[*] Step 1:  Optimizing Kernel Timers..." -ForegroundColor White

& bcdedit /set disabledynamictick yes | Out-Null
& bcdedit /set useplatformclock no    | Out-Null
& bcdedit /set tscsyncpolicy Enhanced | Out-Null

# ====================================
# STEP 2: GAMING PRIORITY & POWER THROTTLING
# ====================================
Write-Host "[*] Step 2:  Tuning Gaming Priority..." -ForegroundColor White

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" `
    /v Win32PrioritySeparation /t REG_DWORD /d 0x2a /f | Out-Null

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" `
    /v PowerThrottlingOff /t REG_DWORD /d 1 /f | Out-Null

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f2c1-98bb-455b-9e09-ae4c1e16cb45" `
    /v Attributes /t REG_DWORD /d 2 /f | Out-Null

$SysProfile = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
& reg.exe add $SysProfile /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f | Out-Null
& reg.exe add $SysProfile /v SystemResponsiveness   /t REG_DWORD /d 0          /f | Out-Null

$GameTask = "$SysProfile\Tasks\Games"
& reg.exe add $GameTask /v Affinity              /t REG_DWORD /d 0      /f | Out-Null
& reg.exe add $GameTask /v "Background Only"     /t REG_SZ    /d False  /f | Out-Null
& reg.exe add $GameTask /v "Clock Rate"          /t REG_DWORD /d 0x2710 /f | Out-Null
& reg.exe add $GameTask /v "GPU Priority"        /t REG_DWORD /d 8      /f | Out-Null
& reg.exe add $GameTask /v Priority              /t REG_DWORD /d 6      /f | Out-Null
& reg.exe add $GameTask /v "Scheduling Category" /t REG_SZ    /d High   /f | Out-Null
& reg.exe add $GameTask /v "SFIO Priority"       /t REG_SZ    /d High   /f | Out-Null

# ====================================
# STEP 3: GRAPHICS, HAGS & GAMEBAR
# ====================================
Write-Host "[*] Step 3:  Forcing HAGS, Game Mode & Disabling GameBar..." -ForegroundColor White

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" `
    /v HwSchMode /t REG_DWORD /d 2 /f | Out-Null

& reg.exe add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode   /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null

& reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null

& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_Enabled                       /t REG_DWORD /d 0 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode               /t REG_DWORD /d 2 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode      /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f | Out-Null

foreach ($svc in @("XblAuthManager", "XblGameSave", "XboxGipSvc", "XboxNetApiSvc")) {
    Set-Service  -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    Stop-Service -Name $svc -Force                -ErrorAction SilentlyContinue
}
Write-Host " -> Xbox/GameBar services disabled!" -ForegroundColor Gray

# ====================================
# STEP 4: MOUSE & KEYBOARD 1:1 RAW INPUT
# ====================================
Write-Host "[*] Step 4:  Forcing 1:1 Raw Input..." -ForegroundColor White

& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\USB" `
    /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f | Out-Null

& reg.exe add "HKCU\Control Panel\Mouse" /v MouseHoverTime  /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseSpeed      /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f | Out-Null

& reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58  /f | Out-Null
& reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys"  /v Flags /t REG_SZ /d 0   /f | Out-Null

# ====================================
# STEP 5: NETWORK OPTIMIZATION (TCP/IP)
# ====================================
Write-Host "[*] Step 5:  Recalibrating TCP/IP Architecture..." -ForegroundColor White

& netsh int tcp set global autotuninglevel=normal  | Out-Null
& netsh int tcp set global rss=enabled             | Out-Null
& netsh int tcp set global chimney=disabled        | Out-Null
& netsh int tcp set global rsc=disabled            | Out-Null
& netsh int tcp set heuristics disabled            | Out-Null
& netsh int tcp set global ecncapability=enabled   | Out-Null
& netsh int tcp set global timestamps=disabled     | Out-Null
& netsh int tcp set global fastopen=enabled        | Out-Null # [UPG]
$null = & netsh int udp set global uro=disabled 2>&1

$TcpParams = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
& reg.exe add $TcpParams /v DefaultTTL          /t REG_DWORD /d 0x40 /f | Out-Null
& reg.exe add $TcpParams /v EnablePMTUDiscovery /t REG_DWORD /d 1    /f | Out-Null
& reg.exe add $TcpParams /v EnableRSS           /t REG_DWORD /d 1    /f | Out-Null
& reg.exe add $TcpParams /v EnableTCPChimney    /t REG_DWORD /d 0    /f | Out-Null
& reg.exe add $TcpParams /v Tcp1323Opts         /t REG_DWORD /d 1    /f | Out-Null

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay'      -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
}

Get-NetAdapter -Physical | Where-Object { $_.Status -ne 'Not Present' } | ForEach-Object {
    Disable-NetAdapterLso -Name $_.Name -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $_.Name `
        -RegistryKeyword "*InterruptModeration" -RegistryValue 0 `
        -ErrorAction SilentlyContinue
}

& reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" `
    /v EnableMulticast /t REG_DWORD /d 0 /f | Out-Null

Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "NetbiosOptions" -Value 2 -ErrorAction SilentlyContinue
}

# ====================================
# STEP 6: ADVANCED UDP & AFD OPTIMIZATION
# ====================================
Write-Host "[*] Step 6:  Optimizing UDP Datagrams & AFD..." -ForegroundColor White

$AfdParams = "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters"
& reg.exe add $AfdParams /v FastSendDatagramThreshold /t REG_DWORD /d 65536 /f | Out-Null
& reg.exe add $AfdParams /v DefaultReceiveWindow      /t REG_DWORD /d 16384 /f | Out-Null
& reg.exe add $AfdParams /v DefaultSendWindow         /t REG_DWORD /d 16384 /f | Out-Null
& reg.exe add $AfdParams /v FastCopyReceiveThreshold  /t REG_DWORD /d 1536  /f | Out-Null

$QoS = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS"
& reg.exe add $QoS /v "Do not use NLA" /t REG_SZ /d "1" /f | Out-Null
& reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" `
    /v NonBestEffortLimit /t REG_DWORD /d 0 /f | Out-Null

# [UPG] Changed to CUBIC for better latency handling on modern connections
& netsh int tcp set supplemental template=custom congestionprovider=cubic | Out-Null
& netsh int tcp set supplemental template=custom icw=10                   | Out-Null
& netsh int tcp set supplemental template=custom initialrto=750           | Out-Null

# ====================================
# STEP 7: MEMORY OPTIMIZATION
# ====================================
Write-Host "[*] Step 7:  Optimizing Memory Management..." -ForegroundColor White

$MemMgmt = "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
& reg.exe add $MemMgmt /v DisablePagingExecutive /t REG_DWORD /d 1 /f | Out-Null
& reg.exe add $MemMgmt /v LargeSystemCache       /t REG_DWORD /d 0 /f | Out-Null

$ramKB        = [long]((Get-CimInstance Win32_ComputerSystem -Property TotalPhysicalMemory).TotalPhysicalMemory / 1KB)
$ramKBClamped = [uint32]([Math]::Max(0, [Math]::Min([uint64]$ramKB, 4294967295)))
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" `
    /v SvcHostSplitThresholdInKB /t REG_DWORD /d $ramKBClamped /f | Out-Null

# ====================================
# STEP 8: PER-PROCESS GAME PRIORITY (IFEO)
# ====================================
Write-Host "[*] Step 8:  Setting Per-Process Game Priority (IFEO)..." -ForegroundColor White

$IFEO = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

$games = @(
    "cs2.exe",
    "VALORANT-Win64-Shipping.exe",
    "FiveM_GTAProcess.exe",
    "GTA5.exe",
    "r5apex.exe",
    "RainbowSix.exe",
    "FortniteClient-Win64-Shipping.exe",
    "Overwatch.exe",
    "TslGame.exe",
    "EscapeFromTarkov.exe",
    "RocketLeague.exe",
    "cod.exe",
    "helldivers2.exe",   # [UPG] New
    "Discovery.exe",     # [UPG] The Finals
    "deadlock.exe",      # [UPG] Deadlock
    "XDefiant.exe"       # [UPG] XDefiant
)

foreach ($g in $games) {
    # [FIX] CpuPriorityClass 3 = High (5 was Below Normal!)
    & reg.exe add "$IFEO\$g\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f | Out-Null
    & reg.exe add "$IFEO\$g\PerfOptions" /v IoPriority       /t REG_DWORD /d 3 /f | Out-Null
}
Write-Host " -> $($games.Count) game processes configured to True High Priority!" -ForegroundColor Gray

# ====================================
# STEP 9: SYSTEM CLEANUP (JUNK FILES)
# ====================================
Write-Host "[*] Step 9:  Cleaning Junk Files & Temporary Data..." -ForegroundColor White

$JunkPaths = @(
    "$env:TEMP\*",
    "$env:WINDIR\Temp\*",
    "$env:WINDIR\Prefetch\*",
    "$env:WINDIR\SoftwareDistribution\Download\*"
)

foreach ($Path in $JunkPaths) {
    Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
}

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host " -> Junk files and Recycle Bin have been cleaned!" -ForegroundColor Gray

# ====================================
# STEP 10: VISUAL EFFECTS (BEST PERFORMANCE)
# ====================================
Write-Host "[*] Step 10: Optimizing Visual Effects..." -ForegroundColor White

& reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" `
    /v VisualFXSetting /t REG_DWORD /d 2 /f | Out-Null

& reg.exe add "HKCU\Control Panel\Desktop" /v MenuShowDelay    /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Desktop" /v DragFullWindows  /t REG_SZ /d 0 /f | Out-Null
& reg.exe add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f | Out-Null

Write-Host " -> Visual Effects set to Best Performance!" -ForegroundColor Gray

# ====================================
# FINISH
# ====================================
$Elapsed = (Get-Date) - $StartTime

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Green
Write-Host " [SUCCESS] EXTREME PROFILE v5.3 APPLIED SUCCESSFULLY"   -ForegroundColor Yellow
Write-Host "=======================================================" -ForegroundColor Green
Write-Host "  Steps completed : 10/10                              " -ForegroundColor Cyan
Write-Host ("  Elapsed time    : {0}s {1}ms" -f $Elapsed.Seconds, $Elapsed.Milliseconds) -ForegroundColor Cyan
Write-Host "  Please RESTART your PC to apply all changes.         " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 15
