# Windows Flutter 安裝詳細說明

本文檔將詳細說明如何在 Windows 系統上安裝 Flutter 開發環境。

## 📋 系統需求

### 作業系統需求
- Windows 10 或更高版本 (64-bit)
- 磁碟空間：至少 1.64 GB（不包括IDE/工具的磁碟空間）
- 工具：Windows PowerShell 5.0 或更新版本（通常已預裝）

### 硬體需求
- RAM：建議 8GB 或以上
- CPU：x86-64 (也稱為 x64 或 AMD64)

## 🔧 安裝步驟

### 步驟 1：下載 Flutter SDK

1. 前往 Flutter 官方網站：https://flutter.dev/docs/get-started/install/windows
2. 下載最新的 Flutter SDK for Windows
3. 將下載的 zip 檔案解壓縮到您選擇的位置（例如：`C:\flutter`）

**注意事項：**
- 不要將 Flutter 安裝在需要權限的目錄（如 `C:\Program Files\`）
- 路徑中不應包含特殊字符或空格

### 步驟 2：設定環境變數

1. 在開始功能表搜尋「環境變數」
2. 點擊「編輯系統環境變數」
3. 在「系統內容」視窗中，點擊「環境變數」按鈕
4. 在「系統變數」區域找到 `Path` 變數，點擊「編輯」
5. 點擊「新增」並輸入 Flutter bin 目錄的完整路徑（例如：`C:\flutter\bin`）
6. 點擊「確定」關閉所有視窗

### 步驟 3：驗證安裝

1. 開啟新的 PowerShell 或命令提示字元視窗
2. 執行以下命令：

```bash
flutter --version
```

如果看到 Flutter 版本資訊，表示安裝成功。

### 步驟 4：執行 Flutter Doctor

執行以下命令檢查開發環境：

```bash
flutter doctor
```

Flutter Doctor 會檢查您的環境並顯示安裝狀態報告。

## 🛠️ 依賴工具安裝

### Git 安裝

Flutter 需要 Git 來管理套件和更新。

1. 前往 https://git-scm.com/download/win
2. 下載並安裝 Git for Windows
3. 安裝時使用預設設定即可

### Android 開發環境（可選）

如果您要為 Android 開發：

#### Android Studio 安裝

1. 前往 https://developer.android.com/studio
2. 下載並安裝 Android Studio
3. 啟動 Android Studio，完成初始設定
4. 安裝 Android SDK 和相關工具

#### Android SDK 設定

1. 開啟 Android Studio
2. 前往 **File > Settings > Appearance & Behavior > System Settings > Android SDK**
3. 安裝必要的 SDK 版本和工具

### iOS 開發環境（僅限 macOS）

**注意：** iOS 開發只能在 macOS 上進行。如果您使用 Windows，可以：
- 使用 macOS 虛擬機（不建議，效能較差）
- 租用 macOS 雲端服務
- 使用實體 Mac 設備

## 🎯 VS Code 設定

### 安裝 VS Code

1. 前往 https://code.visualstudio.com/
2. 下載並安裝 VS Code

### 安裝 Flutter 擴充功能

1. 開啟 VS Code
2. 前往擴充功能（Extensions）
3. 搜尋並安裝「Flutter」
4. 這會同時安裝 Dart 擴充功能

### 設定 Flutter SDK 路徑

1. 在 VS Code 中按 `Ctrl+Shift+P`
2. 輸入「Flutter: Change SDK」
3. 選擇您的 Flutter SDK 安裝路徑

## 📱 建立第一個 Flutter 專案

### 使用命令列建立專案

```bash
flutter create my_app
cd my_app
flutter run
```

### 使用 VS Code 建立專案

1. 按 `Ctrl+Shift+P`
2. 輸入「Flutter: New Project」
3. 選擇「Application」
4. 選擇專案位置並輸入專案名稱

## 🔍 常見問題排除

### 問題 1：找不到 flutter 命令

**解決方案：**
- 確認 Flutter bin 目錄已正確添加到 PATH 環境變數
- 重新啟動命令提示字元或 PowerShell
- 檢查 Flutter 安裝路徑是否正確

### 問題 2：Flutter Doctor 顯示錯誤

**常見錯誤及解決方案：**

1. **Android license status unknown**
   ```bash
   flutter doctor --android-licenses
   ```

2. **Unable to find bundled Java version**
   - 重新安裝 Android Studio
   - 確認 Android Studio 已正確安裝 JDK

3. **cmdline-tools component is missing**
   - 在 Android Studio 中安裝 Android SDK Command-line Tools

### 問題 3：Windows Defender 干擾

Windows Defender 可能會影響 Flutter 效能：

1. 開啟 Windows 安全性
2. 前往「病毒與威脅防護」
3. 將 Flutter 安裝目錄添加到排除清單

## 🚀 效能優化建議

### 1. 啟用 Web 支援（可選）

```bash
flutter config --enable-web
```

### 2. 設定快取目錄

如果 C 槽空間不足，可以設定 Flutter 快取到其他磁碟：

```bash
# 設定環境變數
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
set PUB_HOSTED_URL=https://pub.flutter-io.cn
```

### 3. 使用中國鏡像（可選）

如果下載速度較慢，可以使用中國鏡像：

```bash
# 設定鏡像
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
set PUB_HOSTED_URL=https://pub.flutter-io.cn
```

## ✅ 驗證安裝完成

執行以下命令確認所有工具都已正確安裝：

```bash
flutter doctor -v
```

輸出應該顯示類似以下內容：

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows [版本], locale zh-TW)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Visual Studio Code (version x.x.x)
[✓] Connected device (1 available)
[✓] Network resources
```

## 📚 延伸學習資源

- [Flutter 官方文檔](https://flutter.dev/docs)
- [Dart 語言教學](https://dart.dev/guides)
- [Flutter Widget 目錄](https://flutter.dev/docs/development/ui/widgets)
- [Flutter 實例和教學](https://flutter.dev/docs/cookbook)

## 🔄 更新 Flutter

定期更新 Flutter 以獲得最新功能和修復：

```bash
flutter upgrade
```

## 💡 開發小技巧

1. **熱重載（Hot Reload）**：在開發時按 `r` 可以快速重載應用
2. **熱重啟（Hot Restart）**：按 `R` 可以重啟應用
3. **Widget Inspector**：使用 VS Code 的 Flutter Inspector 調試 UI
4. **效能分析**：使用 `flutter analyze` 檢查程式碼品質

---

完成以上步驟後，您就可以開始 Flutter 開發了！如果遇到任何問題，請參考 Flutter 官方文檔或社群資源。