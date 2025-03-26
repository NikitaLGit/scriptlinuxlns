#!/bin/bash

# Проверка прав администратора
if [ "$(id -u)" != "0" ]; then
  echo "Этот скрипт должен выполняться от имени root"
  exit 1
fi

# Создание учетной записи
useradd -m -g users -s /bin/bash moaudit

# Установка пароля для новой учетной записи
echo "Придумайте пароль: "
passwd moaudit

echo "Учетная запись moaudit создана и настроена!"

# Конец первого скрипта. Начало второго
n=5
while true; do
    sleep 1
    echo "Следующий скрипт через $((n-SECONDS)) секунд"
done

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

# Удаляем временные файлы
rm /tmp/sudoers_temp /tmp/sudoers_final

# Конец второго скрипта. Начало третьего
n=5
while true; do
    sleep 1
    echo "Следующий скрипт через $((n-SECONDS)) секунд"
done

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

echo "Проверьте в новом файле /etc/sudoers.test, чтобы не было окружения PATH в директиве Default env_keep!"
echo "Если с файлом sudoers.test все ок, то сделай 'mv sudoers.test sudoers'"
echo ""
echo "Конец!"
