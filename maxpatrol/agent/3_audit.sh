#!/bin/bash

# Проверка прав администратора
if [ "$(id -u)" != "0" ]; then
  echo "Этот скрипт должен выполняться от имени root"
  exit 1
fi

# Перемещение архива bin.tar в домашний каталог учетной записи
cp bin.tar /home/moaudit/bin.tar && cd /home/moaudit

# Распаковка архива
tar -xf bin.tar

# Настройка прав доступа к каталогу
chown moaudit -R /home/moaudit/bin
chmod 700 -R /home/moaudit/bin

# Удаление архива
rm bin.tar

# Переименование файла bash_profile на .bash_profile и перемещение его в домашний каталог
cd /home/moaudit/bin && mv bash_profile /home/moaudit/.bash_profile

# Ставим права на весь домашний каталог
chmod 700 /home/moaudit
