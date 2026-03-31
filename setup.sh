#!/bin/bash
# setup.sh — 一键环境配置脚本
# 运行：bash setup.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════╗"
echo "║     keyword-monitor 环境配置       ║"
echo "╚════════════════════════════════════╝"
echo ""

# 检查 Node.js
echo "▸ 检查 Node.js..."
if ! command -v node &>/dev/null; then
  echo -e "${RED}✗ 未找到 Node.js，请先安装 Node.js >= 20${NC}"
  echo "  下载地址：https://nodejs.org/zh-cn/"
  exit 1
fi

NODE_VER=$(node -e "process.stdout.write(process.versions.node.split('.')[0])")
if [ "$NODE_VER" -lt 20 ]; then
  echo -e "${RED}✗ Node.js 版本过低（当前 v${NODE_VER}，需要 >= 20）${NC}"
  echo "  请升级：https://nodejs.org/zh-cn/"
  exit 1
fi
echo -e "${GREEN}✓ Node.js v$(node -v | tr -d v) 已就绪${NC}"

# 安装 opencli
echo ""
echo "▸ 安装 opencli..."
if command -v opencli &>/dev/null; then
  echo -e "${GREEN}✓ opencli 已安装$(opencli --version 2>/dev/null || true)${NC}"
else
  npm install -g @jackwener/opencli
  echo -e "${GREEN}✓ opencli 安装完成${NC}"
fi

# 安装项目依赖
echo ""
echo "▸ 安装项目依赖..."
npm install
echo -e "${GREEN}✓ 依赖安装完成${NC}"

# 检查 config.js 是否已配置
echo ""
echo "▸ 检查配置文件..."
if grep -q "your_address@qq.com" config.js; then
  echo -e "${YELLOW}⚠  请先编辑 config.js 填入你的邮箱和关键词！${NC}"
  echo ""
  echo "   必填项："
  echo "   1. email.from    — 发件邮箱"
  echo "   2. email.to      — 收件邮箱"
  echo "   3. email.authCode — SMTP 授权码（见 README）"
  echo "   4. keywords      — 你的关键词列表"
else
  echo -e "${GREEN}✓ 配置文件已填写${NC}"
fi

echo ""
echo "════════════════════════════════════"
echo ""
echo -e "${GREEN}✅ 环境配置完成！${NC}"
echo ""
echo "下一步："
echo "  1. 编辑 config.js 填入你的配置"
echo "  2. 运行 node monitor.js 测试"
echo "  3. 运行 bash setup-cron.sh 设置定时任务"
echo ""
