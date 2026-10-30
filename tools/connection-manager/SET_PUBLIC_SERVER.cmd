@echo off
setlocal EnableExtensions
cd /d "%~dp0"
cls
echo ===============================================
echo   ICQ Reborn - общий адрес подключения
echo ===============================================
echo.
set /p "PUBLIC=Новый публичный адрес (http://IP:22005): "
if "%PUBLIC%"=="" exit /b 0
echo.
set /p "LAN=LAN fallback (Enter - оставить текущий): "
if "%LAN%"=="" (
  node "%~dp0set-public-server.cjs" "%PUBLIC%"
) else (
  node "%~dp0set-public-server.cjs" "%PUBLIC%" "%LAN%"
)
if errorlevel 1 (
  echo Ошибка изменения адреса.
  pause
  exit /b 1
)
echo.
echo Готово. Перезапустите Host и затем запустите PUBLISH_CONNECTION_GITHUB.cmd
pause
