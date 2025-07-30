#!/bin/bash

# 部署腳本

set -e

echo "### 開始部署記帳 App 後端 ###"

# 檢查環境變數
if [ ! -f ".env.docker" ]; then
    echo "錯誤：.env.docker 檔案不存在"
    echo "請複製 .env.docker 並設定正確的環境變數"
    exit 1
fi

# 複製環境設定
cp .env.docker .env

# 載入環境變數
export $(cat .env | grep -v '^#' | xargs)

echo "### 停止現有容器 ###"
docker-compose down

echo "### 建立 Docker 映像 ###"
docker-compose build --no-cache

echo "### 啟動資料庫和快取服務 ###"
docker-compose up -d mysql redis

echo "### 等待資料庫啟動 ###"
sleep 30

echo "### 執行資料庫遷移 ###"
docker-compose run --rm app php artisan migrate --force

echo "### 產生應用程式金鑰 (如果尚未設定) ###"
if ! grep -q "APP_KEY=base64:" .env; then
    docker-compose run --rm app php artisan key:generate --force
fi

echo "### 清除並重建快取 ###"
docker-compose run --rm app php artisan config:cache
docker-compose run --rm app php artisan route:cache
docker-compose run --rm app php artisan view:cache

echo "### 建立儲存連結 ###"
docker-compose run --rm app php artisan storage:link

echo "### 建立必要目錄 ###"
mkdir -p storage/backups
chmod -R 775 storage
chmod -R 775 bootstrap/cache

echo "### 啟動所有服務 ###"
docker-compose up -d

echo "### 等待服務啟動 ###"
sleep 20

echo "### 檢查服務狀態 ###"
docker-compose ps

echo "### 測試 API 連接 ###"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${NGINX_HTTP_PORT}/api/health || echo "000")

if [ "$RESPONSE" = "200" ]; then
    echo "✅ API 服務運行正常"
else
    echo "❌ API 服務無法連接 (HTTP $RESPONSE)"
    echo "檢查日誌："
    docker-compose logs app
fi

echo "### 部署完成 ###"
echo ""
echo "服務訪問資訊："
echo "- API 端點: https://${DOMAIN}/api"
echo "- 資料庫: localhost:${MYSQL_PORT}"
echo ""
echo "管理命令："
echo "- 查看日誌: docker-compose logs [service]"
echo "- 進入容器: docker-compose exec [service] bash"
echo "- 停止服務: docker-compose down"
echo "- 重啟服務: docker-compose restart [service]"
echo ""
echo "SSL 設定："
echo "1. 修改 docker/nginx/default.conf 中的域名"
echo "2. 執行: chmod +x docker/scripts/init-ssl.sh"
echo "3. 執行: ./docker/scripts/init-ssl.sh"