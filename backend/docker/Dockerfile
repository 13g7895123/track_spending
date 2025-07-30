FROM php:8.1-fpm

# 設定工作目錄
WORKDIR /var/www/html

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    cron \
    supervisor \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 安裝 Node.js 和 npm (如果需要前端資源編譯)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# 複製專案檔案
COPY . /var/www/html

# 設定權限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# 安裝 PHP 依賴
RUN composer install --optimize-autoloader --no-dev --no-interaction

# 建立符號連結
RUN php artisan storage:link

# 設定 Supervisor
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 暴露 PHP-FPM port
EXPOSE ${PHP_FPM_PORT:-9000}

# 啟動 PHP-FPM
CMD ["php-fpm"]