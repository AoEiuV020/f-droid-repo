#!/bin/bash

# F-Droid仓库配置文件
# 此文件包含所有脚本共享的变量

# 仓库根目录
# 如果REPO_ROOT已经设置，则不修改
echo "${BASH_SOURCE[0]}"
if [ -z "${REPO_ROOT}" ]; then
    REPO_ROOT="$(cd $(dirname "${BASH_SOURCE[0]}") && cd .. && pwd)"
fi
# 脚本目录
SCRIPT_DIR="${REPO_ROOT}/script"

# F-Droid子模块名称
FDROID_DIR="fdroid"

# F-Droid仓库位置
FDROID_ROOT="${REPO_ROOT}/${FDROID_DIR}"

# 检查fdroid命令是否存在
if command -v fdroid >/dev/null 2>&1; then
  FDROID_CMD="fdroid"
else
  FDROID_CMD="$SCRIPT_DIR/fdroid-docker.sh"
fi
