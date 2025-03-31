#!/bin/bash

# 导入配置
source "$(dirname "$0")/config.sh"

# 进入F-Droid目录
cd "$FDROID_ROOT" || exit 1

# 推送F-Droid目录的更改到gh-pages分支
echo "推送F-Droid更新到gh-pages分支..."
git push -u origin gh-pages

if [ $? -ne 0 ]; then
  echo "错误: F-Droid目录推送失败"
  exit 1
fi

# 返回仓库根目录推送submodule更新
cd "$REPO_ROOT" || exit 1
echo "推送submodule更新..."
git push

if [ $? -ne 0 ]; then
  echo "错误: Submodule推送失败"
  exit 1
fi

echo "所有更新已成功推送"