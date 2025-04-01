#!/bin/bash

# 定义变量，
source "$(dirname "$0")/config.sh"

# 运行docker命令
echo "正在运行F-Droid..."
# 这里不能-u指定用户，会导致HOME变化导致fdroid内部报git错误，
docker run --rm -v $(pwd):/repo $(docker build -q $REPO_ROOT/docker/fdroidserver) "$@"

if [ $? -eq 0 ]; then
  echo "F-Droid运行完成"
else
  echo "错误: F-Droid运行失败"
  exit 1
fi

echo "操作完成"