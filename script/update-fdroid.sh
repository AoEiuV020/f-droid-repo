#!/bin/bash

# 导入配置
source "$(dirname "$0")/config.sh"

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 执行fdroid更新命令
echo "正在执行F-Droid更新..."
$FDROID_CMD update --create-metadata --pretty --use-date-from-apk --rename-apks --clean

if [ $? -ne 0 ]; then
  echo "错误: F-Droid更新失败"
  exit 1
fi

echo "F-Droid更新完成"