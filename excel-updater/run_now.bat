@echo off
rem Double-click to check for an approved update now and create the new Excel file.
rem The window shows each step and a check of the new file, and stays open at the end.
title DC Benchmarking - Excel update
if exist "%LOCALAPPDATA%\DCBenchmarking\run_now.bat" (
    call "%LOCALAPPDATA%\DCBenchmarking\run_now.bat"
) else (
    echo The updater is not installed yet. Double-click install.bat first.
    echo.
    pause
)
