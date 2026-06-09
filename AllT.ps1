<#
================================================================
ULTIMATE ZERO LATENCY - PURE POWERSHELL EDITION v4.3 (BUG FIX)
================================================================
#>

# 1. ตรวจสอบสิทธิ์ Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("กรุณารันสคริปต์นี้ในสิทธิ์ Administrator เท่านั้น! (Run as Administrator)", "Error", "OK", "Error")
    Exit
}

# 2. รายการคีย์ทั้งหมด 20 คีย์
$ValidKeys = @(
    "UZL-4V9X-2K7B-M1N0", "UZL-8W2Z-5Q4P-R7T9", "UZL-1M6K-9J3D-L5F2", "UZL-7V4C-2X8B-N1M0",
    "UZL-3K9P-6Q2W-R5T7", "UZL-5F1D-8J3K-M6L2", "UZL-9N0B-4V7C-2X1M", "UZL-2W7P-5Q3K-R9T8",
    "UZL-6M2L-9F5D-K1J3", "UZL-0N1M-4B7V-C2X8", "UZL-4Q3W-7P9K-R2T5", "UZL-8F6D-1J2K-M3L5",
    "UZL-3V2C-7X1B-N9M0", "UZL-9W5P-2Q8K-R3T7", "UZL-5M1L-8F4D-K2J6", "UZL-0B7V-4C2X-1M9N",
    "UZL-6Q7W-2P3K-R5T9", "UZL-1F9D-5J4K-M2L8", "UZL-7V3C-8X2B-N0M1", "UZL-2W9P-6Q4K-R7T3"
)

# 3. ฟังก์ชันดึงค่า Hardware ID สำหรับล็อกเครื่อง
function Get-DeviceHWID {
    return (Get-CimInstance Win32_ComputerSystemProduct).UUID
}

$RegPath = "HKLM:\SOFTWARE\UltimateZeroLatency"
$CurrentHWID = Get-DeviceHWID

# โหลด Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# สร้างหน้าต่างหลัก
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "ULTIMATE ZERO LATENCY - EXTREME ENGINE v4.3"
$Form.Size = New-Object System.Drawing.Size(550, 600)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false
$Form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

function Set-ControlStyle ($Control, $ForeColor, $BackColor) {
    $Control.ForeColor = $ForeColor
    $Control.BackColor = $BackColor
    $Control.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
}

# ==========================================
# LOGIN PANEL
# ==========================================
$LoginPanel = New-Object System.Windows.Forms.Panel
$LoginPanel.Size = $Form.ClientSize
$LoginPanel.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
$Form.Controls.Add($LoginPanel)

$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Text = "ULTIMATE ZERO LATENCY v4.3"
$TitleLabel.Size = New-Object System.Drawing.Size(500, 40)
$TitleLabel.Location = New-Object System.Drawing.Point(25, 30)
$TitleLabel.Font = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
$TitleLabel.ForeColor = [System.Drawing.Color]::Cyan
$TitleLabel.TextAlign = "MiddleCenter"
$LoginPanel.Controls.Add($TitleLabel)

$KeyLabel = New-Object System.Windows.Forms.Label
$KeyLabel.Text = "กรุณาใส่ LICENSE KEY เพื่อเปิดใช้งานสคริปต์:"
$KeyLabel.Size = New-Object System.Drawing.Size(450, 25)
$KeyLabel.Location = New-Object System.Drawing.Point(50, 180)
$KeyLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$KeyLabel.ForeColor = [System.Drawing.Color]::White
$KeyLabel.TextAlign = "MiddleCenter"
$LoginPanel.Controls.Add($KeyLabel)

$KeyInput = New-Object System.Windows.Forms.TextBox
$KeyInput.Size = New-Object System.Drawing.Size(350, 30)
$KeyInput.Location = New-Object System.Drawing.Point(100, 220)
$KeyInput.Font = New-Object System.Drawing.Font("Consolas", 12)
$KeyInput.TextAlign = "Center"
$LoginPanel.Controls.Add($KeyInput)

$ActivateBtn = New-Object System.Windows.Forms.Button
$ActivateBtn.Text = "ACTIVATE SYSTEM"
$ActivateBtn.Size = New-Object System.Drawing.Size(200, 45)
$ActivateBtn.Location = New-Object System.Drawing.Point(175, 280)
Set-ControlStyle $ActivateBtn ([System.Drawing.Color]::Black) ([System.Drawing.Color]::LimeGreen)
$LoginPanel.Controls.Add($ActivateBtn)

$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "สถานะ: รอการเปิดใช้งาน..."
$StatusLabel.Size = New-Object System.Drawing.Size(450, 25)
$StatusLabel.Location = New-Object System.Drawing.Point(50, 350)
$StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$StatusLabel.ForeColor = [System.Drawing.Color]::DarkGray
$StatusLabel.TextAlign = "MiddleCenter"
$LoginPanel.Controls.Add($StatusLabel)


# ==========================================
# MAIN TWEAK PANEL
# ==========================================
$MainPanel = New-Object System.Windows.Forms.Panel
$MainPanel.Size = $Form.ClientSize
$MainPanel.Visible = $false
$Form.Controls.Add($MainPanel)

$MainTitle = New-Object System.Windows.Forms.Label
$MainTitle.Text = "TWEAK ENGINE SELECTION"
$MainTitle.Size = New-Object System.Drawing.Size(500, 35)
$MainTitle.Location = New-Object System.Drawing.Point(25, 20)
$MainTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$MainTitle.ForeColor = [System.Drawing.Color]::LimeGreen
$MainTitle.TextAlign = "MiddleCenter"
$MainPanel.Controls.Add($MainTitle)

$ChkBxStyle = {
    param($cb, $text, $y)
    $cb.Text = $text
    $cb.Size = New-Object System.Drawing.Size(450, 30)
    $cb.Location = New-Object System.Drawing.Point(40, $y)
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $cb.ForeColor = [System.Drawing.Color]::White
    $cb.Checked = $true
}

$cb1 = New-Object System.Windows.Forms.CheckBox; &$ChkBxStyle $cb1 "Step 1: Optimize Kernel Time & Platform Clock" 70
$cb2 = New-Object System.Windows.Forms.CheckBox; &$ChkBxStyle $cb2 "Step 2: Gaming Priority Control & Throttling Off" 105
$cb3 = New-Object System.Windows.Forms.CheckBox; &$ChkBxStyle $cb3 "Step 3: Force HAGS & Game Mode Optimization" 140
$cb4 = New-Object System.Windows.Forms.CheckBox; &$ChkBxStyle $cb4 "Step 4: Force 1:1 Raw Input Mouse/Keyboard" 175
$cb5 = New-Object System.Windows.Forms.CheckBox; &$ChkBxStyle $cb5 "Step 5: Recalibrate TCP/IP & Network Latency" 210

$MainPanel.Controls.AddRange(@($cb1, $cb2, $cb3, $cb4, $cb5))

$LogBox = New-Object System.Windows.Forms.TextBox
$LogBox.Multiline = $true
$LogBox.ReadOnly = $true
$LogBox.ScrollBars = "Vertical"
$LogBox.Size = New-Object System.Drawing.Size(460, 200)
$LogBox.Location = New-Object System.Drawing.Point(45, 260)
$LogBox.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
$LogBox.ForeColor = [System.Drawing.Color]::Cyan
$LogBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$MainPanel.Controls.Add($LogBox)

$ApplyBtn = New-Object System.Windows.Forms.Button
$ApplyBtn.Text = "ENGAGE OPTIMIZATION"
$ApplyBtn.Size = New-Object System.Drawing.Size(460, 45)
$ApplyBtn.Location = New-Object System.Drawing.Point(45, 480)
Set-ControlStyle $ApplyBtn ([System.Drawing.Color]::Black) ([System.Drawing.Color]::Cyan)
$MainPanel.Controls.Add($ApplyBtn)

function Write-Log ($Message) {
    $Form.Invoke([Action[string]]{ 
        param($msg) 
        $LogBox.AppendText("[$((Get-Date).ToString('HH:mm:ss'))] $msg`r`n") 
    }, $Message)
}

# ==========================================
# EVENTS & LOGIC
# ==========================================
function Show-MainDashboard {
    $LoginPanel.Visible = $false
    $MainPanel.Visible = $true
    Write-Log "System Authorized. Ready to optimize."
}

if (Test-Path $RegPath) {
    $SavedKey = (Get-ItemProperty -Path $RegPath -Name "LicenseKey" -ErrorAction SilentlyContinue).LicenseKey
    $SavedHWID = (Get-ItemProperty -Path $RegPath -Name "HWID" -ErrorAction SilentlyContinue).HWID
    if ($SavedHWID -eq $CurrentHWID -and $ValidKeys -contains $SavedKey) { Show-MainDashboard }
}

$ActivateBtn.Add_Click({
    $EnteredKey = $KeyInput.Text.Trim().ToUpper()
    if (-not $EnteredKey) {
        $StatusLabel.Text = "กรุณากรอกคีย์ก่อนครับ!"
        $StatusLabel.ForeColor = [System.Drawing.Color]::Red
        return
    }

    if ($ValidKeys -contains $EnteredKey) {
        if (Test-Path $RegPath) {
            $CheckKey = (Get-ItemProperty -Path $RegPath -Name "LicenseKey" -ErrorAction SilentlyContinue).LicenseKey
            $CheckHWID = (Get-ItemProperty -Path $RegPath -Name "HWID" -ErrorAction SilentlyContinue).HWID
            
            if ($CheckKey -eq $EnteredKey -and $CheckHWID -ne $CurrentHWID) {
                $StatusLabel.Text = "คีย์นี้ถูกล็อกใช้งานกับเครื่องอื่นไปแล้ว!"
                $StatusLabel.ForeColor = [System.Drawing.Color]::Red
                return
            }
        }
        if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
        Set-ItemProperty -Path $RegPath -Name "LicenseKey" -Value $EnteredKey -Force
        Set-ItemProperty -Path $RegPath -Name "HWID" -Value $CurrentHWID -Force
        
        $StatusLabel.Text = "เปิดใช้งานสำเร็จ กำลังเข้าสู่ระบบ..."
        $StatusLabel.ForeColor = [System.Drawing.Color]::LimeGreen
        
        $Timer = New-Object System.Windows.Forms.Timer
        $Timer.Interval = 1200
        # แก้ไขจุดที่ทำให้เกิด Loop ตรงนี้ครับ
        $Timer.Add_Tick({ 
            param($sender, $e)
            $sender.Stop()
            Show-MainDashboard 
        })
        $Timer.Start()
    } else {
        $StatusLabel.Text = "คีย์ไม่ถูกต้อง หรือ ไม่มีคีย์นี้ในระบบ!"
        $StatusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

$ApplyBtn.Add_Click({
    $ApplyBtn.Enabled = $false
    $ApplyBtn.Text = "OPTIMIZING IN PROGRESS (PLEASE WAIT)..."
    $ApplyBtn.BackColor = [System.Drawing.Color]::DarkSlateGray
    $LogBox.Clear()
    Write-Log "Initializing Optimization Engine..."

    $ScriptBlock = {
        param($run1, $run2, $run3, $run4, $run5)
        $LogsList = New-Object System.Collections.ArrayList

        if ($run1) {
            $LogsList.Add("[*] Optimizing Kernel Time & Platform Clock...") | Out-Null
            & bcdedit /set disabledynamictick yes | Out-Null
            & bcdedit /set useplatformclock no | Out-Null
            & bcdedit /set tscsyncpolicy Enhanced | Out-Null
            & bcdedit /set synthetictimers yes | Out-Null
        }

        if ($run2) {
            $LogsList.Add("[*] Tuning Gaming Priority & Power Throttling...") | Out-Null
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
        }

        if ($run3) {
            $LogsList.Add("[*] Forcing HAGS & Game Mode Optimization...") | Out-Null
            & reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f | Out-Null
            & reg.exe add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f | Out-Null
            & reg.exe add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null
            & reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
            & reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
            & reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
            & reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
            & reg.exe add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f | Out-Null
        }

        if ($run4) {
            $LogsList.Add("[*] Configuring 1:1 Raw Input & Removing Acceleration...") | Out-Null
            & reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 0 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f | Out-Null
            & reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v Flags /t REG_SZ /d 0 /f | Out-Null
        }

        if ($run5) {
            $LogsList.Add("[*] Recalibrating TCP/IP Network Architecture...") | Out-Null
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
        }

        $LogsList.Add("[SUCCESS] ALL SELECTED CHANGES APPLIED!") | Out-Null
        return $LogsList.ToArray()
    }

    $PowerShellJob = [powershell]::Create().AddScript($ScriptBlock).AddArgument($cb1.Checked).AddArgument($cb2.Checked).AddArgument($cb3.Checked).AddArgument($cb4.Checked).AddArgument($cb5.Checked)
    $AsyncResult = $PowerShellJob.BeginInvoke()

    $JobTimer = New-Object System.Windows.Forms.Timer
    $JobTimer.Interval = 300
    # แก้ไขจุดที่ทำให้เกิด Loop ป้องกันไว้ให้ด้วยครับ
    $JobTimer.Add_Tick({
        param($sender, $e)
        if ($AsyncResult.IsCompleted) {
            $sender.Stop()
            $Outputs = $PowerShellJob.EndInvoke($AsyncResult)
            foreach ($line in $Outputs) { Write-Log $line }
            $PowerShellJob.Dispose()
            
            $ApplyBtn.Enabled = $true
            $ApplyBtn.Text = "ENGAGE OPTIMIZATION"
            $ApplyBtn.BackColor = [System.Drawing.Color]::Cyan
            [System.Windows.Forms.MessageBox]::Show("ระบบปรับแต่งค่าเรียบร้อยแล้ว!`nกรุณาทำการ Restart PC เพื่อให้ผลลัพธ์ทำงาน 100%", "Success", "OK", "Information")
        }
    })
    $JobTimer.Start()
})

# แสดงผลฟอร์ม
[System.Windows.Forms.Application]::Run($Form)
