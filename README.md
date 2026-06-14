# OpenClaw Session Manager

一个本地运行的 OpenClaw 会话管理器，提供明亮简洁的管理界面。

## 项目背景

OpenClaw 目前缺少一个简洁直观的会话管理界面，查找、重命名或删除会话并不方便。
如果你不想为了管理会话安装多个第三方 OpenClaw 版本，或希望保持现有 OpenClaw
环境简洁纯净，可以使用本项目集中管理本机会话。

<p align="center">
  <img src="public/openclaw-logo.svg" width="96" alt="OpenClaw logo">
</p>

## 功能

- 查看、搜索并按 Agent 筛选会话
- 新增会话与修改会话名称
- 重置上下文、终止当前运行
- 删除会话，可选择同时删除转录文件
- 显示会话模型、更新时间及 Token 用量
- 仅监听 `127.0.0.1`

## 平台支持

| 运行方式 | macOS | Linux | Windows |
| --- | --- | --- | --- |
| 原生窗口 `.app` | 支持 | 不支持 | 不支持 |
| Web 模式 | 支持 | 应可运行，尚未全面测试 | 尚未测试 |

原生窗口使用 Swift、AppKit 和 WebKit，因此只支持 macOS。核心管理服务使用
Node.js，结构上不依赖 macOS，但 Linux 和 Windows 仍需要更多实际测试与路径适配。

## 环境要求

- OpenClaw 已安装并完成初始化
- Node.js 22 或更高版本
- 构建 macOS App：macOS 12+ 与 Xcode Command Line Tools

写操作通过 OpenClaw Gateway 官方会话接口执行。如果提示设备配对，请在 OpenClaw
控制面板的 **Devices / 设备** 页面批准 CLI 设备。

## Web 模式

```bash
npm start
```

然后访问 <http://127.0.0.1:43110>。

如 OpenClaw CLI 不在常见路径：

```bash
OPENCLAW_CLI=/path/to/openclaw npm start
```

## 构建 macOS App

```bash
npm run build:macos
```

应用生成于：

```text
build/OpenClaw 会话管理器.app
```

构建并安装到 `/Applications`：

```bash
npm run install:macos
```

构建脚本会从 SVG Logo 自动生成应用图标。macOS App 使用本机签名，仅用于本地运行。对外分发时应使用 Apple Developer
证书签名并进行公证。

## 项目结构

```text
public/               Web UI
server.mjs            本地服务与 OpenClaw CLI/Gateway 适配
macos/                原生 macOS WebKit 窗口
scripts/              构建与安装脚本
```

## 安全说明

- 服务仅绑定本机回环地址。
- 不会将 OpenClaw 会话数据发送到外部服务器。
- 删除和重置属于破坏性操作，执行前会要求确认。

## License

[MIT](LICENSE)
