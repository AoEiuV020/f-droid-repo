#!/bin/bash

# 导入配置
source "$(dirname "$0")/config.sh"

# 创建必要的目录
mkdir -p "$FDROID_ROOT/repo"

# 初始化计数器
processed_files=0

# 遍历apk目录中的文件
for file in "$REPO_ROOT/apk"/*; do
    if [ ! -f "$file" ]; then
        continue
    fi

    filename=$(basename "$file")
    
    # 处理.apk文件
    if [[ "$filename" == *.apk ]]; then
        echo "移动APK文件: $filename"
        mv "$file" "$FDROID_ROOT/repo/"
        processed_files=$((processed_files + 1))
        
    # 处理.txt文件
    elif [[ "$filename" == *.txt ]]; then
        echo "处理txt文件: $filename"
        # 读取第一行
        first_line=$(head -n 1 "$file")
        
        # 检查是否是URL（简单检查是否以http开头）
        if [[ "$first_line" =~ ^https?:// ]]; then
            echo "从URL下载APK: $first_line"
            cd "$FDROID_ROOT/repo" || exit 1
            APK_FILENAME=$(curl -LOJw '%{filename_effective}' "$first_line")
            if [ $? -eq 0 ]; then
                echo "APK下载成功: $APK_FILENAME"
                cd - > /dev/null || exit 1
                processed_files=$((processed_files + 1))
            else
                echo "错误: 从 $first_line 下载APK失败"
            fi
        else
            echo "错误: $filename 中不是有效的URL"
        fi
        
        # 删除处理过的txt文件
        rm "$file"
    fi
done

# 只有在实际处理了文件时才执行后续操作
if [ $processed_files -gt 0 ]; then
    # 执行fdroid更新命令
    echo "更新F-Droid仓库..."
    "$SCRIPT_DIR/update-fdroid.sh"

    # Git操作
    cd "$REPO_ROOT" || exit 1
    echo "提交更改到Git..."
    git add apk/
    git commit -m "feat: add new apks to f-droid repo"

    echo "处理完成，共处理了 $processed_files 个文件"
else
    echo "没有找到需要处理的文件，跳过更新和提交操作"
fi