#!/usr/bin/env bash
# ============================================================
# 一键推送工作台到 GitHub
# 用法：把本文件所在文件夹整个上传到你的电脑，然后运行：
#   ./push-to-github.sh
# 前提：电脑已安装 git，且 GitHub 账号已配置（见部署指南第一步）
# ============================================================
set -e
cd "$(dirname "$0")"

REPO_URL="https://github.com/janelinling7/workbench.git"
BRANCH="main"

echo "🚀 开始推送工作台到 GitHub 仓库：$REPO_URL"
echo

# 1. 初始化仓库（如果还没有）
if [ ! -d .git ]; then
  git init -b "$BRANCH"
  echo "✅ git init 完成"
else
  echo "⏭ 已存在 git 仓库，跳过 init"
fi

# 2. 添加远程地址
if git remote | grep -q "^origin$"; then
  git remote set-url origin "$REPO_URL"
else
  git remote add origin "$REPO_URL"
fi
echo "✅ 远程地址已设置为 $REPO_URL"

# 3. 暂存并提交
git add .
if git diff --cached --quiet; then
  echo "⏭ 没有需要提交的更改"
else
  git commit -m "✨ 更新自由职业工作台"
  echo "✅ 提交完成"
fi

# 4. 推送
echo
echo "⬆ 正在推送到 GitHub（首次会要求输入 GitHub 用户名和 Token/密码）..."
git push -u origin "$BRANCH" 2>&1 || {
  echo
  echo "⚠️ 推送失败。常见原因与解决："
  echo "  1) 远程仓库还没创建 → 先按部署指南第一步在 GitHub 网页创建空仓库"
  echo "  2) 远程已有文件（如自动生成的 README）→ 执行下面的命令合并后再推送："
  echo "     git pull origin $BRANCH --allow-unrelated-histories"
  echo "     git push -u origin $BRANCH"
  exit 1
}

echo
echo "🎉 推送成功！仓库地址：https://github.com/janelinling7/workbench"
echo "   接下来去 Vercel 导入部署（见部署指南第二步）"
