#!/bin/bash
# setup-cron.sh — 交互式设置定时任务

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "⏰ 设置定时任务"
echo ""
echo "请选择执行频率："
echo "  1) 每天早上 8:00"
echo "  2) 每天早晚各一次（8:00 和 18:00）"
echo "  3) 每 6 小时一次"
echo "  4) 自定义 cron 表达式"
echo ""
read -rp "输入数字 [1-4]，默认 1：" choice
choice=${choice:-1}

case "$choice" in
  1) CRON_EXP="0 8 * * *";   DESC="每天早上 8:00" ;;
  2) CRON_EXP="0 8,18 * * *"; DESC="每天 8:00 和 18:00" ;;
  3) CRON_EXP="0 */6 * * *";  DESC="每 6 小时" ;;
  4)
    read -rp "输入 cron 表达式（如 '0 9 * * 1-5' 表示工作日 9 点）：" CRON_EXP
    DESC="自定义：$CRON_EXP"
    ;;
  *) echo "无效选择"; exit 1 ;;
esac

LOG_FILE="$SCRIPT_DIR/monitor.log"
CRON_LINE="$CRON_EXP cd $SCRIPT_DIR && node monitor.js >> $LOG_FILE 2>&1"

# 写入 crontab（避免重复添加）
(crontab -l 2>/dev/null | grep -v "keyword-monitor"; echo "# keyword-monitor"; echo "$CRON_LINE") | crontab -

echo ""
echo -e "${GREEN}✅ 定时任务设置成功！${NC}"
echo ""
echo "   执行频率：$DESC"
echo "   日志文件：$LOG_FILE"
echo ""
echo "其他操作："
echo "  查看当前任务：crontab -l"
echo "  查看运行日志：tail -f $LOG_FILE"
echo "  立即手动运行：node $SCRIPT_DIR/monitor.js"
echo "  删除定时任务：crontab -e （手动删除对应行）"
echo ""
