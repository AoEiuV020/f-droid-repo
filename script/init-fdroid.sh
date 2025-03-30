#!/bin/bash

# 定义变量，
source "$(dirname "$0")/config.sh"

cd "$REPO_ROOT" || exit 1

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 删除config.yml和keystore.p12文件（如果存在）
echo "正在删除旧的配置文件..."
rm -f config.yml keystore.p12

# 执行fdroid init
echo "正在初始化F-Droid仓库..."
$FDROID_CMD init

if [ $? -ne 0 ]; then
  echo "错误: F-Droid仓库初始化失败"
  exit 1
fi

echo "F-Droid仓库初始化完成"

# 输出config.yml中的密钥信息
echo "输出config.yml中的密钥信息："
# 转换并输出keystore文件base64编码
echo -n "keystore=" && cat "keystore.p12" | base64 | tr -d '\n' && echo
# 使用sed命令提取配置文件中的密钥相关信息
egrep "^(keystorepass|keypass|repo_keyalias|keydname)" config.yml
