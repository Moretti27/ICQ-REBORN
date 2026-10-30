# ICQ Reborn — Connection Manager

Центральный адрес подключения хранится в корневом `server-config.json`.

## Смена IP
1. На Host запустите `SET_PUBLIC_SERVER.cmd`.
2. Укажите новый адрес, например `http://2.27.43.240:22007`.
3. Перезапустите Host.
4. Запустите `PUBLISH_CONNECTION_GITHUB.cmd`.

После публикации старые Android-сборки, которые используют
`https://raw.githubusercontent.com/Moretti27/ICQ-REBORN/main/server-config.json`,
получат новый адрес без переустановки APK.

Windows 0.06.12 не имеет независимого GitHub-bootstrap. Для него нужен переходный
апдейт или однократная смена Host в настройках/миграционным скриптом. После
перехода новые Windows-сборки также должны использовать центральный конфиг.

GitHub token в репозиторий не сохраняется. Для публикации используется
авторизованный GitHub CLI (`gh auth login`) либо временная переменная `GH_TOKEN`.
