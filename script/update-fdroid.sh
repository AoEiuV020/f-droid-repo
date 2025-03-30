#!/bin/bash

# 定义变量
source "$(dirname "$0")/config.sh"

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 执行fdroid命令更新仓库
echo "正在更新F-Droid仓库..."
$FDROID_CMD update -c

if [ $? -ne 0 ]; then
  echo "错误: F-Droid仓库更新失败"
  exit 1
fi

echo "F-Droid仓库更新完成"
echo "操作完成"