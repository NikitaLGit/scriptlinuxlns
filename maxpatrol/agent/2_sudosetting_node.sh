#!/bin/bash

# Проверка прав администратора
if [ "$(id -u)" != "0" ]; then
  echo "Этот скрипт должен выполняться от имени root"
  exit 1
fi

# Определяем путь к файлу sudoers.txt
sudoers_file="sudoers.txt"

# Проверяем наличие файла sudoers.txt
if [ ! -f "$sudoers_file" ]; then
  echo "Файл $sudoers_file не найден"
  exit 1
fi

# Резервное копирование оригинального файла sudoers
cp /etc/sudoers /etc/sudoers.bak
cp /etc/sudoers /etc/sudoers.test

# Читаем содержимое файла sudoers.txt и заменяем mpuser на moaudit
sed 's/mpuser/moaudit/g' "$sudoers_file" > /tmp/sudoers_temp

# Проверяем наличие директивы Defaults env_reset
grep -q '^Defaults\s*env_reset' /etc/sudoers || echo 'Defaults env_reset' >> /tmp/sudoers_temp

# Удаляем строку с директивой Defaults env_keep, содержащей переменную PATH
sed '/^Defaults\s*env_keep*PATH/d' /tmp/sudoers_temp > /tmp/sudoers_final

# Заменяем оригинальный файл sudoers
cat /tmp/sudoers_final >> /etc/sudoers.test

# Проверяем синтаксис файла sudoers
# visudo -c
#
# if [ $? -eq 0 ]; then
#   echo "Изменения в файле /etc/sudoers.test успешно применены"
# else
#   echo "Ошибка в синтаксисе файла /etc/sudoers"
#   mv /etc/sudoers.bak /etc/sudoers
#   echo "Откат изменений в файле /etc/sudoers"
#   exit 1
# fi

echo "Проверьте в новом файле /etc/sudoers.test, чтобы не было окружения PATH в директиве Default env_keep!"
echo "Если с файлом sudoers.test все ок, то сделай 'mv sudoers.test sudoers'"

# Удаляем временные файлы
rm /tmp/sudoers_temp /tmp/sudoers_final
