#Requires -Version 5.0
# ╔══════════════════════════════════════════════════════════════════════╗
# ║   ULTIMATE ZERO LATENCY v4.4  │  Cyberpunk Dark UI  │  WinForms    ║
# ╚══════════════════════════════════════════════════════════════════════╝
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ═══════════════════════════ COLOR PALETTE ══════════════════════════════
$C = @{
    BG      = [Drawing.Color]::FromArgb(8,   10,  18)
    Panel   = [Drawing.Color]::FromArgb(13,  15,  26)
    Card    = [Drawing.Color]::FromArgb(18,  22,  38)
    Dark    = [Drawing.Color]::FromArgb(28,  32,  52)
    Cyan    = [Drawing.Color]::FromArgb(0,   200, 255)
    CyanDim = [Drawing.Color]::FromArgb(0,    70, 110)
    Green   = [Drawing.Color]::FromArgb(0,   220, 110)
    Yellow  = [Drawing.Color]::FromArgb(255, 200,  40)
    Red     = [Drawing.Color]::FromArgb(255,  65,  65)
    Text    = [Drawing.Color]::FromArgb(185, 210, 255)
    Dim     = [Drawing.Color]::FromArgb(65,   88, 128)
    White   = [Drawing.Color]::White
}

# ═══════════════════════════════ FONTS ══════════════════════════════════
$F = @{
    H1    = New-Object Drawing.Font("Consolas", 14, [Drawing.FontStyle]::Bold)
    Code  = New-Object Drawing.Font("Consolas",  8)
    Tiny  = New-Object Drawing.Font("Consolas",  7)
    UIB   = New-Object Drawing.Font("Segoe UI",  9, [Drawing.FontStyle]::Bold)
    UI    = New-Object Drawing.Font("Segoe UI",  9)
}

# ═════════════════════════ TWEAK DEFINITIONS ════════════════════════════
$tweaks = @(
    @{ Name="Disable Visual FX (Performance Mode)"; Cat="System "; Def=$true  }
    @{ Name="Set Power Plan: High Performance";     Cat="System "; Def=$true  }
    @{ Name="Disable Xbox Game Bar & DVR";          Cat="Gaming "; Def=$true  }
    @{ Name="Enable Hardware GPU Scheduling";       Cat="Gaming "; Def=$false }
    @{ Name="Optimize TCP/IP (AutoTuning)";         Cat="Network"; Def=$true  }
    @{ Name="Flush DNS Cache";                      Cat="Network"; Def=$true  }
    @{ Name="Clear %TEMP% Files";                   Cat="Cleanup"; Def=$true  }
    @{ Name="Clear Prefetch Data";                  Cat="Cleanup"; Def=$false }
    @{ Name="Disable Hibernate (SSD Recommended)"; Cat="Power  "; Def=$false }
    @{ Name="Disable SysMain / Superfetch";         Cat="Service"; Def=$false }
    @{ Name="RUN ALL TWEAKS";                     Cat="Action "; Def=$false }
    @{ Name="Clear ALL Temp";                     Cat="Action "; Def=$false }
)

# ══════════════════════════ APPLY FUNCTIONS ════════════════════════════
function Invoke-Tweak($name) {
    switch ($name) {
        "Disable Visual FX (Performance Mode)" {
            try {
                $k = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                if (-not (Test-Path $k)) { New-Item $k -Force | Out-Null }
                Set-ItemProperty $k VisualFXSetting 2
                # SystemParametersInfo SPI_SETANIMATION
                $k2 = "HKCU:\Control Panel\Desktop\WindowMetrics"
                Set-ItemProperty "HKCU:\Control Panel\Desktop" "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary -EA SilentlyContinue
                Add-Log "Visual FX → Performance mode" Green
            } catch { Add-Log "Visual FX: $($_.Exception.Message)" Red }
        }
        "Set Power Plan: High Performance" {
            try {
                $r = powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1
                if ($LASTEXITCODE -ne 0) {
                    # Try creating it if not present
                    powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1 | Out-Null
                    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1 | Out-Null
                }
                Add-Log "Power Plan → High Performance activated" Green
            } catch { Add-Log "Power Plan: $($_.Exception.Message)" Red }
        }
        "Disable Xbox Game Bar & DVR" {
            try {
                $k = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
                if (Test-Path $k) { Set-ItemProperty $k AppCaptureEnabled 0 -EA SilentlyContinue }
                Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_Enabled 0 -EA SilentlyContinue
                Add-Log "Xbox Game Bar & DVR disabled" Green
            } catch { Add-Log "Game Bar: $($_.Exception.Message)" Red }
        }
        "Enable Hardware GPU Scheduling" {
            try {
                $k = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
                Set-ItemProperty $k HwSchMode 2 -EA SilentlyContinue
                Add-Log "Hardware GPU Scheduling enabled (⚠ reboot required)" Yellow
            } catch { Add-Log "GPU Sched: $($_.Exception.Message)" Red }
        }
        "Optimize TCP/IP (AutoTuning)" {
            try {
                netsh int tcp set global autotuninglevel=normal 2>&1 | Out-Null
                netsh int tcp set global ecncapability=enabled 2>&1 | Out-Null
                netsh int tcp set global timestamps=disabled 2>&1 | Out-Null
                Add-Log "TCP/IP optimized (AutoTuning=Normal, ECN, no timestamps)" Green
            } catch { Add-Log "TCP/IP: $($_.Exception.Message)" Red }
        }
        "Flush DNS Cache" {
            try {
                ipconfig /flushdns 2>&1 | Out-Null
                Add-Log "DNS cache flushed" Green
            } catch { Add-Log "DNS flush: $($_.Exception.Message)" Red }
        }
        "Clear %TEMP% Files" {
            try {
                $n = 0
                @($env:TEMP, $env:TMP, "C:\Windows\Temp") | ForEach-Object {
                    if (Test-Path $_) {
                        Get-ChildItem $_ -Recurse -Force -EA SilentlyContinue |
                            Where-Object { !$_.PSIsContainer } | ForEach-Object {
                                try { Remove-Item $_.FullName -Force -EA Stop; $n++ } catch {}
                            }
                    }
                }
                Add-Log "Temp files cleared ($n files removed)" Green
            } catch { Add-Log "Temp: $($_.Exception.Message)" Red }
        }
        "Clear Prefetch Data" {
            try {
                $files = Get-ChildItem "C:\Windows\Prefetch" -Filter "*.pf" -EA SilentlyContinue
                $n = ($files | Measure-Object).Count
                $files | ForEach-Object { try { Remove-Item $_.FullName -Force -EA Stop } catch {} }
                Add-Log "Prefetch cleared ($n .pf files removed)" Green
            } catch { Add-Log "Prefetch: $($_.Exception.Message)" Red }
        }
        "Disable Hibernate (SSD Recommended)" {
            try {
                powercfg /hibernate off 2>&1 | Out-Null
                Add-Log "Hibernate disabled (hiberfil.sys freed)" Green
            } catch { Add-Log "Hibernate: $($_.Exception.Message)" Red }
        }
        "Disable SysMain / Superfetch" {
            try {
                Set-Service SysMain -StartupType Disabled -EA SilentlyContinue
                Stop-Service SysMain -Force -EA SilentlyContinue
                Add-Log "SysMain service disabled (⚠ not recommended on HDD)" Yellow
            } catch { Add-Log "SysMain: $($_.Exception.Message)" Red }
        
        "RUN ALL TWEAKS" {
            foreach($t in $tweaks){
                if($t.Name -notin @("RUN ALL TWEAKS","Clear ALL Temp")){
                    try { Invoke-Tweak $t.Name } catch {}
                }
            }
            Add-Log "All tweaks executed." Green
        }
        "Clear ALL Temp" {
            try {
                $n = 0
                @($env:TEMP,$env:TMP,"C:\Windows\Temp") | ForEach-Object {
                    if(Test-Path $_){
                        Get-ChildItem $_ -Recurse -Force -EA SilentlyContinue | ForEach-Object {
                            try {
                                Remove-Item $_.FullName -Force -Recurse -EA Stop
                                $n++
                            } catch {}
                        }
                    }
                }
                Add-Log "ALL TEMP CLEANED ($n items removed)" Green
            } catch {
                Add-Log "Temp: $($_.Exception.Message)" Red
            }
        }
}
    }
}

function Invoke-Restore($name) {
    switch ($name) {
        "Disable Visual FX (Performance Mode)" {
            try {
                Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" VisualFXSetting 0 -EA SilentlyContinue
                Add-Log "Visual FX → restored to Windows default" Yellow
            } catch {}
        }
        "Set Power Plan: High Performance" {
            try {
                powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>&1 | Out-Null
                Add-Log "Power Plan → Balanced (default)" Yellow
            } catch {}
        }
        "Disable Xbox Game Bar & DVR" {
            try {
                $k = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
                if (Test-Path $k) { Set-ItemProperty $k AppCaptureEnabled 1 -EA SilentlyContinue }
                Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_Enabled 1 -EA SilentlyContinue
                Add-Log "Xbox Game Bar re-enabled" Yellow
            } catch {}
        }
        "Enable Hardware GPU Scheduling" {
            try {
                Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" HwSchMode 1 -EA SilentlyContinue
                Add-Log "GPU Scheduling → default (⚠ reboot required)" Yellow
            } catch {}
        }
        "Optimize TCP/IP (AutoTuning)" {
            try {
                netsh int tcp set global autotuninglevel=normal 2>&1 | Out-Null
                Add-Log "TCP/IP settings restored to normal" Yellow
            } catch {}
        }
        "Disable SysMain / Superfetch" {
            try {
                Set-Service SysMain -StartupType Automatic -EA SilentlyContinue
                Start-Service SysMain -EA SilentlyContinue
                Add-Log "SysMain service re-enabled" Yellow
            } catch {}
        }
        "Disable Hibernate (SSD Recommended)" {
            try {
                powercfg /hibernate on 2>&1 | Out-Null
                Add-Log "Hibernate re-enabled" Yellow
            } catch {}
        }
        default { Add-Log "$name → no restore action needed" Dim }
    }
}

# ════════════════════════════ MAIN FORM ═════════════════════════════════
$form = New-Object Windows.Forms.Form
$form.Text            = "ULTIMATE ZERO LATENCY v4.4"
$form.ClientSize      = [Drawing.Size]::new(860, 640)
$form.StartPosition   = "CenterScreen"
$form.BackColor       = $C.BG
$form.ForeColor       = $C.Text
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox     = $false
$form.Font            = $F.UI

# ── HEADER ───────────────────────────────────────────────────────────────
$pHdr = New-Object Windows.Forms.Panel
$pHdr.Size      = [Drawing.Size]::new(860, 72)
$pHdr.Location  = [Drawing.Point]::new(0, 0)
$pHdr.BackColor = $C.Panel

$pHdr.Add_Paint({
    param($s,$e); $g = $e.Graphics
    $g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
    # Accent gradient line at top
    $br = New-Object Drawing.Drawing2D.LinearGradientBrush(
        [Drawing.Rectangle]::new(0,0,$s.Width,3),
        [Drawing.Color]::FromArgb(0,190,255), [Drawing.Color]::FromArgb(0,50,180), 0.0)
    $g.FillRectangle($br, 0, 0, $s.Width, 3); $br.Dispose()
    # Left glow
    $br2 = New-Object Drawing.Drawing2D.LinearGradientBrush(
        [Drawing.Rectangle]::new(0,3,130,$s.Height),
        [Drawing.Color]::FromArgb(18,0,170,240), [Drawing.Color]::Transparent, 0.0)
    $g.FillRectangle($br2, 0, 3, 130, $s.Height); $br2.Dispose()
    # Left accent bar
    $g.FillRectangle([Drawing.SolidBrush]::new($C.Cyan), 0, 3, 3, $s.Height-3)
    # Bottom border
    $g.DrawLine([Drawing.Pen]::new($C.CyanDim, 1), 0, $s.Height-1, $s.Width, $s.Height-1)
    # Title
    $g.DrawString("  ⚡ ZERO LATENCY", $F.H1, [Drawing.SolidBrush]::new($C.Cyan), 10, 10)
    $g.DrawString("     ULTIMATE PERFORMANCE OPTIMIZER  //  v4.4  //  WINDOWS 10 FRAMEWORK",
        $F.Tiny, [Drawing.SolidBrush]::new($C.Dim), 10, 46)
})
$form.Controls.Add($pHdr)

# Header: CPU badge
$lblCPUStat = New-Object Windows.Forms.Label
$lblCPUStat.Text      = "CPU  ░░░░░░░░░░  0%"
$lblCPUStat.Font      = $F.Tiny
$lblCPUStat.ForeColor = $C.Green
$lblCPUStat.BackColor = [Drawing.Color]::FromArgb(15, 0, 220, 110)
$lblCPUStat.Size      = [Drawing.Size]::new(145, 18)
$lblCPUStat.Location  = [Drawing.Point]::new(545, 20)
$lblCPUStat.TextAlign = "MiddleCenter"
$pHdr.Controls.Add($lblCPUStat)

# Header: RAM badge
$lblRAMStat = New-Object Windows.Forms.Label
$lblRAMStat.Text      = "RAM  --/-- GB"
$lblRAMStat.Font      = $F.Tiny
$lblRAMStat.ForeColor = $C.Yellow
$lblRAMStat.BackColor = [Drawing.Color]::FromArgb(15, 255, 200, 40)
$lblRAMStat.Size      = [Drawing.Size]::new(145, 18)
$lblRAMStat.Location  = [Drawing.Point]::new(700, 20)
$lblRAMStat.TextAlign = "MiddleCenter"
$pHdr.Controls.Add($lblRAMStat)

# Header: status dot
$lblStatusDot = New-Object Windows.Forms.Label
$lblStatusDot.Text      = "●  INITIALIZING..."
$lblStatusDot.Font      = $F.Tiny
$lblStatusDot.ForeColor = $C.Yellow
$lblStatusDot.BackColor = $C.Panel
$lblStatusDot.AutoSize  = $true
$lblStatusDot.Location  = [Drawing.Point]::new(545, 48)
$pHdr.Controls.Add($lblStatusDot)

# ── TICKER BAR ────────────────────────────────────────────────────────────
$pTicker = New-Object Windows.Forms.Panel
$pTicker.Size      = [Drawing.Size]::new(860, 24)
$pTicker.Location  = [Drawing.Point]::new(0, 72)
$pTicker.BackColor = [Drawing.Color]::FromArgb(10, 12, 22)

$lblTicker = New-Object Windows.Forms.Label
$lblTicker.Text      = "Loading system information..."
$lblTicker.Font      = $F.Tiny
$lblTicker.ForeColor = $C.Dim
$lblTicker.BackColor = [Drawing.Color]::FromArgb(10, 12, 22)
$lblTicker.Size      = [Drawing.Size]::new(850, 24)
$lblTicker.Location  = [Drawing.Point]::new(6, 4)
$pTicker.Controls.Add($lblTicker)
$form.Controls.Add($pTicker)

# ── LEFT PANEL: TWEAKS ────────────────────────────────────────────────────
$pLeft = New-Object Windows.Forms.Panel
$pLeft.Size      = [Drawing.Size]::new(380, 275)
$pLeft.Location  = [Drawing.Point]::new(10, 103)
$pLeft.BackColor = $C.Card

$pLeft.Add_Paint({
    param($s,$e); $g = $e.Graphics
    $g.DrawRectangle([Drawing.Pen]::new($C.CyanDim, 1), 0, 0, $s.Width-1, $s.Height-1)
    $g.FillRectangle([Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(210, 18, 22, 38)), 0, 0, $s.Width, 22)
    $g.DrawLine([Drawing.Pen]::new($C.CyanDim, 1), 0, 22, $s.Width, 22)
    $g.DrawString("  ▸ TWEAK SELECTION", $F.Code, [Drawing.SolidBrush]::new($C.Cyan), 4, 4)
})

$clb = New-Object Windows.Forms.CheckedListBox
$clb.Size        = [Drawing.Size]::new(358, 246)
$clb.Location    = [Drawing.Point]::new(11, 24)
$clb.BackColor   = $C.Card
$clb.ForeColor   = $C.Text
$clb.Font        = $F.UI
$clb.BorderStyle = "None"
$clb.CheckOnClick = $true

foreach ($t in $tweaks) {
    $idx = $clb.Items.Add("[$($t.Cat)]  $($t.Name)")
    $clb.SetItemChecked($idx, $t.Def)
}
$pLeft.Controls.Add($clb)
$form.Controls.Add($pLeft)

# ── RIGHT PANEL: SYSTEM INFO ──────────────────────────────────────────────
$pRight = New-Object Windows.Forms.Panel
$pRight.Size      = [Drawing.Size]::new(450, 275)
$pRight.Location  = [Drawing.Point]::new(400, 103)
$pRight.BackColor = $C.Card

$pRight.Add_Paint({
    param($s,$e); $g = $e.Graphics
    $g.DrawRectangle([Drawing.Pen]::new($C.CyanDim, 1), 0, 0, $s.Width-1, $s.Height-1)
    $g.FillRectangle([Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(210, 18, 22, 38)), 0, 0, $s.Width, 22)
    $g.DrawLine([Drawing.Pen]::new($C.CyanDim, 1), 0, 22, $s.Width, 22)
    $g.DrawString("  ▸ SYSTEM INFORMATION", $F.Code, [Drawing.SolidBrush]::new($C.Cyan), 4, 4)
})

function Add-InfoRow($parent, $label, $value, $y, $valColor) {
    $lL = New-Object Windows.Forms.Label
    $lL.Text = $label; $lL.Font = $F.Tiny; $lL.ForeColor = $C.Dim
    $lL.BackColor = $C.Card; $lL.Location = [Drawing.Point]::new(12, $y)
    $lL.Size = [Drawing.Size]::new(68, 16)
    $lV = New-Object Windows.Forms.Label
    $lV.Text = $value; $lV.Font = $F.Code; $lV.ForeColor = $valColor
    $lV.BackColor = $C.Card; $lV.Location = [Drawing.Point]::new(84, $y)
    $lV.Size = [Drawing.Size]::new(355, 16)
    $parent.Controls.AddRange(@($lL, $lV))
    return $lV
}

# Gather system info
try { $osObj  = Get-CimInstance Win32_OperatingSystem -EA Stop } catch { $osObj = $null }
try { $cpuObj = Get-CimInstance Win32_Processor       -EA Stop | Select-Object -First 1 } catch { $cpuObj = $null }
try { $gpuObj = Get-CimInstance Win32_VideoController -EA Stop | Select-Object -First 1 } catch { $gpuObj = $null }
try { $diskC  = Get-PSDrive C -EA Stop } catch { $diskC = $null }

$siOS   = if ($osObj)  { $osObj.Caption -replace "Microsoft ", "" }   else { "Unknown" }
$siCPU  = if ($cpuObj) { $cpuObj.Name.Trim() -replace "\s+"," " }     else { "Unknown" }
$siCPU  = $siCPU -replace "\(TM\)|\(R\)", ""
$siRAM  = if ($osObj)  { "$([math]::Round($osObj.TotalVisibleMemorySize/1MB,1)) GB total" } else { "N/A" }
$siGPU  = if ($gpuObj) { $gpuObj.Caption }                            else { "Unknown" }
$siDisk = if ($diskC)  { "C: $([math]::Round($diskC.Used/1GB,1)) GB used / $([math]::Round(($diskC.Used+$diskC.Free)/1GB,0)) GB" } else { "N/A" }
try { $uptime = (Get-Date) - $osObj.LastBootUpTime; $siUp = "$($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m" } catch { $siUp = "N/A" }

$y0 = 30
Add-InfoRow $pRight "HOST"    $env:COMPUTERNAME                    $y0       $C.White      | Out-Null; $y0 += 26
Add-InfoRow $pRight "USER"    $env:USERNAME                         $y0       $C.Text       | Out-Null; $y0 += 26
Add-InfoRow $pRight "OS"      $siOS                                $y0       $C.Text       | Out-Null; $y0 += 26
Add-InfoRow $pRight "ARCH"    $env:PROCESSOR_ARCHITECTURE          $y0       $C.Dim        | Out-Null; $y0 += 26
Add-InfoRow $pRight "CPU"     $siCPU                               $y0       $C.Cyan       | Out-Null; $y0 += 26
Add-InfoRow $pRight "RAM"     $siRAM                               $y0       $C.Green      | Out-Null; $y0 += 26
Add-InfoRow $pRight "GPU"     $siGPU                               $y0       $C.Yellow     | Out-Null; $y0 += 26

$sep = New-Object Windows.Forms.Panel
$sep.Location = [Drawing.Point]::new(12, $y0); $sep.Size = [Drawing.Size]::new(425, 1)
$sep.BackColor = $C.CyanDim
$pRight.Controls.Add($sep); $y0 += 8

Add-InfoRow $pRight "DISK"    $siDisk                              $y0       $C.Text       | Out-Null; $y0 += 26
Add-InfoRow $pRight "UPTIME"  $siUp                                $y0       $C.Cyan       | Out-Null

$form.Controls.Add($pRight)

# ── LOG PANEL ─────────────────────────────────────────────────────────────
$pLog = New-Object Windows.Forms.Panel
$pLog.Size      = [Drawing.Size]::new(840, 160)
$pLog.Location  = [Drawing.Point]::new(10, 386)
$pLog.BackColor = $C.Card

$pLog.Add_Paint({
    param($s,$e); $g = $e.Graphics
    $g.DrawRectangle([Drawing.Pen]::new($C.CyanDim, 1), 0, 0, $s.Width-1, $s.Height-1)
    $g.FillRectangle([Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(210, 18, 22, 38)), 0, 0, $s.Width, 22)
    $g.DrawLine([Drawing.Pen]::new($C.CyanDim, 1), 0, 22, $s.Width, 22)
    $g.DrawString("  ▸ OPERATION LOG", $F.Code, [Drawing.SolidBrush]::new($C.Cyan), 4, 4)
})

$rtLog = New-Object Windows.Forms.RichTextBox
$rtLog.Size        = [Drawing.Size]::new(820, 130)
$rtLog.Location    = [Drawing.Point]::new(10, 26)
$rtLog.BackColor   = $C.BG
$rtLog.ForeColor   = $C.Text
$rtLog.Font        = $F.Code
$rtLog.BorderStyle = "None"
$rtLog.ReadOnly    = $true
$rtLog.ScrollBars  = "Vertical"
$rtLog.WordWrap    = $false
$pLog.Controls.Add($rtLog)
$form.Controls.Add($pLog)

function Add-Log($msg, $colorKey = "Text") {
    $rtLog.SelectionStart  = $rtLog.TextLength
    $rtLog.SelectionLength = 0
    $rtLog.SelectionColor  = $C.Dim
    $rtLog.AppendText("[$(Get-Date -f 'HH:mm:ss')] ")
    $rtLog.SelectionColor  = $C[$colorKey]
    $rtLog.AppendText("$msg`n")
    $rtLog.ScrollToCaret()
}

# ── PROGRESS BAR ──────────────────────────────────────────────────────────
$pPB = New-Object Windows.Forms.Panel
$pPB.Size      = [Drawing.Size]::new(840, 22)
$pPB.Location  = [Drawing.Point]::new(10, 554)
$pPB.BackColor = $C.Dark

$pb = New-Object Windows.Forms.ProgressBar
$pb.Size      = [Drawing.Size]::new(840, 22)
$pb.Location  = [Drawing.Point]::new(0, 0)
$pb.Style     = "Continuous"
$pb.Value     = 0
$pb.ForeColor = $C.Cyan
$pb.BackColor = $C.Dark
$pPB.Controls.Add($pb)
$form.Controls.Add($pPB)

# ── PROGRESS LABEL overlay ────────────────────────────────────────────────
$lblPct = New-Object Windows.Forms.Label
$lblPct.Text      = "0%"
$lblPct.Font      = $F.Tiny
$lblPct.ForeColor = $C.Cyan
$lblPct.BackColor = $C.Dark
$lblPct.AutoSize  = $true
$lblPct.Location  = [Drawing.Point]::new(812, 558)
$form.Controls.Add($lblPct)

# ── BUTTONS ───────────────────────────────────────────────────────────────
function New-FlatBtn($text, $x, $y, $w, $h, $bg, $fg) {
    $b = New-Object Windows.Forms.Button
    $b.Text = $text; $b.Size = [Drawing.Size]::new($w, $h); $b.Location = [Drawing.Point]::new($x, $y)
    $b.FlatStyle = "Flat"; $b.FlatAppearance.BorderColor = $fg; $b.FlatAppearance.BorderSize = 1
    $b.BackColor = $bg; $b.ForeColor = $fg; $b.Font = $F.UIB
    $b.Cursor = [Windows.Forms.Cursors]::Hand
    $b.FlatAppearance.MouseOverBackColor  = [Drawing.Color]::FromArgb(40, $fg.R, $fg.G, $fg.B)
    $b.FlatAppearance.MouseDownBackColor  = [Drawing.Color]::FromArgb(70, $fg.R, $fg.G, $fg.B)
    return $b
}

$btnApply   = New-FlatBtn "⚡  APPLY OPTIMIZATION"   10 584 410 44 ([Drawing.Color]::FromArgb(0,  30, 55)) $C.Cyan
$btnRestore = New-FlatBtn "↩  RESTORE DEFAULTS"     440 584 410 44 ([Drawing.Color]::FromArgb(50, 28,  8)) $C.Yellow

# ── APPLY CLICK ───────────────────────────────────────────────────────────
$btnApply.Add_Click({
    $sel = @(); for ($i=0; $i -lt $clb.Items.Count; $i++) { if ($clb.GetItemChecked($i)) { $sel += $tweaks[$i].Name } }
    if ($sel.Count -eq 0) { Add-Log "No tweaks selected." Yellow; return }

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        $r = [Windows.Forms.MessageBox]::Show(
            "Some tweaks require Administrator privileges.`nContinue anyway (partial apply)?",
            "ZERO LATENCY", [Windows.Forms.MessageBoxButtons]::YesNo, [Windows.Forms.MessageBoxIcon]::Warning)
        if ($r -ne "Yes") { return }
    }

    $btnApply.Enabled = $false; $btnRestore.Enabled = $false
    $pb.Value = 0; $step = [math]::Max(1, [math]::Floor(100 / $sel.Count))
    $lblStatusDot.ForeColor = $C.Yellow; $lblStatusDot.Text = "⚙  APPLYING..."
    Add-Log ("═" * 46) Dim
    Add-Log "APPLY — $($sel.Count) tweak(s) selected" Cyan
    Add-Log ("─" * 46) Dim

    $i = 0
    foreach ($name in $sel) {
        Add-Log "» $name" Text
        Invoke-Tweak $name
        $i++; $v = [math]::Min(100, $step * $i); $pb.Value = $v; $lblPct.Text = "$v%"
        $form.Refresh(); Start-Sleep -Milliseconds 120
    }

    $pb.Value = 100; $lblPct.Text = "100%"
    Add-Log ("─" * 46) Dim
    Add-Log "COMPLETE — All tweaks applied." Green
    $lblStatusDot.ForeColor = $C.Green; $lblStatusDot.Text = "●  OPTIMIZED"
    $btnApply.Enabled = $true; $btnRestore.Enabled = $true

    [Windows.Forms.MessageBox]::Show(
        "Optimization complete!`n$($sel.Count) tweak(s) applied successfully.",
        "ZERO LATENCY v4.4", [Windows.Forms.MessageBoxButtons]::OK,
        [Windows.Forms.MessageBoxIcon]::Information)
})

# ── RESTORE CLICK ─────────────────────────────────────────────────────────
$btnRestore.Add_Click({
    $r = [Windows.Forms.MessageBox]::Show(
        "Restore checked tweaks to Windows defaults?",
        "ZERO LATENCY v4.4", [Windows.Forms.MessageBoxButtons]::YesNo,
        [Windows.Forms.MessageBoxIcon]::Warning)
    if ($r -ne "Yes") { return }

    $sel = @(); for ($i=0; $i -lt $clb.Items.Count; $i++) { if ($clb.GetItemChecked($i)) { $sel += $tweaks[$i].Name } }
    $btnApply.Enabled = $false; $btnRestore.Enabled = $false
    $pb.Value = 0; $step = if ($sel.Count -gt 0) { [math]::Floor(100 / $sel.Count) } else { 100 }
    $lblStatusDot.ForeColor = $C.Yellow; $lblStatusDot.Text = "⚙  RESTORING..."
    Add-Log ("═" * 46) Dim
    Add-Log "RESTORE — $($sel.Count) tweak(s)" Yellow
    Add-Log ("─" * 46) Dim

    $i = 0
    foreach ($name in $sel) {
        Invoke-Restore $name
        $i++; $v = [math]::Min(100, $step * $i); $pb.Value = $v; $lblPct.Text = "$v%"
        $form.Refresh(); Start-Sleep -Milliseconds 100
    }

    $pb.Value = 100; $lblPct.Text = "100%"
    Add-Log ("─" * 46) Dim
    Add-Log "COMPLETE — Defaults restored." Yellow
    $lblStatusDot.ForeColor = $C.Green; $lblStatusDot.Text = "●  SYSTEM READY"
    $btnApply.Enabled = $true; $btnRestore.Enabled = $true

    [Windows.Forms.MessageBox]::Show("Defaults restored successfully!",
        "ZERO LATENCY v4.4", [Windows.Forms.MessageBoxButtons]::OK,
        [Windows.Forms.MessageBoxIcon]::Information)
})

$form.Controls.AddRange(@($btnApply, $btnRestore))

# ── LIVE STATS TIMER ──────────────────────────────────────────────────────
$timer = New-Object Windows.Forms.Timer
$timer.Interval = 2500
$timer.Add_Tick({
    try {
        $cpuPct = [int](Get-CimInstance Win32_Processor -EA Stop |
            Measure-Object -Property LoadPercentage -Average).Average
        $filled  = [math]::Floor($cpuPct / 10)
        $bar     = ("█" * $filled) + ("░" * (10 - $filled))
        $lblCPUStat.Text = "CPU  $bar  $cpuPct%"
        $lblCPUStat.ForeColor = if ($cpuPct -gt 80) { $C.Red } elseif ($cpuPct -gt 50) { $C.Yellow } else { $C.Green }

        $os      = Get-CimInstance Win32_OperatingSystem -EA Stop
        $used    = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 1)
        $total   = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $ramPct  = [int](($used / $total) * 100)
        $lblRAMStat.Text = "RAM  $used / $total GB"
        $lblRAMStat.ForeColor = if ($ramPct -gt 85) { $C.Red } elseif ($ramPct -gt 65) { $C.Yellow } else { $C.Green }

        $lblTicker.Text = "$(Get-Date -f 'yyyy-MM-dd  HH:mm:ss')   │   HOST: $env:COMPUTERNAME   │   USER: $env:USERNAME   │   CPU: $cpuPct%   │   RAM: ${used}/${total} GB   │   OS: $siOS"
    } catch { }
})
$timer.Start()

# ── STARTUP ───────────────────────────────────────────────────────────────
$form.Add_Shown({
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)

    Add-Log "ZERO LATENCY v4.4 initialized" Cyan
    Add-Log "Host: $env:COMPUTERNAME   User: $env:USERNAME" Text
    Add-Log "CPU: $siCPU" Text
    Add-Log "RAM: $siRAM   GPU: $siGPU" Text
    if ($isAdmin) {
        Add-Log "Privilege: Administrator  ✓  All tweaks available" Green
        $lblStatusDot.ForeColor = $C.Green; $lblStatusDot.Text = "●  SYSTEM READY"
    } else {
        Add-Log "WARNING: Not running as Administrator — some tweaks may fail" Yellow
        Add-Log "Tip: Right-click script → Run with PowerShell as Admin" Dim
        $lblStatusDot.ForeColor = $C.Yellow; $lblStatusDot.Text = "⚠  NO ADMIN"
    }
    Add-Log "Select tweaks above, then click Apply Optimization." Dim
})

# ── CLEANUP ───────────────────────────────────────────────────────────────
$form.Add_FormClosing({ $timer.Stop(); $timer.Dispose() })

[Windows.Forms.Application]::Run($form)
