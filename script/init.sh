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

# 1. 删除gh-pages目录
if [ -e "$GH_PAGES_DIR" ]; then
  echo "正在删除gh-pages目录..."
  if ! rmdir "$GH_PAGES_DIR" 2>/dev/null; then
    echo "警告: gh-pages目录不是空目录或不是软链接，尝试强制删除"
    rm -rf "$GH_PAGES_DIR"
  fi
  echo "gh-pages目录已删除"
else
  echo "gh-pages目录不存在，跳过删除"
fi

# 2. 删除submodule gh-pages
if git submodule status "$GH_PAGES_DIR" &>/dev/null; then
  echo "正在删除gh-pages子模块..."
  git submodule deinit -f "$GH_PAGES_DIR"
  git rm -f "$GH_PAGES_DIR"
  rm -rf ".git/modules/$GH_PAGES_DIR"
  echo "gh-pages子模块已删除"
else
  echo "gh-pages子模块不存在，跳过删除"
fi

# 3. 添加submodule gh-pages
echo "正在添加gh-pages子模块..."
git submodule add --force -b gh-pages "$GITHUB_URL" "$GH_PAGES_DIR" 2>/dev/null

if [ $? -eq 0 ]; then
  echo "gh-pages子模块添加成功"
else
  echo "gh-pages分支不存在，正在尝试创建..."
  "$REPO_ROOT/script/init-gh-pages.sh" "$GITHUB_REPO"
  
  # 再次尝试添加子模块
  git submodule add --force -b gh-pages "$GITHUB_URL" "$GH_PAGES_DIR" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "gh-pages子模块添加成功"
  else
    echo "错误: 无法添加gh-pages子模块"
    exit 1
  fi
fi

echo "操作完成"