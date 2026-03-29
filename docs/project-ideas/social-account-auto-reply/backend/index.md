---
sidebar_position: 0
---

# 后端（Pydantic AI）

服务端运行 **Pydantic AI** 智能体与**记忆体**；通过 **WebSocket** 接收扩展上报、下发 tool 调用。具体能力按下面子文档拆分，避免单页混杂。

## 子文档

| 子区 | 内容 |
|------|------|
| [Agent 框架](./agent-framework/index.md) | Pydantic AI 主框架选型 |
| [记忆体](./memory/index.md) | 会话与长期记忆的持久化边界 |
| [用户消息流水与画像](./user-chat-profile/index.md) | 按用户存消息、生成画像、驱动回复 |
| [Tool 与契约](./tools-contract/index.md) | 与扩展「类 API」对齐、经 WS 下发 |

全局数据流见 [架构与数据流](../architecture/index.md)；消息形状见 [通信与协议](../protocol/index.md)。
