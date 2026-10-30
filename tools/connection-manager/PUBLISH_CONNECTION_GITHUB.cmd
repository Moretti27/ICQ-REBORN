@echo off
setlocal
cd /d "%~dp0"
echo Обновление центрального server-config.json в GitHub...
node "%~dp0publish-connection-github.cjs"
if errorlevel 1 (
  echo.
  echo Если GitHub CLI установлен, сначала выполните: gh auth login
  pause
  exit /b 1
)
echo Готово.
pause
