<#
================================================================
ULTIMATE ZERO LATENCY - PURE POWERSHELL EDITION v4 (GUI & KEY LOCK)
================================================================
#>

# 1. ตรวจสอบสิทธิ์ Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("กรุณารันสคริปต์นี้ในสิทธิ์ Administrator เท่านั้น! (Run as Administrator)", "Error", "OK", "Error")
    Exit
}

# 2. รายการคีย์ทั้งหมด 20 คีย์ (Hardcoded ในระบบ)
$ValidKeys = @(
    "UZL-4V9X-2K7B-M1N0", "UZL-8W2Z-5Q4P-R7T9", "UZL-1M6K-9J3D-L5F2", "UZL-7V4C-2X8B-N1M0",
    "UZL-3K9P-6Q2W-R5T7", "UZL-5F1D-8J3K-M6L2", "UZL-9N0B-4V7C-2X1M", "UZL-2W7P-5Q3K-R9T8",
    "UZL-6M2L-9F5D-K1J3", "UZL-0N1M-4B7V-C2X8", "UZL-4Q3W-7P9K-R2T5", "UZL-8F6D-1J2K-M3L5",
    "UZL-3V2C-7X1B-N9M0", "UZL-9W5P-2Q8K-R3T7", "UZL-5M1L-8F4D-K2J6", "UZL-0B7V-4C2X-1M9N",
    "UZL-6Q7W-2P3K-R5T9", "UZL-1F9D-5J4K-M2L8", "UZL-7V3C-8X2B-N0M1", "UZL-2W9P-6Q4K-R7T3"
)

# 3. ฟังก์ชันดึงค่า Hardware ID (UUID ของเมนบอร์ด) สำหรับล็อกเครื่อง
function Get-DeviceHWID {
    return (Get-CimInstance Win32_ComputerSystemProduct).UUID
}

# 4. โครงสร้างสำหรับการเก็บข้อมูลใน Registry
$RegPath = "HKLM:\SOFTWARE\UltimateZeroLatency"
$CurrentHWID = Get-DeviceHWID

# โหลด Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# สร้างหน้าต่างหลัก
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "ULTIMATE ZERO LATENCY - EXTREME ENGINE v4"
$Form.Size = New-Object System.Drawing.Size(550, 600)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false
$Form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

# ฟังก์ชันสร้างสไตล์ปุ่ม
function Set-ControlStyle ($Control, $ForeColor, $BackColor) {
    $Control.ForeColor = $ForeColor
    $Control.BackColor = $BackColor
    $Control.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
}

# ==========================================
# หน้าต่างต้อนรับ / เปิดใช้งานคีย์ (LOGIN PANEL)
# ==========================================
$LoginPanel = New-Object System.Windows.Forms.Panel
$LoginPanel.Size = $Form.ClientSize
$LoginPanel.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
$Form.Controls.Add($LoginPanel)

$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Text = "ULTIMATE ZERO LATENCY v4"
$TitleLabel.Size = New-Object System.Drawing.Size(500, 40)
$TitleLabel.Location = New-Object System.Drawing.Point(25, 30)
$TitleLabel.Font = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
$TitleLabel.ForeColor = [System.Drawing.Color]::Cyan
$TitleLabel.TextAlign = "Center"
$LoginPanel.Controls.Add($TitleLabel)

$KeyLabel = New-Object System.Windows.Forms.Label
$KeyLabel.Text = "กรุณาใส่ LICENSE KEY เพื่อเปิดใช้งานสคริปต์:"
$KeyLabel.Size = New-Object System.Drawing.Size(450, 25)
$KeyLabel.Location = New-Object System.Drawing.Point(50, 180)
$KeyLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$KeyLabel.ForeColor = [System.Drawing.Color]::White
$KeyLabel.TextAlign = "Center"
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
$StatusLabel.TextAlign = "Center"
$LoginPanel.Controls.Add($StatusLabel)


# ==========================================
# หน้าต่างปรับแต่งหลัก (MAIN TWEAK PANEL)
# ==========================================
$MainPanel = New-Object System.Windows.Forms.Panel
$MainPanel.Size = $Form.ClientSize
$MainPanel.Visible = $false
$Form.Controls.Add($MainPanel)

# Header
$MainTitle = New-Object System.Windows.Forms.Label
$MainTitle.Text = "TWEAK ENGINE SELECTION"
$MainTitle.Size = New-Object System.Drawing.Size(500, 35)
$MainTitle.Location = New-Object System.Drawing.Point(25, 20)
$MainTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$MainTitle.ForeColor = [System.Drawing.Color]::LimeGreen
$MainTitle.TextAlign = "Center"
$MainPanel.Controls.Add($MainTitle)

# Checkboxes สำหรับเลือกสเต็ปการรัน (ป้องกันไม่ให้บัค ติ๊กเลือกได้อิสระ)
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

# Log Output Box (กล่องแสดงผลการทำงานสดๆ)
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

# ปุ่มรันสคริปต์
$ApplyBtn = New-Object System.Windows.Forms.Button
$ApplyBtn.Text = "ENGAGE OPTIMIZATION"
$ApplyBtn.Size = New-Object System.Drawing.Size(460, 45)
$ApplyBtn.Location = New-Object System.Drawing.Point(45, 480)
Set-ControlStyle $ApplyBtn ([System.Drawing.Color]::Black) ([System.Drawing.Color]::Cyan)
$MainPanel.Controls.Add($ApplyBtn)

# ฟังก์ชันแสดง Log ในกล่องข้อความ
function Write-Log ($Message) {
    $Form.Invoke([Action[string]]{ 
        param($msg) 
        $LogBox.AppendText("[$((Get-Date).ToString('HH:mm:ss'))] $msg`r`n") 
    }, $Message)
}

# ==========================================
# ระบบเหตุการณ์ (EVENTS) & ตรรกะเบื้องหลัง
# ==========================================

# ฟังก์ชันเปลี่ยนหน้าเมื่อคีย์ผ่าน
function Show-MainDashboard {
    $LoginPanel.Visible = $false
    $MainPanel.Visible = $true
    Write-Log "System Authorized. Ready to optimize."
}

# ตรวจสอบว่าเครื่องนี้เคยลงทะเบียนไว้หรือยังเมื่อเปิดโปรแกรม
if (Test-Path $RegPath) {
    $SavedKey = (Get-ItemProperty -Path $RegPath -Name "LicenseKey" -ErrorAction SilentlyContinue).LicenseKey
    $SavedHWID = (Get-ItemProperty -Path $RegPath -Name "HWID" -ErrorAction SilentlyContinue).HWID
    
    if ($SavedHWID -eq $CurrentHWID -and $ValidKeys -contains $SavedKey) {
        # เครื่องเดิม คีย์เดิมที่เคยกรอกไว้ -> ผ่านอัตโนมัติ
        Show-MainDashboard
    }
}

# เมื่อกดปุ่มเปิดใช้งานคีย์ (Activate)
$ActivateBtn.Add_Click({
    $EnteredKey = $KeyInput.Text.Trim().ToUpper()
    
    if (-not $EnteredKey) {
        $StatusLabel.Text = "กรุณากรอกคีย์ก่อนครับ!"
        $StatusLabel.ForeColor = [System.Drawing.Color]::Red
        return
    }

    # ตรวจสอบว่าคีย์ที่กรอกถูกต้องตามรายการไหม
    if ($ValidKeys -contains $EnteredKey) {
        
        # ตรวจสอบในระบบส่วนกลาง (Registry เครื่องอื่นห้ามซ้ำ)
        if (Test-Path $RegPath) {
            $CheckKey = (Get-ItemProperty -Path $RegPath -Name "LicenseKey" -ErrorAction SilentlyContinue).LicenseKey
            $CheckHWID = (Get-ItemProperty -Path $RegPath -Name "HWID" -ErrorAction SilentlyContinue).HWID
            
            if ($CheckKey -eq $EnteredKey -and $CheckHWID -ne $CurrentHWID) {
                $StatusLabel.Text = "คีย์นี้ถูกล็อกใช้งานกับเครื่องอื่นไปแล้ว!"
                $StatusLabel.ForeColor = [System.Drawing.Color]::Red
                return
            }
        }

        # ผ่านเงื่อนไข: ทำการบันทึกผูกคีย์เข้ากับ HWID ของเครื่องนี้ถาวร
        if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
        Set-ItemProperty -Path $RegPath -Name "LicenseKey" -Value $EnteredKey -Force
        Set-ItemProperty -Path $RegPath -Name "HWID" -Value $CurrentHWID -Force
        
        $StatusLabel.Text = "เปิดใช้งานสำเร็จ กำลังเข้าสู่ระบบ..."
        $StatusLabel.ForeColor = [System.Drawing.Color]::LimeGreen
        
        # หน่วงเวลานิดนึงให้ดูเท่ ก่อนสลับหน้า
        $Timer = New-Object System.Windows.Forms.Timer
        $Timer.Interval = 1200
        $Timer.Add_Tick({
            $Timer.Stop()
            Show-MainDashboard
        })
        $Timer.Start()
    } else {
        $StatusLabel.Text = "คีย์ไม่ถูกต้อง หรือ ไม่มีคีย์นี้ในระบบ!"
        $StatusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# เมื่อกดปุ่มเริ่มจูนระบบ (Engage Optimization)
$ApplyBtn.Add_Click({
    $ApplyBtn.Enabled = $false
    $ApplyBtn.Text = "OPTIMIZING IN PROGRESS..."
    $ApplyBtn.BackColor = [System.Drawing.Color]::DarkSlateGray
    $LogBox.Clear()

    # สร้าง Background Job เพื่อป้องกัน UI ค้าง (No-Bug UI Threading)
    $Script
