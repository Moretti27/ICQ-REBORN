@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title ICQ Reborn Server

cd /d "%~dp0"

rem --- One universal launcher for current and future ICQ Reborn PC Host builds ---
if not exist "server\server.js" (
  echo.
  echo ERROR: server\server.js was not found.
  echo Keep START_SERVER.bat next to the server folder.
  echo.
  pause
  exit /b 1
)

rem --- Elevate automatically when firewall rule is missing ---
netsh advfirewall firewall show rule name="ICQ Reborn Server 22007" >nul 2>nul
if errorlevel 1 (
  net session >nul 2>&1
  if errorlevel 1 (
    echo Requesting Administrator rights for first network setup...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
  )
  echo Adding Windows Firewall rule for TCP 22007...
  netsh advfirewall firewall add rule name="ICQ Reborn Server 22007" dir=in action=allow protocol=TCP localport=22007 >nul
  if errorlevel 1 (
    echo WARNING: could not create the Firewall rule.
  ) else (
    echo Firewall rule created.
  )
)

rem --- Node.js ---
where node >nul 2>nul
if errorlevel 1 (
  echo.
  echo ERROR: Node.js was not found.
  echo Install Node.js 20 or newer, then run START_SERVER.bat again.
  echo.
  pause
  exit /b 1
)

cd /d "%~dp0server"

if not exist "node_modules" (
  echo.
  echo Installing server dependencies...
  call npm install
  if errorlevel 1 (
    echo.
    echo ERROR: npm install failed.
    pause
    exit /b 1
  )
)

set "PORT=22007"
set "LANIP="

for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /C:"IPv4" ^| findstr "192.168.3."') do (
  set "LANIP=%%A"
  goto :got_lan
)
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /C:"IPv4"') do (
  set "LANIP=%%A"
  goto :got_lan
)
:got_lan
if defined LANIP set "LANIP=!LANIP: =!"

echo.
echo ==========================================
echo          ICQ Reborn PC Host
echo ==========================================
echo Port:       22007
echo Local:      http://127.0.0.1:22007
if defined LANIP echo LAN:        http://!LANIP!:22007
echo Public:     http://2.27.43.240:22007
echo Health:     http://2.27.43.240:22007/health
echo Data:       server\data
echo.
echo Router forwarding:
if defined LANIP echo TCP 22007 -^> !LANIP!:22007
if not defined LANIP echo TCP 22007 -^> this PC LAN IPv4:22007
echo.
echo Keep the server\data folder when updating the Host.
echo.
echo YooMoney VIP webhook after server starts:
echo http://2.27.43.240:22007/api/support/yoomoney
echo The notification secret is printed locally by the server below.
echo Configure HTTP notifications in YooMoney once for automatic VIP.
echo Close this window to stop the server.
echo.
echo Starting ICQ Reborn Server...
echo.

node server.js

echo.
echo Server stopped.
pause
