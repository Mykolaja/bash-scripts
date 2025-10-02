#!/bin/bash

# Настройки
SOURCE_DIR="/home/work_cli"
BACKUP_DIR="/tmp/client_backups"

# Функция для копирования файлов клиентов
backup_client_files() {
    echo "Начинаю копирование файлов клиентов..."
    
    # Создаем целевую директорию
    mkdir -p "$BACKUP_DIR"
    
    # Копируем файлы по шаблону даты
    for file in "$SOURCE_DIR"/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9]_*.txt; do
        if [ -f "$file" ]; then
            cp "$file" "$BACKUP_DIR/"
            if [ $? -eq 0 ]; then
                echo "✅ Успешно: $(basename "$file")"
            else
                echo "❌ Ошибка: $(basename "$file")"
            fi
        fi
    done
    
    echo "Копирование завершено!"
    echo "Файлы сохранены в: $BACKUP_DIR"
}

# Основная функция
main() {
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Ошибка: Исходная директория $SOURCE_DIR не найдена"
        echo "Создайте файлы в формате: ДД.ММ.ГГГГ_Имя_Фамилия.txt"
        exit 1
    fi
    
    backup_client_files
}

# Запуск скрипта
main
