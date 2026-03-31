# 📬 keyword-monitor

> 定期搜索关键词，自动把结果发到你的邮箱。
> 基于 [opencli](https://github.com/jackwener/opencli) 构建，**开箱即用，只需填一个配置文件**。

---

## ✨ 效果预览

每次运行后，你会收到一封这样的邮件：

- 📌 按平台分组展示结果
- 🔍 关键词自动高亮
- 🔗 标题可直接点击跳转原文
- 📊 汇总当天共找到多少条

---

## 🚀 快速开始（三步）

### 第一步：克隆项目

```bash
git clone https://github.com/你的用户名/keyword-monitor.git
cd keyword-monitor
```

### 第二步：一键配置环境

```bash
bash setup.sh
```

这个脚本会自动：检查 Node.js 版本、安装 opencli、安装项目依赖。

### 第三步：填写配置文件

用任意文本编辑器打开 `config.js`，修改以下内容：

```js
keywords: ["AI Agent", "大模型"],   // ← 改成你想监控的词

platforms: ["zhihu", "weibo"],      // ← 选择平台

email: {
  from: "你的邮箱@qq.com",          // ← 发件邮箱
  to:   "你的邮箱@qq.com",          // ← 收件邮箱
  authCode: "xxxx",                  // ← SMTP 授权码（见下方说明）
  provider: "qq",                    // ← qq 或 163
}
```

---

## 📮 如何获取 SMTP 授权码

> **授权码不是你的邮箱登录密码**，是专门给第三方应用用的独立密码。

### QQ 邮箱
1. 打开 [mail.qq.com](https://mail.qq.com)，登录后点右上角【设置】
2. 点【账户】选项卡，找到【POP3/IMAP/SMTP/Exchange/CardDAV/CalDAV服务】
3. 开启【SMTP服务】，按提示用手机短信验证
4. 复制生成的授权码（格式类似 `abcdefghijklmnop`）粘贴到 `config.js`

### 163 邮箱
1. 打开 [mail.163.com](https://mail.163.com)，登录后点顶部【设置】→【POP3/SMTP/IMAP】
2. 开启【SMTP服务】
3. 按提示设置授权码

---

## 🌐 平台说明

| 平台 | 配置名 | 是否需要 Chrome 登录 |
|---|---|---|
| 知乎 | `zhihu` | ✅ 需要 |
| 微博 | `weibo` | ✅ 需要 |
| 小红书 | `xiaohongshu` | ✅ 需要 |
| Twitter/X | `twitter` | ✅ 需要 |
| Reddit | `reddit` | ✅ 需要 |
| Hacker News | `hackernews` | ❌ 不需要 |
| V2EX | `v2ex` | ❌ 不需要 |
| GitHub | `github` | ❌ 不需要 |

> ⚠️ **需要 Chrome 登录的平台**：运行前请确保 Chrome 已打开并登录对应网站，且安装了 opencli 的 Browser Bridge 扩展。

---

## 🔌 安装 Browser Bridge 扩展（需要浏览器平台必读）

1. 前往 [opencli GitHub Releases](https://github.com/jackwener/opencli/releases) 下载最新的 `opencli-extension.zip`
2. 解压后打开 Chrome，访问 `chrome://extensions`
3. 右上角开启【开发者模式】
4. 点击【加载已解压的扩展程序】，选择解压后的文件夹
5. 扩展安装完成，后续会自动连接

验证连接：
```bash
opencli doctor
```

---

## ▶️ 运行与测试

### 手动运行一次（推荐先测试）

```bash
node monitor.js
```

正常输出示例：
```
🔍 开始关键词监控...

   平台：zhihu, weibo
   关键词：AI Agent, 大模型

  搜索 [zhihu] "AI Agent"... 8 条
  搜索 [zhihu] "大模型"... 10 条
  搜索 [weibo] "AI Agent"... 5 条
  搜索 [weibo] "大模型"... 7 条

📊 共找到 30 条结果
📧 正在发送邮件...
✅ 邮件已发送至 your@qq.com
```

### 设置定时任务（自动运行）

```bash
bash setup-cron.sh
```

按提示选择运行频率（每天一次 / 每天两次 / 每6小时等）。

查看运行日志：
```bash
tail -f monitor.log
```

---

## ❓ 常见问题

**Q：搜索结果为空怎么办？**
请先检查 Chrome 是否已登录对应平台，然后运行 `opencli doctor` 检查扩展连接状态。

**Q：提示 "Extension not connected"？**
确认 Browser Bridge 扩展已安装并启用（在 `chrome://extensions` 中检查）。

**Q：邮件发送失败？**
1. 确认授权码正确（不是登录密码）
2. 确认 SMTP 服务已开启
3. 检查 `config.js` 中的 `provider` 是否与邮箱类型匹配（qq 或 163）

**Q：Node.js 版本不够怎么办？**
前往 [nodejs.org](https://nodejs.org/zh-cn/) 下载 LTS 版本（>= 20）。

---

## 📁 文件说明

```
keyword-monitor/
├── config.js        ← ⭐ 只需要改这个文件
├── monitor.js       ← 核心执行脚本
├── setup.sh         ← 一键环境配置
├── setup-cron.sh    ← 定时任务设置
├── package.json
└── README.md
```

---

## 📄 License

MIT
