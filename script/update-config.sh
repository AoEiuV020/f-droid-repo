#!/bin/bash

# 定义变量
source "$(dirname "$0")/config.sh"

# 检查参数
if [ $# -lt 1 ]; then
  echo "错误: 请提供仓库名称"
  echo "用法: $0 <仓库名称>"
  echo "例如: $0 username/repo"
  exit 1
fi

# 获取仓库名称
REPO="$1"

# 检查仓库名称格式
if [[ ! "$REPO" =~ ^[^/]+/[^/]+$ ]]; then
  echo "错误: 仓库名称格式不正确，应为 'username/repo'"
  exit 1
fi

# 拆分仓库名称
USERNAME=$(echo "$REPO" | cut -d'/' -f1)
REPONAME=$(echo "$REPO" | cut -d'/' -f2)

# 拼接GitHub Pages URL
REPO_URL="https://${USERNAME}.github.io/${REPONAME}/repo"

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 检查config.yml是否存在
if [ ! -f "config.yml" ]; then
  echo "错误: config.yml文件不存在，请先运行init-fdroid.sh初始化F-Droid仓库"
  exit 1
fi

# 更新config.yml文件
echo "正在更新config.yml文件..."

# 创建临时文件
TEMP_FILE=$(mktemp)

# 删除旧的repo_url, repo_name, repo_description配置项，并写入新的配置项
grep -v "^repo_url:\|^repo_name:\|^repo_description:" config.yml > "$TEMP_FILE"

# 在文件末尾添加新的配置项
echo "repo_url: ${REPO_URL}" >> "$TEMP_FILE"
echo "repo_name: ${USERNAME}" >> "$TEMP_FILE"
echo "repo_description: ${USERNAME}的FDroid仓库" >> "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" config.yml

echo "config.yml文件更新完成"
echo "仓库URL: ${REPO_URL}"
echo "仓库名称: ${USERNAME}"
echo "仓库描述: ${USERNAME}的FDroid仓库"