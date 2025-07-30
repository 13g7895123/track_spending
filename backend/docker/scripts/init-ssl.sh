#!/bin/bash

# 初始化 SSL 證書腳本

# 從 .env 檔案讀取設定
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# 設定變數 (從環境變數或預設值)
DOMAIN="${DOMAIN:-yourdomain.com}"
EMAIL="${CERTBOT_EMAIL:-your-email@example.com}"
DATA_PATH="./docker/certbot"

echo "### 初始化 SSL 證書 ###"

# 檢查是否已存在證書
if [ -d "$DATA_PATH/conf/live/$DOMAIN" ]; then
  echo "證書已存在，跳過初始化"
  exit 0
fi

echo "### 建立必要目錄 ###"
mkdir -p "$DATA_PATH/conf"
mkdir -p "$DATA_PATH/www"

echo "### 啟動 nginx 進行初始設定 ###"
docker-compose up -d nginx

echo "### 等待 nginx 啟動 ###"
sleep 10

echo "### 請求 Let's Encrypt 證書 ###"
docker-compose run --rm certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email $EMAIL \
  --agree-tos \
  --no-eff-email \
  --staging \
  -d $DOMAIN \
  -d www.$DOMAIN

if [ $? -eq 0 ]; then
  echo "### 測試證書獲取成功，現在獲取正式證書 ###"
  
  # 刪除測試證書
  docker-compose run --rm certbot delete --cert-name $DOMAIN
  
  # 獲取正式證書
  docker-compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN \
    -d www.$DOMAIN
    
  if [ $? -eq 0 ]; then
    echo "### SSL 證書設定完成 ###"
    echo "### 重新啟動 nginx 載入新證書 ###"
    docker-compose restart nginx
  else
    echo "### 正式證書獲取失敗 ###"
    exit 1
  fi
else
  echo "### 測試證書獲取失敗 ###"
  exit 1
fi

echo "### SSL 初始化完成 ###"