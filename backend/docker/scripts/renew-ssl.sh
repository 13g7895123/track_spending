#!/bin/bash

# SSL 證書更新腳本

echo "### 檢查並更新 SSL 證書 ###"

# 更新證書
docker-compose run --rm certbot renew --quiet

# 檢查更新結果
if [ $? -eq 0 ]; then
    echo "### 證書檢查/更新成功 ###"
    
    # 重新載入 nginx 配置
    docker-compose exec nginx nginx -s reload
    
    if [ $? -eq 0 ]; then
        echo "### Nginx 配置重新載入成功 ###"
    else
        echo "### Nginx 配置重新載入失敗，重啟 nginx ###"
        docker-compose restart nginx
    fi
else
    echo "### 證書更新失敗 ###"
    exit 1
fi

echo "### SSL 證書維護完成 ###"