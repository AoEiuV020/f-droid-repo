# F-Droid 私有仓库模板

用于创建和管理自己的 F-Droid 软件仓库，支持 GitHub Actions 自动化部署。

<a href="https://AoEiuV020.github.io/f-droid-repo/repo"><img alt="Get it on F-Droid" src="https://f-droid.org/badge/get-it-on.svg" width="200px"/>

## 快速开始

### 初始化设置

1. 初始化仓库：
```bash
./script/init.sh AoEiuV020/f-droid-repo
```
该命令会：
- 初始化 gh-pages 分支
- 创建 F-Droid 仓库基础结构
- 生成签名密钥（会显示私钥密码等，要配置到[actions密钥](https://github.com/AoEiuV020/f-droid-repo/settings/secrets/actions)）

2. 初始化 GitHub Actions：
```bash
./script/init-actions.sh
```
该命令会创建 actions 分支（从 main 分支复制），用于接收外部 APK 上传。

## 使用方法

### 方式一：通过 GitHub Actions（CI/CD）

在其他项目的工作流程中添加以下步骤：

```yaml
- name: 推送到 F-Droid 仓库
  uses: AoEiuV020/f-droid-repo/actions/push-fdroid@main
  with:
    apk-path: ./your-app.apk
    target-repo: AoEiuV020/f-droid-repo
    github-token: ${{ secrets.FDROID_REPO_TOKEN }} # 这个token需要拥有target-repo仓库的写入权限，
```

### 方式二：本地开发

1. 更新子模块（gh-pages 分支）：
```bash
git submodule init fdroid && git submodule update --remote --merge fdroid
```

2. 配置签名：
   - 将 `keystore.p12` 文件放在 `fdroid` 目录下
   - 编辑 `fdroid/config.yml`，添加签名配置：
```yaml
repo_keyalias: KEYALIAS
keystore: keystore.p12
keystorepass: KEYSTOREPASS
keypass: KEYPASS
keydname: KEYDNAME
```

3. 更新仓库配置：
```bash
script/update-config.sh AoEiuV020/f-droid-repo
```

4. 添加 APK 并更新仓库：
   - 将 APK 文件复制到 `fdroid/repo/` 目录
   - 执行以下命令更新仓库：
```bash
script/update-fdroid.sh
script/commit-fdroid.sh
script/push-fdroid.sh
```

### 方式三：手动运行 GitHub Actions

1. 访问仓库的 Actions 页面：[manual-push-apk](https://github.com/AoEiuV020/f-droid-repo/actions/workflows/manual-push-apk.yml)
2. 点击 "Run workflow" 按钮
3. 在弹出的表单中输入 APK 下载地址
4. 点击 "Run workflow" 确认运行

workflow 会自动下载 APK 并更新 F-Droid 仓库。
