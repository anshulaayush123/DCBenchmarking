@echo off
rem Double-click to check for an approved update right now instead of waiting for 12:55.
schtasks /Run /TN "DCBenchmarking Excel update"
echo Started. If there was a new approved update, the new Excel file appears in the Claude versions folder within a minute.
pause
