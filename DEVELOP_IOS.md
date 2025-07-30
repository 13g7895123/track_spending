# iOS開發與VPS部署指南

## 目標設定
- **後端**: 使用VPS部署Laravel API
- **前端**: Flutter iOS應用程式，僅供個人使用
- **部署方式**: VPS手動部署 + iOS實機測試

## 第一階段：VPS後端部署

### 1. VPS環境準備

#### 1.1 VPS基本配置
```bash
# 更新系統
sudo apt update && sudo apt upgrade -y

# 安裝必要軟體
sudo apt install -y nginx mysql-server php8.1 php8.1-fpm php8.1-mysql php8.1-xml \
php8.1-curl php8.1-zip php8.1-gd php8.1-mbstring php8.1-bcmath \
git curl unzip supervisor redis-server

# 安裝Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

#### 1.2 MySQL資料庫設置
```bash
# 安全設置MySQL
sudo mysql_secure_installation

# 建立資料庫和使用者
sudo mysql -u root -p
```

```sql
CREATE DATABASE expense_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'expense_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON expense_tracker.* TO 'expense_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 1.3 Redis設置
```bash
# 啟動Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server

# 測試Redis連接
redis-cli ping
```

### 2. Laravel專案部署

#### 2.1 複製專案到VPS
```bash
# 建立專案目錄
sudo mkdir -p /var/www/expense-tracker-api
sudo chown $USER:$USER /var/www/expense-tracker-api

# 進入專案目錄
cd /var/www/expense-tracker-api

# 從Git複製專案 (假設已上傳到Git)
git clone https://github.com/yourusername/expense-tracker-api.git .

# 或直接建立Laravel專案
composer create-project laravel/laravel . --prefer-dist
```

#### 2.2 Laravel專案設置
```bash
# 安裝依賴
composer install --optimize-autoloader --no-dev

# 複製環境檔案
cp .env.example .env

# 編輯環境變數
nano .env
```

**`.env` 設置內容：**
```env
APP_NAME="Expense Tracker API"
APP_ENV=production
APP_KEY=base64:generated_key_here
APP_DEBUG=false
APP_URL=https://yourdomain.com

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=expense_tracker
DB_USERNAME=expense_user
DB_PASSWORD=your_secure_password

BROADCAST_DRIVER=log
CACHE_DRIVER=redis
FILESYSTEM_DRIVER=local
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# JWT或Sanctum設置
SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,yourdomain.com

# 檔案上傳設置
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
AWS_BUCKET=
```

#### 2.3 Laravel專案初始化
```bash
# 生成應用程式金鑰
php artisan key:generate

# 建立符號連結
php artisan storage:link

# 執行資料庫遷移
php artisan migrate

# 清除快取
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 設置權限
sudo chown -R www-data:www-data /var/www/expense-tracker-api
sudo chmod -R 755 /var/www/expense-tracker-api
sudo chmod -R 775 /var/www/expense-tracker-api/storage
sudo chmod -R 775 /var/www/expense-tracker-api/bootstrap/cache
```

### 3. Nginx設置

#### 3.1 建立Nginx設定檔
```bash
sudo nano /etc/nginx/sites-available/expense-tracker-api
```

**Nginx設定內容：**
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/expense-tracker-api/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

#### 3.2 啟用網站設置
```bash
# 建立符號連結
sudo ln -s /etc/nginx/sites-available/expense-tracker-api /etc/nginx/sites-enabled/

# 測試Nginx設置
sudo nginx -t

# 重新啟動Nginx
sudo systemctl restart nginx

# 設置開機自動啟動
sudo systemctl enable nginx
```

### 4. SSL證書設置 (Let's Encrypt)

```bash
# 安裝Certbot
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot

# 建立SSL證書
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# 測試自動更新
sudo certbot renew --dry-run
```

### 5. 防火牆設置

```bash
# 設置UFW防火牆
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw status
```

### 6. Laravel Queue處理

#### 6.1 設置Supervisor
```bash
sudo nano /etc/supervisor/conf.d/expense-tracker-worker.conf
```

**Supervisor設定：**
```ini
[program:expense-tracker-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/expense-tracker-api/artisan queue:work redis --sleep=3 --tries=3
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/www/expense-tracker-api/storage/logs/worker.log
```

```bash
# 重新載入Supervisor設置
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start expense-tracker-worker:*
```

### 7. 監控與日誌

#### 7.1 設置日誌輪轉
```bash
sudo nano /etc/logrotate.d/expense-tracker
```

```bash
/var/www/expense-tracker-api/storage/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    notifempty
    create 644 www-data www-data
}
```

#### 7.2 系統監控腳本
```bash
# 建立健康檢查腳本
nano /home/$USER/health-check.sh
```

```bash
#!/bin/bash
API_URL="https://yourdomain.com/api/health"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $API_URL)

if [ $RESPONSE -ne 200 ]; then
    echo "API健康檢查失敗：HTTP $RESPONSE"
    # 發送通知或重新啟動服務
    sudo systemctl restart nginx
    sudo systemctl restart php8.1-fpm
fi
```

```bash
# 設置執行權限
chmod +x /home/$USER/health-check.sh

# 設置定時任務
crontab -e
# 添加：*/5 * * * * /home/username/health-check.sh
```

## 第二階段：Flutter iOS開發

### 1. iOS開發環境準備

#### 1.1 必要軟體安裝
```bash
# 安裝Flutter (macOS)
cd ~/Documents
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 將Flutter添加到PATH (永久)
echo 'export PATH="$PATH:~/Documents/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# 檢查Flutter環境
flutter doctor
```

#### 1.2 iOS設置
- 安裝Xcode (App Store)
- 安裝Xcode命令列工具：`xcode-select --install`
- 接受Xcode授權：`sudo xcodebuild -license`
- 安裝iOS模擬器：`open -a Simulator`

#### 1.3 CocoaPods安裝
```bash
# 安裝CocoaPods
sudo gem install cocoapods
pod setup
```

### 2. Flutter專案建立

#### 2.1 建立專案
```bash
cd ~/Documents/Projects
flutter create expense_tracker_app
cd expense_tracker_app
```

#### 2.2 pubspec.yaml設置
```yaml
name: expense_tracker_app
description: 個人記帳應用程式

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # 狀態管理
  provider: ^6.0.5
  
  # 網路請求
  dio: ^5.3.2
  
  # 本地儲存
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2
  
  # UI套件
  cupertino_icons: ^1.0.2
  
  # 日期處理
  intl: ^0.18.1
  
  # 圖表
  fl_chart: ^0.64.0
  
  # 圖片選擇
  image_picker: ^1.0.4
  
  # 權限處理
  permission_handler: ^11.0.1
  
  # 其他工具
  uuid: ^4.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

#### 2.3 iOS權限設置

**編輯 `ios/Runner/Info.plist`：**
```xml
<key>NSCameraUsageDescription</key>
<string>需要使用相機拍攝收據照片</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要訪問相簿選擇收據照片</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>yourdomain.com</key>
        <dict>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

### 3. 核心功能實作

#### 3.1 API服務設置
```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://yourdomain.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String expensesEndpoint = '/expenses';
  static const String incomeEndpoint = '/income';
  static const String tagsEndpoint = '/tags';
  static const String shareEndpoint = '/share';
}
```

#### 3.2 網路請求服務
```dart
// lib/data/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('API錯誤: ${error.message}');
        handler.next(error);
      },
    ));
  }
}
```

### 4. iOS實機測試

#### 4.1 開發者帳號設置
1. 註冊Apple Developer帳號 (個人使用免費即可)
2. 在Xcode中登入Apple ID
3. 設置Team和Bundle Identifier

#### 4.2 裝置設置
```bash
# 連接iPhone到Mac
# 信任開發者電腦
# 在iPhone設置中啟用開發者模式
```

#### 4.3 Xcode專案設置
1. 開啟 `ios/Runner.xcworkspace`
2. 選擇Development Team
3. 設置Bundle Identifier (唯一識別碼)
4. 選擇目標裝置 (實機)

#### 4.4 建置與安裝
```bash
# 清理專案
flutter clean
flutter pub get

# iOS Pod安裝
cd ios
pod install
cd ..

# 建置並安裝到實機
flutter run --release
```

### 5. 測試與除錯

#### 5.1 本地測試
```bash
# 執行單元測試
flutter test

# 執行整合測試
flutter drive --target=test_driver/app.dart
```

#### 5.2 效能分析
```bash
# 效能分析
flutter run --profile
```

#### 5.3 日誌除錯
```dart
// 在main.dart中設置日誌
import 'dart:developer' as developer;

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    developer.log(
      'Flutter錯誤',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  
  runApp(MyApp());
}
```

## 第三階段：整合測試

### 1. API連接測試

#### 1.1 建立測試腳本
```dart
// test/integration/api_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_app/data/services/api_service.dart';

void main() {
  group('API整合測試', () {
    late ApiService apiService;
    
    setUp(() {
      apiService = ApiService();
    });
    
    test('使用者註冊測試', () async {
      // 測試註冊API
    });
    
    test('登入測試', () async {
      // 測試登入API
    });
    
    test('支出記錄測試', () async {
      // 測試支出記錄API
    });
  });
}
```

### 2. 使用者流程測試

#### 2.1 手動測試清單
- [ ] 使用者註冊功能
- [ ] 使用者登入功能
- [ ] 新增支出記錄
- [ ] 新增收入記錄
- [ ] 標籤建立與管理
- [ ] 收據照片上傳
- [ ] 分享功能測試
- [ ] 離線模式測試
- [ ] 資料同步測試

## 第四階段：部署優化

### 1. 效能優化

#### 1.1 VPS效能調整
```bash
# 調整PHP-FPM設置
sudo nano /etc/php/8.1/fpm/pool.d/www.conf

# 優化MySQL設置
sudo nano /etc/mysql/my.cnf
```

#### 1.2 快取優化
```bash
# Laravel快取優化
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
```

### 2. 安全性設置

#### 2.1 API安全
- 實作API速率限制
- 設置CORS政策
- 啟用HTTPS
- 實作輸入驗證

#### 2.2 資料備份
```bash
# 設置自動備份腳本
nano /home/$USER/backup-db.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/$USER/backups"
mkdir -p $BACKUP_DIR

mysqldump -u expense_user -p'your_password' expense_tracker > $BACKUP_DIR/expense_tracker_$DATE.sql
gzip $BACKUP_DIR/expense_tracker_$DATE.sql

# 保留30天的備份
find $BACKUP_DIR -name "*.gz" -mtime +30 -delete
```

```bash
# 設置定時備份
crontab -e
# 添加：0 2 * * * /home/username/backup-db.sh
```

## 維護建議

### 1. 監控項目
- API回應時間
- 資料庫效能
- 伺服器資源使用率
- 錯誤日誌監控

### 2. 定期更新
- Laravel安全更新
- PHP版本更新
- MySQL安全補丁
- Flutter SDK更新

### 3. 備份策略
- 資料庫每日備份
- 程式碼版本控制
- 設置檔案備份
- 測試還原程序

## 故障排除

### 常見問題解決方案

#### 1. API連接問題
```bash
# 檢查Nginx狀態
sudo systemctl status nginx

# 檢查PHP-FPM狀態
sudo systemctl status php8.1-fpm

# 檢查防火牆設置
sudo ufw status
```

#### 2. iOS建置問題
```bash
# 清理Flutter快取
flutter clean
flutter pub get

# 清理iOS建置
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

#### 3. 資料庫連接問題
```bash
# 檢查MySQL狀態
sudo systemctl status mysql

# 測試資料庫連接
mysql -u expense_user -p expense_tracker
```

這份指南涵蓋了從VPS部署到iOS開發的完整流程，讓您能夠成功部署個人使用的記帳應用程式。