#!/bin/bash

# Скрипт для резервного копирования файлов клиентов

# Настройки
SOURCE_DIR="/home/work_cli"      # Откуда копируем
BACKUP_DIR="/tmp/client_backups" # Куда копируем

# Функция создания тестовых данных
create_test_data() {
    echo "Создаю тестовые данные..."
    mkdir -p "$SOURCE_DIR"
    
    for i in {1..5}; do
        date=$(date --date="$i days ago" +"%d.%m.%Y")
        filename="${date}_Иван_Петров.txt"
        echo "Данные клиента от $date" > "$SOURCE_DIR/$filename"
    done
    
    # Файлы не для копирования
    echo "Конфигурационные настройки" > "$SOURCE_DIR/config.ini"
    echo "Инструкция" > "$SOURCE_DIR/readme.txt"
    echo "Временный файл" > "$SOURCE_DIR/temp_file.doc"
    
    echo "Тестовые данные созданы в $SOURCE_DIR:"
    ls -la "$SOURCE_DIR"
    echo "-------------------------------"
}

# Функция копирования файлов клиентов
backup_client_files() {
    # Запрос о смене директории
    read -p "Изменить директорию копирования? (y/n) (Директория по умолчанию: $BACKUP_DIR): " change_dir
    
    if [ "$change_dir" = "y" ] || [ "$change_dir" = "Y" ]; then
        read -p "Введите путь к целевой директории: " user_dir
        BACKUP_DIR="$user_dir"
        echo "Целевая директория изменена на: $BACKUP_DIR"
    fi
    
    # Создание целевой директории
    mkdir -p "$BACKUP_DIR"
    
    # Копирование файлов с шаблоном дата_имя_фамилия.txt
    echo "Начинаю копирование файлов клиентов..."
    
    # Шаблон: две цифры.две цифры.четыре цифры_любой_текст.txt
    for file in "$SOURCE_DIR"/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9]_*.txt; do
        if [ -f "$file" ]; then
            cp "$file" "$BACKUP_DIR/"
            if [ $? -eq 0 ]; then
                echo "Успешно: $(basename "$file")"
            else
                echo "Ошибка: $(basename "$file")"
            fi
        fi
    done
    
    echo "Копирование завершено!"
}

# Главная функция
main() {
    echo "Запуск скрипта"
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Исходная директория $SOURCE_DIR не найдена"
        read -p "Создать тестовые файлы? (y/n): " create_test
        if [ "$create_test" = "y" ] || [ "$create_test" = "Y" ]; then
            create_test_data
        fi
    fi
    
    backup_client_files
}

main
