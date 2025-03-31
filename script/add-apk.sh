#!/bin/bash

# 定义变量
source "$(dirname "$0")/config.sh"

# 检查参数
if [ $# -lt 1 ]; then
  echo "错误: 请提供APK下载地址"
  echo "用法: $0 <APK下载地址>"
  exit 1
fi

# 获取APK下载地址
APK_URL="$1"

# 从URL中提取文件名
APK_FILENAME=$(basename "$APK_URL")

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 下载APK到repo目录
echo "正在下载APK: $APK_FILENAME..."
mkdir -p "$FDROID_ROOT/repo"
cd "$FDROID_ROOT/repo" || exit 1

curl -L -o "$APK_FILENAME" "$APK_URL"

if [ $? -ne 0 ]; then
  echo "错误: APK下载失败"
  exit 1
fi

echo "APK下载完成: $APK_FILENAME"

# 返回F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 执行fdroid命令处理APK
echo "正在处理APK..."
"$SCRIPT_DIR/update-fdroid.sh"

if [ $? -ne 0 ]; then
  echo "错误: F-Droid处理APK失败"
  exit 1
fi

echo "APK处理完成"
echo "操作完成"