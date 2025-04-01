#!/bin/bash

cd "$(dirname "$(dirname "$0")")" || exit 1

# 导入配置
source "$(dirname "$0")/config.sh"

# 获取当前分支名
CURRENT_BRANCH=$(git branch --show-current)

echo "当前分支: $CURRENT_BRANCH"
echo "准备创建actions分支..."

# 检查actions分支是否存在
if git show-ref --verify --quiet refs/heads/actions; then
    echo "actions分支已存在，正在删除..."
    git branch -D actions
fi

# 从当前分支创建新的actions分支（不切换）
echo "从 $CURRENT_BRANCH 创建新的actions分支..."
git branch actions

# 强制推送到远程
echo "强制推送actions分支到远程..."
git push -f origin actions

echo "✓ actions分支已创建并推送到远程仓库"