#!/usr/bin/env node
// monitor.js — 核心执行脚本，不需要修改

const { execSync } = require("child_process");
const nodemailer = require("nodemailer");
const config = require("./config");

// ── SMTP 配置映射 ──────────────────────────────────
const SMTP_CONFIGS = {
  qq: {
    host: "smtp.qq.com",
    port: 465,
    secure: true,
  },
  163: {
    host: "smtp.163.com",
    port: 465,
    secure: true,
  },
  gmail: {
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
  },
};

// ── 执行 opencli 命令 ──────────────────────────────
function runSearch(platform, keyword) {
  try {
    const cmd = `opencli ${platform} search "${keyword}" -f json --limit ${config.options.limit}`;
    const output = execSync(cmd, {
      timeout: config.options.timeout,
      encoding: "utf-8",
      stdio: ["pipe", "pipe", "pipe"],
    });
    const data = JSON.parse(output.trim());
    const arr = Array.isArray(data) ? data : [data];
    return arr.map((item) => ({ ...item, _platform: platform, _keyword: keyword }));
  } catch (err) {
    const code = err.status;
    // opencli 退出码含义
    const reasons = {
      69: "Browser Bridge 未连接（请确认 Chrome 扩展已启动）",
      77: `未登录 ${platform}（请先在 Chrome 中登录）`,
      66: "暂无数据",
      75: "请求超时",
    };
    const reason = reasons[code] || `未知错误 (exit ${code})`;
    console.warn(`  ⚠️  [${platform}] "${keyword}" — ${reason}`);
    return [];
  }
}

// ── 生成 HTML 邮件内容 ─────────────────────────────
function buildEmailHTML(results) {
  const date = new Date().toLocaleString("zh-CN", { timeZone: "Asia/Shanghai" });
  const totalCount = results.length;

  // 按平台分组
  const grouped = results.reduce((acc, item) => {
    const key = item._platform;
    if (!acc[key]) acc[key] = [];
    acc[key].push(item);
    return acc;
  }, {});

  const PLATFORM_NAMES = {
    zhihu: "知乎",
    weibo: "微博",
    xiaohongshu: "小红书",
    twitter: "Twitter/X",
    reddit: "Reddit",
    hackernews: "Hacker News",
    v2ex: "V2EX",
    github: "GitHub",
  };

  const sections = Object.entries(grouped)
    .map(([platform, items]) => {
      const platformName = PLATFORM_NAMES[platform] || platform;
      const rows = items
        .map((item) => {
          const title = item.title || item.name || item.text || JSON.stringify(item).slice(0, 80);
          const url = item.url || item.link || "#";
          const desc = item.desc || item.excerpt || item.content || "";
          const keyword = item._keyword;
          // 高亮关键词
          const highlight = (str) =>
            str.replace(
              new RegExp(`(${keyword})`, "gi"),
              '<mark style="background:#fff3cd;padding:0 2px;border-radius:2px">$1</mark>'
            );
          return `
          <tr style="border-bottom:1px solid #f0f0f0">
            <td style="padding:12px 16px;vertical-align:top;width:80px">
              <span style="background:#e8f4fd;color:#1a73e8;padding:2px 8px;border-radius:10px;font-size:12px;white-space:nowrap">
                ${keyword}
              </span>
            </td>
            <td style="padding:12px 16px;vertical-align:top">
              <a href="${url}" style="color:#1a1a1a;font-weight:500;text-decoration:none;font-size:14px;line-height:1.5">
                ${highlight(title)}
              </a>
              ${desc ? `<p style="color:#666;font-size:13px;margin:4px 0 0;line-height:1.6">${highlight(desc.slice(0, 120))}${desc.length > 120 ? "…" : ""}</p>` : ""}
            </td>
          </tr>`;
        })
        .join("");

      return `
      <div style="margin-bottom:32px">
        <h3 style="margin:0 0 12px;font-size:15px;color:#333;display:flex;align-items:center;gap:8px">
          <span style="width:4px;height:18px;background:#1a73e8;display:inline-block;border-radius:2px"></span>
          ${platformName}
          <span style="font-size:12px;color:#999;font-weight:normal">${items.length} 条结果</span>
        </h3>
        <table style="width:100%;border-collapse:collapse;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,0.08)">
          ${rows}
        </table>
      </div>`;
    })
    .join("");

  return `
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="margin:0;padding:0;background:#f5f7fa;font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Microsoft YaHei',sans-serif">
  <div style="max-width:680px;margin:0 auto;padding:24px 16px">

    <!-- 头部 -->
    <div style="background:linear-gradient(135deg,#1a73e8,#0d47a1);border-radius:12px;padding:24px 28px;margin-bottom:24px;color:#fff">
      <div style="font-size:13px;opacity:0.8;margin-bottom:4px">关键词监控报告</div>
      <div style="font-size:22px;font-weight:600">${date}</div>
      <div style="margin-top:12px;font-size:14px;opacity:0.9">
        共发现 <strong>${totalCount}</strong> 条结果 &nbsp;·&nbsp;
        关键词：${[...new Set(results.map((r) => r._keyword))].map((k) => `<span style="background:rgba(255,255,255,0.2);padding:1px 8px;border-radius:10px">${k}</span>`).join(" ")}
      </div>
    </div>

    <!-- 结果区 -->
    ${sections}

    <!-- 底部 -->
    <div style="text-align:center;color:#bbb;font-size:12px;margin-top:16px">
      由 keyword-monitor + opencli 自动生成 · 如需修改配置请编辑 config.js
    </div>
  </div>
</body>
</html>`;
}

// ── 发送邮件 ───────────────────────────────────────
async function sendEmail(html, resultCount) {
  const smtpConfig = SMTP_CONFIGS[config.email.provider] || SMTP_CONFIGS.qq;
  const transporter = nodemailer.createTransport({
    ...smtpConfig,
    auth: {
      user: config.email.from,
      pass: config.email.authCode,
    },
  });

  const subject = `[关键词监控] ${resultCount} 条新结果 · ${new Date().toLocaleDateString("zh-CN")}`;

  await transporter.sendMail({
    from: `"关键词监控" <${config.email.from}>`,
    to: config.email.to,
    subject,
    html,
  });
}

// ── 主流程 ─────────────────────────────────────────
async function main() {
  console.log("🔍 开始关键词监控...\n");
  console.log(`   平台：${config.platforms.join(", ")}`);
  console.log(`   关键词：${config.keywords.join(", ")}\n`);

  const allResults = [];

  for (const platform of config.platforms) {
    for (const keyword of config.keywords) {
      process.stdout.write(`  搜索 [${platform}] "${keyword}"...`);
      const results = runSearch(platform, keyword);
      process.stdout.write(` ${results.length} 条\n`);
      allResults.push(...results);
    }
  }

  console.log(`\n📊 共找到 ${allResults.length} 条结果`);

  if (allResults.length === 0 && !config.options.sendWhenEmpty) {
    console.log("   没有结果，跳过发送邮件（可在 config.js 中修改 sendWhenEmpty）");
    return;
  }

  console.log("📧 正在发送邮件...");
  const html = buildEmailHTML(allResults);
  await sendEmail(html, allResults.length);
  console.log(`✅ 邮件已发送至 ${config.email.to}`);
}

main().catch((err) => {
  console.error("❌ 执行失败:", err.message);
  process.exit(1);
});
