#!/bin/bash
set -e

# 获取参数
ORIGINAL_APK_PATH="$1"
TARGET_REPO="$2"
BRANCH="$3"
GITHUB_TOKEN="$4"

# 将APK路径转换为绝对路径，避免目录切换后路径失效
if [[ "$ORIGINAL_APK_PATH" == /* ]]; then
    # 已经是绝对路径
    APK_PATH="$ORIGINAL_APK_PATH"
else
    # 相对路径转换为绝对路径
    APK_PATH="$(pwd)/$ORIGINAL_APK_PATH"
fi

# 打印参数信息
echo "APK路径: $APK_PATH"
echo "目标仓库: $TARGET_REPO"
echo "分支: $BRANCH"
echo "GitHub Token: ***"

FDROID_CMD=${FDROID_CMD:-/home/vagrant/fdroidserver/fdroid}
if ! command -v $FDROID_CMD &> /dev/null; then
    echo "错误: fdroidserver未安装"
    exit 1
fi

# 创建临时目录
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# 克隆目标仓库
echo "正在克隆目标仓库..."
git clone --depth 1 --branch "$BRANCH" "https://${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git" fdroid-repo
if [ $? -ne 0 ]; then
    echo "错误: 克隆目标仓库失败"
    exit 1
fi
cd fdroid-repo

# 检查repo目录是否存在，如果不存在则创建
if [ ! -d "repo" ]; then
    mkdir -p repo
fi

# 复制APK到repo目录
echo "正在复制APK到repo目录..."
cp "$APK_PATH" repo/

# 配置Git用户信息
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

# 运行fdroid update命令
echo "正在运行fdroid update命令..."
$FDROID_CMD update --create-metadata --pretty --use-date-from-apk --rename-apks --clean

# 提交并推送更改
echo "正在提交并推送更改..."
git add .
git commit -m "update: F-Droid repo update $(date +%Y-%m-%d)"
git push

echo "APK已成功上传到F-Droid仓库"
