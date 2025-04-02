#!/bin/bash
set -e

# 导入配置
source "$(dirname "$0")/config.sh"

# 检查参数数量
if [ $# -lt 3 ]; then
    echo "用法: $0 <docker目录> <镜像名称> <标签1> [标签2] [标签3] ..."
    echo "示例: $0 fdroidserver aoeiuv020/fdroidserver 3.0.0 3.0 3"
    exit 1
fi

# 获取参数
DOCKER_DIR="$1"
IMAGE_NAME="$2"
shift 2  # 移除前两个参数，剩下的都是标签

# 检查目录是否存在
DOCKER_PATH="${REPO_ROOT}/docker/${DOCKER_DIR}"
if [ ! -d "$DOCKER_PATH" ]; then
    echo "错误: Docker目录不存在: $DOCKER_PATH"
    exit 1
fi

# 构建基础镜像
echo "正在从 ${DOCKER_PATH} 构建基础镜像..."
docker build -t "$IMAGE_NAME" "$DOCKER_PATH"

# 为每个标签创建镜像
for tag in "$@"; do
    echo "正在添加标签: $tag"
    docker tag "$IMAGE_NAME" "$IMAGE_NAME:$tag"
done

# 创建 latest 标签
echo "正在添加 latest 标签"
docker tag "$IMAGE_NAME" "$IMAGE_NAME:latest"

echo "构建完成。已创建标签: $* latest"
