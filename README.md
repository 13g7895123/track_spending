# 記帳App - Expense Tracker

一個具備標籤功能和分享功能的記帳應用程式，使用Flutter開發前端，Laravel開發後端。

## 📁 專案結構

```
track_spending/
├── README.md                    # 專案說明 (本檔案)
├── CLAUDE.md                   # 詳細專案架構和技術規格
├── TODO.md                     # 開發任務清單
├── DEVELOP_IOS.md              # iOS開發和VPS部署指南
└── backend/                    # 後端Laravel API
    ├── README.md               # 後端部署指南
    ├── docker-compose.yml      # Docker Compose配置
    ├── .env.example           # 環境變數範本
    ├── .env.docker            # Docker環境變數範本
    └── docker/                # Docker配置檔案
        ├── Dockerfile         # Laravel應用程式映像
        ├── nginx/             # Nginx設定
        ├── mysql/             # MySQL設定
        ├── php/               # PHP設定
        ├── supervisor/        # Queue worker管理
        ├── cron/              # 定時任務
        └── scripts/           # 管理腳本
            ├── deploy.sh      # 自動部署
            ├── init-ssl.sh    # SSL證書初始化
            └── renew-ssl.sh   # 證書更新
```

## 🚀 快速開始 (前端優先開發)

### 前端開發 (優先進行)
1. 安裝Flutter SDK：[Flutter官方安裝指南](https://flutter.dev/docs/get-started/install)
2. 建立Flutter專案：`flutter create expense_tracker_app`
3. 配置iOS開發環境 (Xcode)
4. 開始前端開發 (使用模擬資料)

詳細步驟請參考 `DEVELOP_IOS.md`

### 後端部署 (後續整合)
1. 進入後端資料夾：`cd backend`
2. 複製環境設定：`cp .env.example .env`
3. 修改環境變數 (域名、密碼等)
4. 執行部署腳本：`./docker/scripts/deploy.sh`

## 📚 文檔說明

- **`CLAUDE.md`** - 完整的專案架構文檔，包含技術棧、資料庫設計、API端點設計等
- **`TODO.md`** - 開發執行項目清單，包含詳細的開發階段和時程規劃
- **`DEVELOP_IOS.md`** - iOS開發環境設置和VPS部署的詳細指南
- **`backend/README.md`** - 後端Docker部署的完整指南

## 🔧 主要功能

### 核心功能
- ✅ 使用者認證 (註冊/登入)
- ✅ 支出/收入記錄管理
- ✅ 標籤系統
- ✅ 標籤分享功能
- ✅ 收據照片上傳
- ✅ 統計報表

### 技術特色
- 🐳 Docker Compose 一鍵部署
- 🔒 Let's Encrypt 自動SSL證書
- 📱 Flutter跨平台前端
- 🚀 Laravel高效能後端
- 🗄️ MySQL資料庫
- ⚡ Redis快取
- 📊 圖表統計功能

## 🏗️ 技術架構

### 前端
- **框架**: Flutter (Dart)
- **狀態管理**: Provider
- **本地儲存**: SQLite
- **網路請求**: Dio
- **UI設計**: Material Design 3

### 後端
- **框架**: Laravel (PHP)
- **資料庫**: MySQL 8.0
- **快取**: Redis
- **認證**: Laravel Sanctum
- **檔案儲存**: Local Storage / AWS S3

### DevOps
- **容器化**: Docker + Docker Compose
- **網頁伺服器**: Nginx
- **SSL證書**: Let's Encrypt (Certbot)
- **程序管理**: Supervisor
- **定時任務**: Cron

## 📋 開發狀態 (前端優先)

### ✅ 已完成階段
- [x] 專案架構設計
- [x] 後端Docker化配置
- [x] 環境變數統一管理
- [x] SSL證書自動化
- [x] 開發順序調整 (前端優先)

### 🎯 當前階段 (前端開發)
- [ ] Flutter專案建立
- [ ] UI元件開發
- [ ] 模擬資料整合
- [ ] 核心功能頁面
- [ ] iOS個人部署測試

### ⏭️ 後續階段
- [ ] Laravel API開發
- [ ] 前後端整合
- [ ] 功能完整性測試
- [ ] 生產環境部署

## 🤝 如何貢獻

1. Fork 此專案
2. 建立功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交變更 (`git commit -m 'Add some AmazingFeature'`)
4. 推送分支 (`git push origin feature/AmazingFeature`)
5. 開啟 Pull Request

## 📄 授權

此專案採用 MIT 授權 - 詳情請見 [LICENSE](LICENSE) 檔案

## 📞 聯絡資訊

如有問題或建議，歡迎聯絡：
- 專案問題: 請開 Issue
- 技術討論: 請參考相關文檔

---

> 💡 **提示**: 建議先閱讀 `CLAUDE.md` 了解完整架構，再參考 `backend/README.md` 進行部署。