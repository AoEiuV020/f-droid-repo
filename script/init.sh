#!/bin/bash

cd "$(dirname "$(dirname "$0")")" || exit 1

# 定义变量，
source "$(dirname "$0")/config.sh"
GITHUB_REPO="$1"

cd "$REPO_ROOT" || exit 1

# 检查参数
if [ -z "$GITHUB_REPO" ]; then
  echo "错误: 缺少必要参数"
  echo "使用方法: $0 <github用户名/仓库名>"
  exit 1
fi

# 步骤1: 删除F-Droid目录（如果存在）
if [ -e "$FDROID_ROOT" ]; then
  echo "正在删除F-Droid目录..."
  if ! rmdir "$FDROID_ROOT" 2>/dev/null; then
    echo "警告: F-Droid目录不是空目录或不是软链接，尝试强制删除"
    rm -rf "$FDROID_ROOT"
  fi
  echo "✓ F-Droid目录已删除"
else
  echo "信息: F-Droid目录不存在，跳过删除"
fi

# 步骤2: 删除F-Droid子模块（如果存在）
if git submodule status "$FDROID_DIR" &>/dev/null; then
  echo "正在删除F-Droid子模块..."
  git submodule deinit -f "$FDROID_DIR"
  git rm -f "$FDROID_DIR"
  rm -rf ".git/modules/$FDROID_DIR"
  echo "✓ F-Droid子模块已删除"
else
  echo "信息: F-Droid子模块不存在，跳过删除"
fi

# 步骤3: 添加F-Droid子模块
echo "正在添加F-Droid子模块..."
echo "信息: gh-pages分支不存在，正在尝试创建..."
"$SCRIPT_DIR/init-gh-pages.sh" "$GITHUB_REPO"

# 步骤4: 初始化F-Droid仓库
echo "正在初始化F-Droid仓库..."
"$SCRIPT_DIR/init-fdroid.sh"

# 输出密钥提示信息
echo "重要: 请将以上密钥变量添加到GitHub仓库设置中:"
echo "  - keystore"
echo "  - keystorepass"
echo "  - keypass"
echo "  - repo_keyalias"
echo "  - keydname"
echo "设置地址: https://github.com/${GITHUB_REPO}/settings/secrets/actions"

# 再次尝试添加子模块
echo "正在添加F-Droid子模块到本地仓库..."
git submodule add --force -b gh-pages "$GITHUB_URL" "$FDROID_DIR" 2>/dev/null
if [ $? -eq 0 ]; then
  echo "✓ F-Droid子模块添加成功"
else
  echo "错误: 无法添加F-Droid子模块"
  exit 1
fi

echo "✓ 所有操作已完成，F-Droid仓库初始化成功！"