#Requires -Version 5.0
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ===== LOG SAFE =====
function Add-Log($msg, $color="White"){
    Write-Host "[$(Get-Date -f 'HH:mm:ss')] $msg"
}

# ===== TWEAKS =====
$tweaks = @(
    "Disable SysMain / Superfetch",
    "RUN ALL TWEAKS"
)

# ===== CORE FIXED FUNCTION =====
function Invoke-Tweak($name) {
    switch ($name) {

        "Disable SysMain / Superfetch" {
            try {
                Set-Service SysMain -StartupType Disabled -ErrorAction SilentlyContinue
                Stop-Service SysMain -Force -ErrorAction SilentlyContinue
                Add-Log "SysMain disabled"
            } catch {
                Add-Log "SysMain error: $($_.Exception.Message)"
            }
        }

        "RUN ALL TWEAKS" {
            foreach($t in $tweaks){
                if($t -ne "RUN ALL TWEAKS"){
                    try {
                        Invoke-Tweak $t
                    } catch {
                        Add-Log "Error running $t"
                    }
                }
            }
            Add-Log "All tweaks executed"
        }

    }
}

# ===== SIMPLE UI (กันพัง WinForms เดิม) =====
$form = New-Object Windows.Forms.Form
$form.Text = "ZERO LATENCY FIXED"
$form.Size = New-Object Drawing.Size(400,200)

$btn = New-Object Windows.Forms.Button
$btn.Text = "Run Tweaks"
$btn.Size = New-Object Drawing.Size(150,40)
$btn.Location = New-Object Drawing.Point(120,60)

$btn.Add_Click({
    Invoke-Tweak "RUN ALL TWEAKS"
    [System.Windows.Forms.MessageBox]::Show("Done")
})

$form.Controls.Add($btn)
[System.Windows.Forms.Application]::Run($form)
