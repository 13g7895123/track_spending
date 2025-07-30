# 記帳App專案架構

## 專案概述
這是一個具備標籤功能和分享功能的記帳應用程式，使用Flutter開發前端，Laravel開發後端。

## 技術架構

### 前端技術棧
- **框架**: Flutter (Dart)
- **狀態管理**: Provider / Riverpod
- **本地儲存**: SQLite (sqflite)
- **網路請求**: Dio
- **UI框架**: Material Design 3
- **圖表**: fl_chart
- **日期選擇**: table_calendar

### 後端技術棧
- **框架**: Laravel (PHP)
- **資料庫**: MySQL
- **ORM**: Eloquent ORM
- **認證**: Laravel Sanctum / Passport
- **檔案上傳**: Laravel Storage + AWS S3
- **API文檔**: L5-Swagger (OpenAPI)
- **快取**: Redis
- **佇列**: Laravel Queue

## 專案結構

### Flutter前端結構
```
expense_tracker_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── api_constants.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── app_colors.dart
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   ├── number_utils.dart
│   │   │   └── validation_utils.dart
│   │   └── router/
│   │       └── app_router.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── expense_model.dart
│   │   │   ├── income_model.dart
│   │   │   ├── tag_model.dart
│   │   │   ├── user_model.dart
│   │   │   └── category_model.dart
│   │   ├── repositories/
│   │   │   ├── expense_repository.dart
│   │   │   ├── income_repository.dart
│   │   │   ├── tag_repository.dart
│   │   │   └── user_repository.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── local_storage_service.dart
│   │   │   └── share_service.dart
│   │   └── datasources/
│   │       ├── local/
│   │       │   └── database_helper.dart
│   │       └── remote/
│   │           └── api_client.dart
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── expense_provider.dart
│   │   │   ├── income_provider.dart
│   │   │   └── tag_provider.dart
│   │   ├── pages/
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── home/
│   │   │   │   ├── home_page.dart
│   │   │   │   └── dashboard_page.dart
│   │   │   ├── expense/
│   │   │   │   ├── add_expense_page.dart
│   │   │   │   ├── expense_list_page.dart
│   │   │   │   └── expense_detail_page.dart
│   │   │   ├── income/
│   │   │   │   ├── add_income_page.dart
│   │   │   │   └── income_list_page.dart
│   │   │   ├── tags/
│   │   │   │   ├── tag_management_page.dart
│   │   │   │   └── tag_share_page.dart
│   │   │   ├── reports/
│   │   │   │   ├── report_page.dart
│   │   │   │   └── chart_page.dart
│   │   │   └── profile/
│   │   │       └── profile_page.dart
│   │   └── widgets/
│   │       ├── common/
│   │       │   ├── custom_button.dart
│   │       │   ├── custom_text_field.dart
│   │       │   ├── loading_widget.dart
│   │       │   └── error_widget.dart
│   │       ├── expense/
│   │       │   ├── expense_card.dart
│   │       │   └── expense_form.dart
│   │       ├── charts/
│   │       │   ├── pie_chart_widget.dart
│   │       │   └── line_chart_widget.dart
│   │       └── tags/
│   │           ├── tag_chip.dart
│   │           └── tag_selector.dart
│   └── l10n/
│       ├── app_localizations.dart
│       ├── app_en.dart
│       └── app_zh.dart
├── assets/
│   ├── images/
│   └── icons/
├── test/
├── pubspec.yaml
└── README.md
```

### Laravel後端結構
```
expense_tracker_api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── API/
│   │   │   │   ├── AuthController.php
│   │   │   │   ├── ExpenseController.php
│   │   │   │   ├── IncomeController.php
│   │   │   │   ├── TagController.php
│   │   │   │   └── ShareController.php
│   │   │   └── Controller.php
│   │   ├── Middleware/
│   │   │   ├── Authenticate.php
│   │   │   ├── ValidateApiToken.php
│   │   │   └── CheckPermission.php
│   │   ├── Requests/
│   │   │   ├── Auth/
│   │   │   │   ├── LoginRequest.php
│   │   │   │   └── RegisterRequest.php
│   │   │   ├── Expense/
│   │   │   │   ├── StoreExpenseRequest.php
│   │   │   │   └── UpdateExpenseRequest.php
│   │   │   └── Tag/
│   │   │       ├── StoreTagRequest.php
│   │   │       └── ShareTagRequest.php
│   │   └── Resources/
│   │       ├── ExpenseResource.php
│   │       ├── IncomeResource.php
│   │       ├── TagResource.php
│   │       └── UserResource.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Expense.php
│   │   ├── Income.php
│   │   ├── Tag.php
│   │   ├── RecordTag.php
│   │   └── SharedRecord.php
│   ├── Services/
│   │   ├── AuthService.php
│   │   ├── ExpenseService.php
│   │   ├── IncomeService.php
│   │   ├── TagService.php
│   │   └── ShareService.php
│   └── Traits/
│       └── HasApiTokens.php
├── database/
│   ├── migrations/
│   │   ├── 2024_01_01_000000_create_users_table.php
│   │   ├── 2024_01_02_000000_create_expenses_table.php
│   │   ├── 2024_01_03_000000_create_income_table.php
│   │   ├── 2024_01_04_000000_create_tags_table.php
│   │   ├── 2024_01_05_000000_create_record_tags_table.php
│   │   └── 2024_01_06_000000_create_shared_records_table.php
│   ├── seeders/
│   │   ├── DatabaseSeeder.php
│   │   └── UserSeeder.php
│   └── factories/
│       ├── UserFactory.php
│       └── ExpenseFactory.php
├── routes/
│   ├── api.php
│   └── web.php
├── config/
│   ├── database.php
│   ├── auth.php
│   └── filesystems.php
├── storage/
│   ├── app/
│   │   └── public/
│   │       └── receipts/
│   └── logs/
├── tests/
│   ├── Feature/
│   └── Unit/
├── .env.example
├── composer.json
└── artisan
```

## 資料庫設計 (MySQL)

### 使用者表 (users)
```sql
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255) NULL,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 支出表 (expenses)
```sql
CREATE TABLE expenses (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    date DATE NOT NULL,
    receipt_image VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 收入表 (income)
```sql
CREATE TABLE income (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    source VARCHAR(100),
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 標籤表 (tags)
```sql
CREATE TABLE tags (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    color VARCHAR(7) DEFAULT '#007AFF',
    user_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 記錄標籤關聯表 (record_tags)
```sql
CREATE TABLE record_tags (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    record_id BIGINT UNSIGNED NOT NULL,
    record_type ENUM('expense', 'income') NOT NULL,
    tag_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    INDEX idx_record (record_id, record_type),
    INDEX idx_tag (tag_id)
);
```

### 分享記錄表 (shared_records)
```sql
CREATE TABLE shared_records (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    owner_id BIGINT UNSIGNED NOT NULL,
    shared_with_id BIGINT UNSIGNED NOT NULL,
    tag_id BIGINT UNSIGNED NOT NULL,
    permission ENUM('read', 'write') DEFAULT 'read',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (shared_with_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE KEY unique_share (owner_id, shared_with_id, tag_id)
);
```

## 核心功能

### 1. 使用者認證
- 註冊/登入
- JWT Token驗證
- 密碼重設

### 2. 記帳功能
- 新增支出記錄
- 新增收入記錄
- 編輯/刪除記錄
- 上傳收據照片

### 3. 標籤管理
- 建立自訂標籤
- 標籤分類管理
- 顏色標識

### 4. 分享功能
- 根據標籤分享記錄
- 設定分享權限
- 查看分享的記錄

### 5. 報表統計
- 月度/年度支出統計
- 分類統計圖表
- 收支趨勢分析

### 6. 資料同步
- 本地資料庫緩存
- 雲端同步
- 離線模式支援

## API 端點設計

### 認證相關
- POST /api/auth/register - 使用者註冊
- POST /api/auth/login - 使用者登入
- POST /api/auth/logout - 使用者登出
- POST /api/auth/refresh - 刷新Token

### 支出相關
- GET /api/expenses - 取得支出列表
- POST /api/expenses - 新增支出
- PUT /api/expenses/:id - 更新支出
- DELETE /api/expenses/:id - 刪除支出
- GET /api/expenses/stats - 支出統計

### 收入相關
- GET /api/income - 取得收入列表
- POST /api/income - 新增收入
- PUT /api/income/:id - 更新收入
- DELETE /api/income/:id - 刪除收入

### 標籤相關
- GET /api/tags - 取得標籤列表
- POST /api/tags - 新增標籤
- PUT /api/tags/:id - 更新標籤
- DELETE /api/tags/:id - 刪除標籤

### 分享相關
- POST /api/share/tag/:tagId - 分享標籤
- GET /api/share/received - 取得接收的分享
- PUT /api/share/:id/permission - 更新分享權限
- DELETE /api/share/:id - 取消分享

## 安全考量

1. **密碼安全**: 使用bcrypt加密儲存
2. **API安全**: JWT Token驗證，設定適當過期時間
3. **資料驗證**: 前後端雙重驗證
4. **檔案上傳**: 限制檔案類型和大小
5. **權限控制**: 確保使用者只能存取自己的資料

## 部署建議

### 前端部署
- 建議使用Firebase Hosting或Netlify
- 支援PWA功能

### 後端部署
- **Docker部署**: 使用 `backend/` 資料夾中的 Docker Compose 配置
- **VPS部署**: 參考 `DEVELOP_IOS.md` 中的VPS部署指南
- **雲端服務**: AWS、Google Cloud或Heroku
- **環境設定**: 使用 `backend/.env.example` 作為範本
- **SSL憑證**: 內建Let's Encrypt自動證書管理

### 資料庫
- 生產環境建議使用MySQL雲端服務 (AWS RDS, Google Cloud SQL)
- 定期備份機制
- 讀寫分離配置

## 開發工具

### 前端
- Flutter SDK
- Android Studio / VS Code
- Flutter Inspector

### 後端
- PHP 8.1+
- Composer
- Laravel Artisan
- Postman (API測試)
- MySQL Workbench / phpMyAdmin

## 測試策略

### 前端測試
- 單元測試 (flutter_test)
- Widget測試
- 整合測試

### 後端測試
- 單元測試 (PHPUnit)
- 功能測試 (Laravel Testing)
- API測試 (Laravel HTTP Testing)
- 資料庫測試 (Database Testing)

## 專案當前狀態

### ✅ 已完成階段
1. **專案架構設計** - 完整的技術棧選擇和系統設計
2. **Docker環境配置** - 完整的後端容器化方案 (Laravel + MySQL + Nginx + Redis)
3. **環境變數管理** - 統一的配置管理系統
4. **SSL自動化** - Let's Encrypt證書自動申請和更新
5. **部署腳本** - 一鍵部署和管理腳本
6. **文檔撰寫** - 完整的開發和部署指南
7. **Flutter前端開發** - 完整的Flutter專案架構和UI實作
8. **模擬資料服務** - 完整的Mock數據系統和狀態管理
9. **Laravel後端開發** - 完整的API實作、資料庫設計和測試
10. **認證系統** - Laravel Sanctum認證和用戶管理
11. **API端點** - 完整的RESTful API (支出、收入、標籤、分享)
12. **單元測試** - 完整的後端測試套件 (AuthTest, ExpenseTest, TagTest)

### 🔄 當前階段 (整合與部署)
- **前後端整合** - Flutter前端與Laravel API的整合
- **生產環境部署** - VPS部署和SSL配置
- **功能完整性測試** - 端對端功能驗證

### 📋 下一步行動
1. **API整合**: 將Flutter前端從Mock資料切換到真實API
2. **部署測試**: 在VPS環境中測試完整應用
3. **iOS發布**: 建立並測試iOS應用程式
4. **性能優化**: 前後端性能調優
5. **用戶測試**: 實際用戶體驗測試和回饋收集

### 🎯 MVP完成狀態
✅ **基礎記帳功能** - 支出/收入記錄管理完全實作
✅ **標籤系統** - 標籤建立、管理、分享功能完成
✅ **認證系統** - 用戶註冊、登入、個人資料管理
✅ **統計功能** - 基礎統計和圖表顯示
✅ **資料庫設計** - 完整的MySQL資料庫結構
✅ **API架構** - RESTful API完整實作
✅ **測試覆蓋** - 後端功能測試完成

### 🛠️ 技術棧總結
- **前端**: Flutter + Provider + SQLite + 模擬資料 (初期)
- **後端**: Laravel + MySQL + Redis + Nginx (後續整合)
- **部署**: Docker Compose + Let's Encrypt + VPS
- **開發策略**: 前端優先開發，使用模擬資料獨立進行

### 📱 前端優先開發優勢
- **快速原型**: 立即可見的應用程式界面
- **用戶驗證**: 早期UX測試和回饋收集  
- **並行開發**: 前後端團隊可同時進行
- **風險降低**: 提前發現設計和技術問題

---

> 📖 **相關文檔**: 
> - 詳細開發計劃請參考 `TODO.md`
> - VPS部署指南請參考 `DEVELOP_IOS.md`  
> - Docker操作請參考 `backend/README.md`
> - 專案總覽請參考 `README.md`