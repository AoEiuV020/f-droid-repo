#!/bin/bash

# 定义变量
REPO_ROOT="$(dirname "$(dirname "$0")")"
GITHUB_REPO="$1"
GH_PAGES_DIR="gh-pages"
GITHUB_URL="https://github.com/${GITHUB_REPO}.git"

# 检查参数
if [ -z "$GITHUB_REPO" ]; then
  echo "使用方法: $0 <github用户名/仓库名>"
  exit 1
fi

# 进入项目根目录
cd "$REPO_ROOT" || exit 1

# 1. 删除并重新初始化gh-pages仓库
echo "正在删除gh-pages目录..."
if ! rmdir "$GH_PAGES_DIR" 2>/dev/null; then
  echo "警告: gh-pages目录不是空目录或不是软链接，尝试强制删除"
  rm -rf "$GH_PAGES_DIR"
fi

echo "正在创建gh-pages目录..."
mkdir -p "$GH_PAGES_DIR"
cd "$GH_PAGES_DIR" || exit 1
git init
git remote add origin "$GITHUB_URL"
git checkout --orphan gh-pages
echo "gh-pages仓库初始化完成"

# 创建README.md并提交初始commit
echo "正在创建初始README.md..."
echo "# F-Droid仓库页面" > README.md
git add README.md
git commit -m "Initial commit"



echo "正在强制推送gh-pages分支..."
git push --force origin gh-pages

if [ $? -eq 0 ]; then
  echo "gh-pages分支强制推送成功"
else
  echo "错误: gh-pages分支推送失败"
  exit 1
fi

echo "操作完成"