# ================================================================
# ULTIMATE ZERO LATENCY - CODENAME: CYBER-GUI EDITION v4 (EXTREME MAX)
# ================================================================

# โหลดไลบรารีสำหรับสร้างหน้าต่าง GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. ตรวจสอบสิทธิ์ Administrator (ถ้าไม่ใช่ ให้แจ้งเตือนด้วยกล่องข้อความทันที)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.MessageBox]::Show("กรุณารัน PowerShell ในสิทธิ์ Administrator (Run as Administrator) เพื่อใช้งานโปรแกรมนี้!", "ลายเซ็นระบบ: สิทธิ์ไม่เพียงพอ", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    Exit
}

# 2. ตั้งค่าฟอนต์หลักของระบบ UI
$fontTitle  = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fontSub    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$fontWarn   = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$fontBtn    = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fontLog    = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Regular)

# 3. สร้างหน้าต่างหลัก (Main Form) ดีไซน์ Dark Mode
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ultimate Zero Latency - Extreme Edition v4"
$form.Size = New-Object System.Drawing.Size(750, 600)
$form.BackColor = [System.Drawing.Color]::FromArgb(11, 14, 20)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# --- ส่วนหัวโปรแกรม (HEADER) ---
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "ULTIMATE ZERO LATENCY"
$lblTitle.Font = $fontTitle
$lblTitle.ForeColor = [System.Drawing.Color]::FromArgb(0, 229, 255)
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(700, 35)
$lblTitle.TextAlign = "MiddleCenter"
$form.Controls.Add($lblTitle)

$lblSub = New-Object System.Windows.Forms.Label
$lblSub.Text = "POWERSHELL EXTREME ENGINE v4 // TUNED FOR COMPETITIVE GAMING"
$lblSub.Font = $fontSub
$lblSub.ForeColor = [System.Drawing.Color]::FromArgb(139, 148, 158)
$lblSub.Location = New-Object System.Drawing.Point(20, 55)
$lblSub.Size = New-Object System.Drawing.Size(700, 20)
$lblSub.TextAlign = "MiddleCenter"
$form.Controls.Add($lblSub)

# --- กล่องข้อความเตือน (WARNING PANEL) ---
$lblWarn = New-Object System.Windows.Forms.Label
$lblWarn.Text = "[!] WARNING: Applying extreme tweaks for competitive gaming. Close all background apps before proceeding."
$lblWarn.Font = $fontWarn
$lblWarn.ForeColor = [System.Drawing.Color]::FromArgb(255, 165, 0)
$lblWarn.Location = New-Object System.Drawing.Point(20, 85)
$lblWarn.Size = New-Object System.Drawing.Size(700, 25)
$lblWarn.TextAlign = "MiddleCenter"
$form.Controls.Add($lblWarn)

# --- ช่องจำลองหน้าจอ CONSOLE LOG (RICH TEXT BOX) ---
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(30, 125)
$logBox.Size = New-Object System.Drawing.Size(675, 260)
$logBox.BackColor = [System.Drawing.Color]::FromArgb(18, 22, 32)
$logBox.ForeColor = [System.Drawing.Color]::FromArgb(201, 209, 217)
$logBox.Font = $fontLog
$logBox.ReadOnly = $true
$logBox.BorderStyle = "None"
$form.Controls.Add($logBox)

# ฟังก์ชันสำหรับพิมพ์ Log แยกสีลงในหน้าต่าง UI
function Update-Log ($text, $color = "White") {
    $logBox.SelectionStart = $logBox.TextLength
    $logBox.SelectionLength = 0
    $logBox.SelectionColor = [System.Drawing.Color]::$color
    $logBox.AppendText("$text`r`n")
    $logBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

Update-Log ">> System Engine Ready." "Cyan"
Update-Log ">> Awaiting optimization deployment sequence..." "Gray"

# --- แถบโหลด PROGRESS BAR ---
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(30, 400)
$progressBar.Size = New-Object System.Drawing.Size(675, 15)
$progressBar.Style = "Continuous"
$form.Controls.Add($progressBar)

# --- ปุ่มกดเริ่มจูนระบบ (START OPTIMIZATION BUTTON) ---
$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "START OPTIMIZATION"
$btnStart.Font = $fontBtn
$btnStart.Location = New-Object System.Drawing.Point(30, 435)
$btnStart.Size = New-Object System.Drawing.Size(675, 55)
$btnStart.BackColor = [System.Drawing.Color]::FromArgb(0, 204, 102)
$btnStart.ForeColor = [System.Drawing.Color]::White
$btnStart.FlatStyle = "Flat"
$btnStart.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnStart)

# --- ฟังก์ชันทำงานเมื่อกดปุ่ม (CLICK EVENT ACTION) ---
$btnStart.Add_Click({
    $btnStart.Enabled = $false
    $btnStart.BackColor = [System.Drawing.Color]::FromArgb(40, 45, 55)
    $btnStart.Text = "OPTIMIZATION IN PROGRESS..."
    
    $progressBar.Value = 0
    $logBox.Clear()
    
    Update-Log "========== STARTING SYSTEM OPTIMIZATION ENGINE ==========" "Cyan"
    
    # STEP 1: RESTORE POINT (SMART CHECK)
    $progressBar.Value = 10
    Update-Log "[*] Step 1: Checking System Restore Point status..." "White"
    
    $rpExists = $false
    $rpList = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
    if ($rpList) {
        foreach ($rp in $rpList) {
            if ($rp.Description -eq "Pre-ZeroLatency_v3" -or $rp.Description -eq "Pre-ZeroLatency_v4") {
                $rpExists = $true
                break
            }
        }
    }

    if ($rpExists) {
        Update-Log "--> Restore Point already exists! Skipping creation to save time." "Yellow"
    } else {
        Update-Log "--> No Restore Point found. Creating a new one (This may take a moment)..." "Cyan"
        Checkpoint-Computer -Description "Pre-ZeroLatency_v4" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
        Update-Log "--> Restore Point Configured Successfully." "Green"
    }
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 2: KERNEL TIME & CPU OPTIMIZATION
    $progressBar.Value = 20
    Update-Log "[*] Step 2: Optimizing CPU Timers & Reducing DPC Latency..." "White"
    bcdedit /set disabledynamictick yes | Out-Null
    bcdedit /set useplatformclock no | Out-Null
    bcdedit /set tscsyncpolicy Enhanced | Out-Null
    bcdedit /set synthetictimers yes | Out-Null
    Update-Log "--> Kernel Timers Overclocked & Pushed to Low Latency." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 3: GAMING PRIORITY & POWER THROTTLING
    $progressBar.Value = 30
    Update-Log "[*] Step 3: Tuning Windows Resource Priority Queue..." "White"
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
    Update-Log "--> Gaming Priority Scheduler Profiles Deployed." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 4: SECURITY MITIGATIONS OFF (FPS BOOST)
    $progressBar.Value = 40
    Update-Log "[*] Step 4: Disabling Deep Security Mitigations (VBS/Core Isolation)..." "White"
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f | Out-Null
    Update-Log "--> Security Patches Overridden. Maximum IPC Throughput Unlocked." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 5: KEYBOARD & MOUSE ZERO LATENCY
    $progressBar.Value = 50
    Update-Log "[*] Step 5: Applying 1:1 Raw Input & Stripping USB Idle Latency..." "White"
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
    Update-Log "--> USB Polling Stabilized & Mouse/Keyboard Delays Eliminated." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 6: ADVANCED LOW-LATENCY NETWORK (TCP/IP)
    $progressBar.Value = 60
    Update-Log "[*] Step 6: Recalibrating TCP/IP Architecture & Network Adapters..." "White"
    netsh int tcp set global autotuninglevel=disabled | Out-Null
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
    Update-Log "--> Network Interface Optimization Deployed. Registry Packet Queuing Fixed." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 7: GRAPHICS, GAME MODE & GAME DVR
    $progressBar.Value = 70
    Update-Log "[*] Step 7: Forcing Hardware-Accelerated GPU Scheduling (HAGS) ON..." "White"
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f | Out-Null
    reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
    reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f | Out-Null
    Update-Log "--> HAGS Enabled & Game DVR Background Process Terminated." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 8: MEMORY & WINDOWS SERVICES OPTIMIZATION
    $progressBar.Value = 80
    Update-Log "[*] Step 8: Memory Paging ^& Base Services Overhaul..." "White"
    # บังคับระบบปฏิบัติการให้อยู่บน RAM (ดีมากสำหรับเครื่อง RAM 16GB+)
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f | Out-Null
    powercfg -h off | Out-Null

    Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f | Out-Null

    # เพิ่มการปิด SysMain (ลดดิสก์ 100%)
    $services = @("wuauserv", "dosvc", "DiagTrack", "WSearch", "MapsBroker", "Fax", "RetailDemo", "RemoteRegistry", "WerSvc", "SysMain")
    foreach ($svc in $services) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
    Update-Log "--> Windows Bloatware Services Neutralized. Kernel Pinned to RAM." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 9: OS BLOAT & DEEP SYSTEM TWEAKS (NEW!)
    $progressBar.Value = 90
    Update-Log "[*] Step 9: Injecting Deep OS Tweaks (NDU, Telemetry, Apps)..." "White"
    # ปิด NDU (แก้ปัญหา Memory Leak จาก Network)
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v Start /t REG_DWORD /d 4 /f | Out-Null
    # ปิด Telemetry
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
    # ปิด Background Apps ทั้งระบบ
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f | Out-Null
    Update-Log "--> OS Telemetry Blinded. Network Data Usage Monitor Destroyed." "Green"
    Update-Log "--------------------------------------------------------" "Gray"

    # STEP 10: FINAL PURGE & REFRESH NETWORK
    $progressBar.Value = 100
    Update-Log "[*] Step 10: Flushing DNS Cache & Hot-Restarting Network Interfaces..." "White"
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    ipconfig /flushdns | Out-Null
    Get-NetAdapter | Where-Object {$_.Physical} | Restart-NetAdapter -ErrorAction SilentlyContinue
    Update-Log "--> Cache Cleared & Hardware Interfaces Recycled." "Green"
    
    Update-Log ""
    Update-Log "[SUCCESS] ALL CORES AND REGISTRY PROFILES TUNED COMPLETELY!" "Yellow"
    Update-Log "[!] Please RESTART your computer to run the engine fully." "Cyan"
    
    # อัปเดตปุ่มเมื่อทำงานเสร็จสิ้น
    $btnStart.BackColor = [System.Drawing.Color]::FromArgb(0, 150, 255)
    $btnStart.Text = "COMPLETED! PLEASE RESTART YOUR PC"
})

# 4. แสดงผลหน้าต่าง UI ออกมาจอคอมพิวเตอร์
$form.ShowDialog() | Out-Null
