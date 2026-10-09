# Installs the DC benchmarking Excel updater for the current Windows user.
# Run it by double-clicking install.bat in the same folder. No admin rights needed.

$ErrorActionPreference = 'Stop'
$TaskName  = 'DCBenchmarking Excel update'
$InstallTo = Join-Path $env:LOCALAPPDATA 'DCBenchmarking'
$OutputDir = 'C:\Users\AnshulApurva_\OneDrive - Data Volt Investment LLC\Desktop\Anshul + Usamah\Internal Strategy materials\DCs Bechmarking exercise\Claude versions'

Write-Host ''
Write-Host '== DC benchmarking Excel updater: install ==' -ForegroundColor Cyan

# 1. Find Python.
$python = $null
foreach ($candidate in @('python', 'py')) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
        $python = (& $candidate -c 'import sys; print(sys.executable)').Trim()
        if ($python) { break }
    }
}
if (-not $python) { throw 'Python was not found. Install it from python.org first, ticking "Add python.exe to PATH".' }
$pythonw = Join-Path (Split-Path $python) 'pythonw.exe'
if (-not (Test-Path $pythonw)) { $pythonw = $python }
Write-Host "Python: $python"

# 2. Make sure the Excel library is installed.
& $python -m pip install --quiet --disable-pip-version-check openpyxl
if ($LASTEXITCODE -ne 0) { throw 'Could not install openpyxl with pip.' }

# 3. Copy the script to a fixed place.
New-Item -ItemType Directory -Force -Path $InstallTo | Out-Null
Copy-Item -Force (Join-Path $PSScriptRoot 'update_excel.py') $InstallTo
$script = Join-Path $InstallTo 'update_excel.py'
Write-Host "Script: $script"

# 3b. A "run now" file that shows progress in a window, plus a Desktop shortcut to it.
$runNow = Join-Path $InstallTo 'run_now.bat'
Set-Content -Path $runNow -Encoding ASCII -Value @(
    '@echo off',
    'title DC Benchmarking - Excel update',
    "`"$python`" `"$script`"",
    'echo.',
    'pause'
)
$desktop = [Environment]::GetFolderPath('Desktop')
$shell = New-Object -ComObject WScript.Shell
$link = $shell.CreateShortcut((Join-Path $desktop 'Update DC Benchmarking Excel.lnk'))
$link.TargetPath = $runNow
$link.WorkingDirectory = $InstallTo
$link.Description = 'Check for an approved update and create the new Excel file now'
$link.Save()
Write-Host "Desktop shortcut: 'Update DC Benchmarking Excel'"

# 4. Check the output folder and that a starting workbook is in it.
if (-not (Test-Path $OutputDir)) { throw "Folder not found: $OutputDir" }
if (-not (Get-ChildItem -Path $OutputDir -Filter '*.xlsx' | Where-Object { $_.Name -notlike '~$*' })) {
    Write-Host ''
    Write-Host 'WARNING: no Excel file in the Claude versions folder yet.' -ForegroundColor Yellow
    Write-Host 'Copy DC_benchmarking_06092026_v1_Raw_data.xlsx into it; updates start from that file.' -ForegroundColor Yellow
}

# 5. Schedule a daily run. If the laptop is off at 12:55, it runs as soon as it is on again.
$action   = New-ScheduledTaskAction -Execute $pythonw -Argument "`"$script`"" -WorkingDirectory $InstallTo
$trigger  = New-ScheduledTaskTrigger -Daily -At '12:55'
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries `
            -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings `
    -Description 'Creates a new DC benchmarking Excel version after an approved data update.' -Force | Out-Null
Write-Host "Scheduled task '$TaskName' created (daily at 12:55)."

# 6. First run: remembers today's approved data as the starting point.
& $python $script
if ($LASTEXITCODE -ne 0) { throw "First run failed. See $InstallTo\update_excel.log" }

Write-Host ''
Write-Host 'Done. After you merge a data update on GitHub, a new file appears in:' -ForegroundColor Green
Write-Host "  $OutputDir"
Write-Host "It runs by itself daily at 12:55. To run it now and watch each step, double-click"
Write-Host "'Update DC Benchmarking Excel' on your Desktop."
Write-Host "Log file: $InstallTo\update_excel.log"
