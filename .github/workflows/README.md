# GitHub Actions 自动部署说明

## 📋 配置说明

这个工作流会在以下情况下自动触发部署：

1. **自动触发**：每次推送代码到 `main` 分支时
2. **手动触发**：在 GitHub 仓库的 Actions 页面手动运行

## 🚀 使用方法

### 首次设置

1. **确保 GitHub Pages 已启用**
   - 进入你的 GitHub 仓库
   - 点击 `Settings` > `Pages`
   - Source 选择 `Deploy from a branch`
   - Branch 选择 `gh-pages` 分支

2. **提交并推送代码**
   ```bash
   git add .
   git commit -m "Add GitHub Actions auto deploy"
   git push origin main
   ```

3. **查看部署状态**
   - 进入 GitHub 仓库的 `Actions` 标签页
   - 查看工作流运行状态

### 日常使用

现在，每次你提交代码到 main 分支，都会自动触发部署：

```bash
# 1. 修改代码后提交
git add .
git commit -m "你的提交信息"

# 2. 推送到 GitHub（会自动触发部署）
git push origin main
```

## ⚙️ 工作流程

1. 检出代码
2. 设置 Node.js 20 环境
3. 安装 pnpm
4. 缓存依赖（加速构建）
5. 安装项目依赖
6. 配置 Git 用户信息
7. 运行 `pnpm run deploy` 部署到 GitHub Pages

## 🔍 故障排查

如果部署失败，请检查：

1. **GitHub Token 权限**：确保 GitHub Actions 有写入权限
2. **分支保护规则**：确保 Actions 可以推送到 gh-pages 分支
3. **构建错误**：查看 Actions 日志中的错误信息

## 📝 注意事项

- 工作流使用 HTTPS 方式推送到 gh-pages 分支
- 自动使用 GitHub Actions Bot 作为提交者
- 依赖缓存会加速后续构建

