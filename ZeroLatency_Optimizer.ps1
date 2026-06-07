#Requires -RunAsAdministrator
<#
  Ultimate Zero Latency Optimizer v3.0
  Dark Modern UI — WPF/XAML
  Run: Right-click → Run with PowerShell (as Administrator)
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

# ── XAML UI ────────────────────────────────────────────────────────────────
[xml]$xaml = @"
<Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="Ultimate Zero Latency Optimizer v3.0"
  Width="680" Height="540"
  MinWidth="600" MinHeight="480"
  WindowStartupLocation="CenterScreen"
  Background="#0D1117"
  FontFamily="Segoe UI"
  ResizeMode="CanMinimize">

  <Window.Resources>
    <Style x:Key="StepRow" TargetType="Border">
      <Setter Property="Background" Value="#161B22"/>
      <Setter Property="BorderBrush" Value="#21262D"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="CornerRadius" Value="6"/>
      <Setter Property="Margin" Value="0,0,0,5"/>
      <Setter Property="Padding" Value="12,8"/>
    </Style>
    <Style x:Key="TagBlue" TargetType="Border">
      <Setter Property="Background" Value="#1A3A5C"/>
      <Setter Property="BorderBrush" Value="#1F6FEB"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="CornerRadius" Value="3"/>
      <Setter Property="Padding" Value="5,1"/>
      <Setter Property="Margin" Value="0,0,4,0"/>
    </Style>
    <Style x:Key="TagGreen" TargetType="Border">
      <Setter Property="Background" Value="#0D2818"/>
      <Setter Property="BorderBrush" Value="#238636"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="CornerRadius" Value="3"/>
      <Setter Property="Padding" Value="5,1"/>
      <Setter Property="Margin" Value="0,0,4,0"/>
    </Style>
    <Style x:Key="TagRed" TargetType="Border">
      <Setter Property="Background" Value="#2D1117"/>
      <Setter Property="BorderBrush" Value="#DA3633"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="CornerRadius" Value="3"/>
      <Setter Property="Padding" Value="5,1"/>
      <Setter Property="Margin" Value="0,0,4,0"/>
    </Style>
    <Style x:Key="RunBtn" TargetType="Button">
      <Setter Property="Background" Value="#1F6FEB"/>
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Padding" Value="28,10"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter Property="Background" Value="#388BFD"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter Property="Background" Value="#21262D"/>
                <Setter Property="Foreground" Value="#484F58"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Grid>
    <Grid.RowDefinitions>
      <RowDefinition Height="64"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="56"/>
    </Grid.RowDefinitions>

    <!-- Header -->
    <Border Grid.Row="0" Background="#161B22" BorderBrush="#21262D" BorderThickness="0,0,0,1">
      <Grid Margin="20,0">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <Border Width="36" Height="36" Background="#1A3A5C" BorderBrush="#1F6FEB" BorderThickness="1" CornerRadius="6">
          <TextBlock Text="ZL" Foreground="#58A6FF" FontSize="13" FontWeight="Bold"
                     HorizontalAlignment="Center" VerticalAlignment="Center"/>
        </Border>
        <StackPanel Grid.Column="1" Margin="12,0,0,0" VerticalAlignment="Center">
          <TextBlock Text="ZERO LATENCY OPTIMIZER" Foreground="White" FontSize="14" FontWeight="SemiBold"/>
          <TextBlock Text="No Power Plan Extreme Edition · v3.0" Foreground="#8B949E" FontSize="11" FontFamily="Consolas"/>
        </StackPanel>
        <Border Grid.Column="2" Background="#0D2818" BorderBrush="#238636" BorderThickness="1" CornerRadius="10" Padding="10,3">
          <TextBlock x:Name="StatusBadge" Text="READY" Foreground="#3FB950" FontSize="11" FontFamily="Consolas"/>
        </Border>
      </Grid>
    </Border>

    <!-- Steps List -->
    <ScrollViewer Grid.Row="1" Margin="16,12,16,0" VerticalScrollBarVisibility="Auto">
      <StackPanel x:Name="StepPanel">

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s1Icon" Text="01" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Kernel Timer &amp; CPU Optimization" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="DisableDynamicTick · TSCsync Enhanced · Synthetic Timers" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="+FPS" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r1" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s2Icon" Text="02" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Gaming Priority &amp; Scheduler" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="Win32PrioritySeparation · GPU Priority 8 · SystemResponsiveness 0" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="+FPS" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r2" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s3Icon" Text="03" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Security Mitigations Off" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="Spectre/Meltdown · VBS/Core Isolation OFF — gaming PC only!" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="+FPS" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagRed}"><TextBlock Text="RISK" Foreground="#F85149" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r3" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s4Icon" Text="04" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Keyboard &amp; Mouse Zero Latency" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="Raw Input 1:1 · No USB Suspend · KeyDelay 0 · No Acceleration" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="INPUT" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r4" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s5Icon" Text="05" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="TCP/IP Low-Latency Network" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="TcpAckFreq=1 · NoDelay=1 · RSS · Winsock Reset · DNS Flush" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="PING" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r5" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s6Icon" Text="06" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Graphics, Game Mode &amp; DVR" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="HAGS ON · Game Mode ON · Game DVR/Capture OFF" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="+FPS" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r6" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s7Icon" Text="07" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Memory, Services &amp; System Tweaks" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="Hibernation OFF · Disable junk services · Enable core services" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="SYS" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r7" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

        <Border Style="{StaticResource StepRow}">
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition Width="42"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
            <TextBlock x:Name="s8Icon" Text="08" Foreground="#58A6FF" FontFamily="Consolas" FontSize="12" VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Text="Cleanup &amp; Network Adapter Reset" Foreground="#E6EDF3" FontSize="13"/>
              <TextBlock Text="Clear TEMP/Prefetch · Restart Physical Adapters · Flush DNS" Foreground="#8B949E" FontSize="10" FontFamily="Consolas" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
              <Border Style="{StaticResource TagBlue}"><TextBlock Text="PING" Foreground="#58A6FF" FontSize="10" FontFamily="Consolas"/></Border>
              <Border Style="{StaticResource TagGreen}"><TextBlock Text="SAFE" Foreground="#3FB950" FontSize="10" FontFamily="Consolas"/></Border>
              <TextBlock x:Name="r8" Text="" Foreground="#3FB950" FontSize="14" Margin="8,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
          </Grid>
        </Border>

      </StackPanel>
    </ScrollViewer>

    <!-- Progress -->
    <StackPanel Grid.Row="2" Margin="16,10,16,6">
      <Grid Margin="0,0,0,5">
        <TextBlock x:Name="ProgressLabel" Text="กด RUN เพื่อเริ่มต้น" Foreground="#8B949E" FontSize="11" FontFamily="Consolas"/>
        <TextBlock x:Name="ProgressPct" Text="" Foreground="#58A6FF" FontSize="11" FontFamily="Consolas" HorizontalAlignment="Right"/>
      </Grid>
      <Border Background="#21262D" CornerRadius="3" Height="6">
        <Border x:Name="ProgressBar" Background="#1F6FEB" CornerRadius="3" HorizontalAlignment="Left" Width="0"/>
      </Border>
    </StackPanel>

    <!-- Footer -->
    <Border Grid.Row="3" Background="#161B22" BorderBrush="#21262D" BorderThickness="0,1,0,0">
      <Grid Margin="16,0">
        <TextBlock Text="v3.0 · 8 STEPS · RESTART REQUIRED" Foreground="#484F58"
                   FontSize="11" FontFamily="Consolas" VerticalAlignment="Center"/>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
          <Button x:Name="BtnRun" Content="▶  RUN OPTIMIZER" Style="{StaticResource RunBtn}"/>
        </StackPanel>
      </Grid>
    </Border>
  </Grid>
</Window>
"@

# ── Build Window ────────────────────────────────────────────────────────────
$reader  = [System.Xml.XmlNodeReader]::new($xaml)
$window  = [Windows.Markup.XamlReader]::Load($reader)

$BtnRun       = $window.FindName("BtnRun")
$StatusBadge  = $window.FindName("StatusBadge")
$ProgressBar  = $window.FindName("ProgressBar")
$ProgressLabel= $window.FindName("ProgressLabel")
$ProgressPct  = $window.FindName("ProgressPct")

$resultNodes = @{}
1..8 | ForEach-Object { $resultNodes[$_] = $window.FindName("r$_") }

# Total width for progress bar
$totalWidth = 0
$window.Add_Loaded({ $script:totalWidth = $ProgressBar.Parent.ActualWidth })

# ── Helper: update UI from background thread ────────────────────────────────
function Update-UI([scriptblock]$action) {
    $window.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Normal, $action)
}

function Set-StepDone([int]$step) {
    Update-UI {
        $resultNodes[$step].Text = "✓"
        $pct = [int](($step / 8) * 100)
        $w   = ($step / 8) * $script:totalWidth
        $ProgressBar.Width  = $w
        $ProgressLabel.Text = "Step $step / 8 เสร็จแล้ว..."
        $ProgressPct.Text   = "$pct%"
    }
}

# ── Tweak functions ─────────────────────────────────────────────────────────
function Step1-KernelCPU {
    bcdedit /set disabledynamictick yes  | Out-Null
    bcdedit /set useplatformclock no     | Out-Null
    bcdedit /set tscsyncpolicy Enhanced  | Out-Null
    bcdedit /set synthetictimers yes     | Out-Null
    Set-StepDone 1
}

function Step2-GamingPriority {
    $mp = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
    Set-ItemProperty $mp Win32PrioritySeparation 0x26 -Type DWord -Force
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power" PowerThrottlingOff 1 -Type DWord -Force

    $sp = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Set-ItemProperty $sp NetworkThrottlingIndex 0xffffffff -Type DWord -Force
    Set-ItemProperty $sp SystemResponsiveness 0 -Type DWord -Force

    $gp = "$sp\Tasks\Games"
    if (-not (Test-Path $gp)) { New-Item $gp -Force | Out-Null }
    Set-ItemProperty $gp "GPU Priority"          8      -Type DWord  -Force
    Set-ItemProperty $gp "Priority"              6      -Type DWord  -Force
    Set-ItemProperty $gp "Clock Rate"            0x2710 -Type DWord  -Force
    Set-ItemProperty $gp "Scheduling Category"   "High" -Type String -Force
    Set-ItemProperty $gp "SFIO Priority"         "High" -Type String -Force
    Set-ItemProperty $gp "Background Only"       "False"-Type String -Force
    Set-ItemProperty $gp "Affinity"              0      -Type DWord  -Force

    $ep = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Executive"
    Set-ItemProperty $ep AdditionalCriticalWorkerThreads 2 -Type DWord -Force
    Set-ItemProperty $ep AdditionalDelayedWorkerThreads  2 -Type DWord -Force
    Set-StepDone 2
}

function Step3-SecurityOff {
    $mm = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    Set-ItemProperty $mm FeatureSettingsOverride     3 -Type DWord -Force
    Set-ItemProperty $mm FeatureSettingsOverrideMask 3 -Type DWord -Force
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" EnableVirtualizationBasedSecurity 0 -Type DWord -Force
    Set-StepDone 3
}

function Step4-InputLatency {
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\USB"    DisableSelectiveSuspend 1 -Type DWord -Force
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\HidUsb" IdleEnable              0 -Type DWord -Force

    $kb = "HKCU:\Control Panel\Keyboard"
    Set-ItemProperty $kb KeyboardDelay "0"  -Type String -Force
    Set-ItemProperty $kb KeyboardSpeed "31" -Type String -Force

    $ms = "HKCU:\Control Panel\Mouse"
    Set-ItemProperty $ms MouseSpeed      "0"  -Type String -Force
    Set-ItemProperty $ms MouseThreshold1 "0"  -Type String -Force
    Set-ItemProperty $ms MouseThreshold2 "0"  -Type String -Force
    Set-ItemProperty $ms MouseHoverTime  "0"  -Type String -Force

    Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys"        Flags "506" -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\Keyboard Response" Flags "122" -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\ToggleKeys"        Flags "58"  -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\MouseKeys"         Flags "0"   -Type String -Force
    Set-StepDone 4
}

function Step5-Network {
    netsh int tcp set global autotuninglevel=normal  2>&1 | Out-Null
    netsh int tcp set global rss=enabled             2>&1 | Out-Null
    netsh int tcp set global chimney=disabled        2>&1 | Out-Null
    netsh int tcp set global ecncapability=disabled  2>&1 | Out-Null
    netsh int tcp set global timestamps=disabled     2>&1 | Out-Null
    netsh int tcp set supplemental template=custom icw=10 2>&1 | Out-Null
    netsh int ip set global taskoffload=enabled      2>&1 | Out-Null

    $tp = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    Set-ItemProperty $tp DefaultTTL          64 -Type DWord -Force
    Set-ItemProperty $tp EnablePMTUDiscovery  1 -Type DWord -Force
    Set-ItemProperty $tp EnableRSS            1 -Type DWord -Force
    Set-ItemProperty $tp Tcp1323Opts          1 -Type DWord -Force
    Set-ItemProperty $tp TcpTimedWaitDelay   30 -Type DWord -Force

    $ifPath = "$tp\Interfaces"
    Get-ChildItem $ifPath -ErrorAction SilentlyContinue | ForEach-Object {
        Set-ItemProperty $_.PSPath TcpAckFrequency 1 -Type DWord -Force -EA SilentlyContinue
        Set-ItemProperty $_.PSPath TCPNoDelay      1 -Type DWord -Force -EA SilentlyContinue
        Set-ItemProperty $_.PSPath TcpDelAckTicks  0 -Type DWord -Force -EA SilentlyContinue
    }

    $dp = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    Set-ItemProperty $dp CacheHashTableBucketSize 1     -Type DWord -Force
    Set-ItemProperty $dp MaxCacheEntryTtlLimit    64000 -Type DWord -Force

    netsh winsock reset 2>&1 | Out-Null
    netsh int ip reset  2>&1 | Out-Null
    ipconfig /flushdns  2>&1 | Out-Null
    Set-StepDone 5
}

function Step6-Graphics {
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" HwSchMode 2 -Type DWord -Force
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" AllowAutoGameMode    1 -Type DWord -Force
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" AutoGameModeEnabled  1 -Type DWord -Force

    $dvr = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
    if (-not (Test-Path $dvr)) { New-Item $dvr -Force | Out-Null }
    Set-ItemProperty $dvr AllowGameDVR 0 -Type DWord -Force

    $gc = "HKCU:\System\GameConfigStore"
    Set-ItemProperty $gc GameDVR_Enabled                    0 -Type DWord -Force
    Set-ItemProperty $gc GameDVR_FSEBehaviorMode            2 -Type DWord -Force
    Set-ItemProperty $gc GameDVR_HonorUserFSEBehaviorMode   1 -Type DWord -Force
    Set-ItemProperty $gc GameDVR_DXGIHonorFSEWindowsCompatible 1 -Type DWord -Force
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" AppCaptureEnabled 0 -Type DWord -Force
    Set-StepDone 6
}

function Step7-ServicesMemory {
    $mm = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    Set-ItemProperty $mm ClearPageFileAtShutdown 0 -Type DWord -Force
    Set-ItemProperty $mm LargeSystemCache        0 -Type DWord -Force

    powercfg -h off 2>&1 | Out-Null
    Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name OneDrive -Force -ErrorAction SilentlyContinue

    $disable = "wuauserv","dosvc","DiagTrack","WSearch","MapsBroker",
               "XblAuthManager","XblGameSave","XboxNetApiSvc",
               "Fax","RetailDemo","RemoteRegistry","WerSvc"
    foreach ($s in $disable) {
        Stop-Service $s -Force -ErrorAction SilentlyContinue
        Set-Service  $s -StartupType Disabled -ErrorAction SilentlyContinue
    }

    $enable = "Audiosrv","AudioEndpointBuilder","Dhcp","NlaSvc",
              "Netman","WlanSvc","RpcSs","EventLog","PlugPlay",
              "LanmanWorkstation","LanmanServer"
    foreach ($s in $enable) {
        Set-Service  $s -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service $s -ErrorAction SilentlyContinue
    }
    Set-StepDone 7
}

function Step8-Cleanup {
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue
    Get-NetAdapter | Where-Object { $_.Physical -eq $true } |
        Restart-NetAdapter -Confirm:$false -ErrorAction SilentlyContinue
    Set-StepDone 8
}

# ── RUN Button Handler ──────────────────────────────────────────────────────
$BtnRun.Add_Click({
    $BtnRun.IsEnabled = $false
    $StatusBadge.Text = "RUNNING"
    $StatusBadge.Foreground = "#F0883E"
    $StatusBadge.Parent.BorderBrush = "#9E6A03"
    $StatusBadge.Parent.Background  = "#2D1B00"

    $job = [System.Threading.Thread]::new({
        try {
            Step1-KernelCPU
            Start-Sleep -Milliseconds 300
            Step2-GamingPriority
            Start-Sleep -Milliseconds 300
            Step3-SecurityOff
            Start-Sleep -Milliseconds 300
            Step4-InputLatency
            Start-Sleep -Milliseconds 300
            Step5-Network
            Start-Sleep -Milliseconds 500
            Step6-Graphics
            Start-Sleep -Milliseconds 300
            Step7-ServicesMemory
            Start-Sleep -Milliseconds 400
            Step8-Cleanup
        } catch {}

        Update-UI {
            $StatusBadge.Text = "DONE"
            $StatusBadge.Foreground = "#3FB950"
            $StatusBadge.Parent.BorderBrush = "#238636"
            $StatusBadge.Parent.Background  = "#0D2818"
            $ProgressLabel.Text = "เสร็จสมบูรณ์ทั้ง 8 Steps!"
            $ProgressPct.Text   = "100%"
            $ProgressBar.Width  = $script:totalWidth

            $result = [System.Windows.MessageBox]::Show(
                "✅ ปรับแต่งครบทั้ง 8 Steps แล้ว!`n`nต้องการ Restart เครื่องเดี๋ยวนี้มั้ย?`n(แนะนำให้ Restart เพื่อให้ค่าบางอย่างมีผล)",
                "Zero Latency Optimizer — เสร็จแล้ว",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Question
            )
            if ($result -eq [System.Windows.MessageBoxResult]::Yes) {
                Restart-Computer -Force
            }
        }
    })
    $job.IsBackground = $true
    $job.Start()
})

$window.ShowDialog() | Out-Null
