#!/bin/bash

# 导入配置
source "$(dirname "$0")/config.sh"

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 提交F-Droid目录的更改
echo "提交F-Droid更新..."
git add .
git commit -m "update: F-Droid repo update $(date +%Y-%m-%d)"

if [ $? -ne 0 ]; then
  echo "警告: F-Droid目录git提交失败"
  exit 1
fi

# 返回仓库根目录提交submodule更新
cd "$REPO_ROOT" || exit 1
echo "提交submodule更新..."
git add "$FDROID_DIR"
git commit -m "update: F-Droid submodule update $(date +%Y-%m-%d)"

if [ $? -ne 0 ]; then
  echo "警告: Submodule提交失败"
  exit 1
fi

echo "所有更新已完成并提交"