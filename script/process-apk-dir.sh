#!/bin/bash

# 导入配置
source "$(dirname "$0")/config.sh"

echo "开始处理 APK 目录"
mkdir -p "$FDROID_ROOT/repo"

# 初始化计数器
processed_files=0

# 遍历apk目录中的文件
for file in "$REPO_ROOT/apk"/*; do
    [ ! -f "$file" ] && continue
    
    filename=$(basename "$file")
    
    # 处理.apk文件
    if [[ "$filename" == *.apk ]]; then
        echo "处理APK: $filename"
        mv "$file" "$FDROID_ROOT/repo/"
        processed_files=$((processed_files + 1))
        
    # 处理.txt文件
    elif [[ "$filename" == *.txt ]]; then
        echo "处理URL文件: $filename"
        while IFS= read -r line || [ -n "$line" ]; do
            [ -z "$line" ] && continue
            
            if [[ "$line" =~ ^https?:// ]]; then
                echo "下载URL: $line"
                cd "$FDROID_ROOT/repo" || exit 1
                APK_FILENAME=$(curl -LOJw '%{filename_effective}' "$line")
                if [ $? -eq 0 ]; then
                    echo "下载成功: $APK_FILENAME"
                    cd - > /dev/null || exit 1
                    processed_files=$((processed_files + 1))
                else
                    echo "下载失败: $line"
                fi
            else
                echo "跳过无效URL: $line"
            fi
        done < "$file"
        echo "删除URL文件: $filename"
        rm "$file"
    fi
done

if [ $processed_files -gt 0 ]; then
    echo "完成处理，共处理 $processed_files 个文件"
    exit 0
else
    echo "无文件需要处理"
    exit 1
fi