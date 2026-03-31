#!/bin/bash
# install-extension.sh — 自动下载并准备 opencli Chrome 扩展
# 运行：bash install-extension.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

INSTALL_DIR="$HOME/.opencli-extension"

echo ""
echo "╔════════════════════════════════════╗"
echo "║     下载 opencli Chrome 扩展       ║"
echo "╚════════════════════════════════════╝"
echo ""

# 获取最新 release 下载地址
echo "▸ 正在获取最新版本信息..."
RELEASE_URL="https://api.github.com/repos/jackwener/opencli/releases/latest"

# 尝试用 curl 获取下载链接
if command -v curl &>/dev/null; then
  DOWNLOAD_URL=$(curl -s "$RELEASE_URL" \
    | grep "browser_download_url" \
    | grep "opencli-extension.zip" \
    | head -1 \
    | sed 's/.*"browser_download_url": "\(.*\)".*/\1/')
else
  echo -e "${RED}✗ 未找到 curl，请手动下载扩展${NC}"
  echo "  下载地址：https://github.com/jackwener/opencli/releases"
  exit 1
fi

if [ -z "$DOWNLOAD_URL" ]; then
  echo -e "${YELLOW}⚠  无法自动获取下载链接，请手动下载${NC}"
  echo ""
  echo "  手动步骤："
  echo "  1. 打开 https://github.com/jackwener/opencli/releases"
  echo "  2. 下载最新版本的 opencli-extension.zip"
  echo "  3. 解压后在 Chrome 中加载"
  exit 1
fi

echo -e "${GREEN}✓ 找到最新版本${NC}"
echo "  下载地址：$DOWNLOAD_URL"
echo ""

# 下载
echo "▸ 正在下载扩展文件..."
mkdir -p "$INSTALL_DIR"
curl -L "$DOWNLOAD_URL" -o "$INSTALL_DIR/opencli-extension.zip"
echo -e "${GREEN}✓ 下载完成${NC}"

# 解压
echo "▸ 正在解压..."
unzip -q -o "$INSTALL_DIR/opencli-extension.zip" -d "$INSTALL_DIR/extension"
rm "$INSTALL_DIR/opencli-extension.zip"
echo -e "${GREEN}✓ 解压完成${NC}"

EXTENSION_PATH="$INSTALL_DIR/extension"

echo ""
echo "════════════════════════════════════"
echo ""
echo -e "${GREEN}✅ 扩展文件已准备好！${NC}"
echo ""
echo "接下来需要你手动在 Chrome 里加载（30 秒搞定）："
echo ""
echo "  1. 打开 Chrome，地址栏输入："
echo -e "     ${YELLOW}chrome://extensions${NC}"
echo ""
echo "  2. 右上角打开「开发者模式」"
echo ""
echo "  3. 点击「加载已解压的扩展程序」"
echo "     选择这个文件夹："
echo -e "     ${YELLOW}$EXTENSION_PATH${NC}"
echo ""
echo "  4. 扩展出现在列表中即安装成功"
echo ""
echo "装好之后，回到终端运行以下命令验证连接："
echo ""
echo "     opencli doctor"
echo ""
