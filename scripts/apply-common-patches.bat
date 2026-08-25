@echo off
setlocal

set "SOURCE_ROOT=%~dp0.."
set "COMMON_DIR=%SOURCE_ROOT%\moonlight-common-c\moonlight-common-c"
set "PATCH_FILE=%SOURCE_ROOT%\patches\0001-rfi-congestion-recovery.patch"

git -C "%COMMON_DIR%" apply --check "%PATCH_FILE%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Applying RFI congestion-recovery patch to moonlight-common-c
    git -C "%COMMON_DIR%" apply "%PATCH_FILE%"
    exit /b %ERRORLEVEL%
)

git -C "%COMMON_DIR%" apply --reverse --check "%PATCH_FILE%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo RFI congestion-recovery patch is already applied
    exit /b 0
)

echo moonlight-common-c does not match the expected pinned revision
git -C "%COMMON_DIR%" diff -- src/ControlStream.c src/VideoDepacketizer.c
exit /b 1
