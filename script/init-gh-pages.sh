#!/bin/bash

# 定义变量，
source "$(dirname "$0")/config.sh"
GITHUB_REPO="$1"
GITHUB_URL="https://github.com/${GITHUB_REPO}.git"

cd "$REPO_ROOT" || exit 1

# 检查参数
if [ -z "$GITHUB_REPO" ]; then
  echo "使用方法: $0 <github用户名/仓库名>"
  exit 1
fi

# 1. 删除并重新初始化F-Droid仓库
echo "正在删除${FDROID_DIR}目录..."
if ! rmdir "$FDROID_DIR" 2>/dev/null; then
  echo "警告: ${FDROID_DIR}目录不是空目录或不是软链接，尝试强制删除"
  rm -rf "$FDROID_DIR"
fi

echo "正在创建${FDROID_DIR}目录..."
mkdir -p "$FDROID_DIR"
cd "$FDROID_DIR" || exit 1
git init
git remote add origin "$GITHUB_URL"
git checkout --orphan gh-pages
echo "F-Droid仓库创建完成"

echo "正在创建提交初始commit..."
echo "# F-Droid仓库页面" > README.md
echo "/config.yml" > .gitignore
echo "/keystore.p12" >> .gitignore
git add .
git commit -m "Initial commit"


echo "正在强制推送gh-pages分支..."
git push --force origin gh-pages

if [ $? -eq 0 ]; then
  echo "F-Droid分支强制推送成功"
else
  echo "错误: F-Droid分支推送失败"
  exit 1
fi

echo "操作完成"