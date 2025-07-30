# 記帳App後端 - Laravel API

## 專案結構

```
backend/
├── docker/                     # Docker 相關設定
│   ├── nginx/                  # Nginx 設定檔
│   │   ├── nginx.conf         # 主要 Nginx 設定
│   │   └── default.conf       # 站點設定
│   ├── mysql/                  # MySQL 設定
│   │   └── my.cnf             # MySQL 配置檔
│   ├── php/                    # PHP 設定
│   │   └── php.ini            # PHP 配置檔
│   ├── supervisor/             # Supervisor 設定
│   │   └── supervisord.conf   # Queue worker 管理
│   ├── cron/                   # 定時任務
│   │   └── crontab            # Laravel 排程設定
│   ├── scripts/                # 管理腳本
│   │   ├── init-ssl.sh        # SSL 證書初始化
│   │   ├── renew-ssl.sh       # SSL 證書更新
│   │   └── deploy.sh          # 自動部署腳本
│   └── Dockerfile             # Laravel 應用程式映像
├── docker-compose.yml          # Docker Compose 設定
├── .env.docker                # Docker 環境變數範本
└── README.md                  # 本檔案
```

## 快速開始

### 1. 環境準備
```bash
# 複製環境變數檔案
cp .env.example .env
# 或使用 Docker 專用範本
cp .env.docker .env

# 修改環境變數 (重要!)
nano .env
```

### 2. 一鍵部署
```bash
# 設定執行權限
chmod +x docker/scripts/*.sh

# 執行部署
./docker/scripts/deploy.sh
```

### 3. SSL 證書設定
```bash
# 修改域名設定
nano docker/nginx/default.conf
nano docker/scripts/init-ssl.sh

# 初始化 SSL 證書
./docker/scripts/init-ssl.sh
```

## Docker 服務

### 核心服務
- **app**: Laravel PHP-FPM 應用程式
- **nginx**: 反向代理伺服器 (HTTP/HTTPS)
- **mysql**: MySQL 8.0 資料庫
- **redis**: Redis 快取服務

### 輔助服務
- **certbot**: Let's Encrypt SSL 證書管理
- **queue**: Laravel 佇列處理器
- **scheduler**: Laravel 排程處理器

## 管理命令

```bash
# 查看服務狀態
docker-compose ps

# 查看服務日誌
docker-compose logs app
docker-compose logs nginx
docker-compose logs mysql

# 重啟服務
docker-compose restart app

# 進入 Laravel 容器
docker-compose exec app bash

# 執行 Laravel 命令
docker-compose exec app php artisan migrate
docker-compose exec app php artisan cache:clear

# 資料庫管理
docker-compose exec mysql mysql -u expense_user -p expense_tracker
```

## 環境變數設定

### 必須修改的環境變數

```env
# 域名和SSL設定
DOMAIN=yourdomain.com
SSL_EMAIL=your-email@example.com
APP_URL=https://yourdomain.com
SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,yourdomain.com
SESSION_DOMAIN=yourdomain.com

# 安全設定 (建議修改)
DB_PASSWORD=your_secure_password_here
MYSQL_ROOT_PASSWORD=your_mysql_root_password_here
```

### 端口設定 (可選修改)

```env  
# Docker 服務端口
NGINX_HTTP_PORT=80          # HTTP端口
NGINX_HTTPS_PORT=443        # HTTPS端口  
MYSQL_PORT=3306             # MySQL端口
REDIS_PORT=6379             # Redis端口
PHP_FPM_PORT=9000          # PHP-FPM端口
```

### 環境變數載入

所有腳本會自動從 `.env` 檔案載入環境變數：
- `deploy.sh` - 部署腳本
- `init-ssl.sh` - SSL初始化腳本
- `docker-compose.yml` - Docker配置

## API 端點

### 認證相關
- `POST /api/auth/register` - 使用者註冊
- `POST /api/auth/login` - 使用者登入
- `POST /api/auth/logout` - 使用者登出
- `GET /api/auth/user` - 取得當前使用者資訊
- `PUT /api/auth/profile` - 更新使用者資料
- `PUT /api/auth/password` - 變更密碼

### 支出相關
- `GET /api/expenses` - 取得支出列表
- `POST /api/expenses` - 新增支出
- `GET /api/expenses/{id}` - 取得支出詳細資訊
- `PUT /api/expenses/{id}` - 更新支出
- `DELETE /api/expenses/{id}` - 刪除支出
- `GET /api/expenses-statistics` - 支出統計資料

### 收入相關
- `GET /api/incomes` - 取得收入列表
- `POST /api/incomes` - 新增收入
- `GET /api/incomes/{id}` - 取得收入詳細資訊
- `PUT /api/incomes/{id}` - 更新收入
- `DELETE /api/incomes/{id}` - 刪除收入
- `GET /api/incomes-statistics` - 收入統計資料

### 標籤相關
- `GET /api/tags` - 取得標籤列表
- `POST /api/tags` - 建立標籤
- `GET /api/tags/{id}` - 取得標籤詳細資訊
- `PUT /api/tags/{id}` - 更新標籤
- `DELETE /api/tags/{id}` - 刪除標籤
- `POST /api/tags/{id}/share` - 分享標籤
- `DELETE /api/tags/{id}/unshare` - 取消分享標籤
- `GET /api/shared-tags` - 取得與我分享的標籤

## 安全性功能

- HTTPS 強制重導向
- Let's Encrypt 自動 SSL 證書
- 資料庫連接加密
- API 速率限制
- 安全標頭設定
- 檔案上傳限制

## 備份機制

自動備份功能：
- 每日 2:00 AM 資料庫備份
- 保留 30 天備份檔案
- 每週清理舊日誌檔案

手動備份：
```bash
# 資料庫備份
docker-compose exec mysql mysqldump -u expense_user -p expense_tracker > backup.sql

# 還原資料庫
docker-compose exec -T mysql mysql -u expense_user -p expense_tracker < backup.sql
```

## 故障排除

### 常見問題

1. **SSL 證書問題**
   ```bash
   docker-compose run --rm certbot certificates
   ```

2. **資料庫連接失敗**
   ```bash
   docker-compose exec mysql mysqladmin -u root -p ping
   ```

3. **權限問題**
   ```bash
   docker-compose exec app chown -R www-data:www-data /var/www/html
   ```

4. **記憶體不足**
   ```bash
   # 修改 docker/php/php.ini
   memory_limit = 512M
   ```

## 監控與維護

### 健康檢查
```bash
curl -f https://yourdomain.com/api/health
docker-compose ps
```

### 效能監控
```bash
docker stats
docker system df
```

### 日誌管理
```bash
docker-compose logs -f app
tail -f storage/logs/laravel.log
```

## 更新部署

```bash
# 拉取最新程式碼
git pull

# 重新部署
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# 執行資料庫遷移
docker-compose exec app php artisan migrate

# 清除快取
docker-compose exec app php artisan cache:clear
```