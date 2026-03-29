---
sidebar_position: 0
---

# 前端与扩展

## 「类 API」与协作方式

- 扩展内实现**一组能力**（原子或宏），每个能力有稳定名称与参数约定，集中注册，便于后端经 WebSocket 派发。  
- 与后端维持 **WebSocket（WSS）**（见 [通信与协议](../protocol/index.md)）：**上报观测**、**接收指令**、**回传执行结果**，供服务端 agent 循环使用。

## 子文档（按功能拆开，避免单页堆叠）

| 子区 | 内容 |
|------|------|
| [新消息上行](./inbound-messages/index.md) | 「对方向我发消息」的识别与上报字段 |
| [发送消息与 UI 宏](./send-message-macro/index.md) | 「向某人发消息」语义、连环 UI、宏 vs 原子 tool |
| [工程与运行时备忘](./engineering-notes/index.md) | Manifest V3、DOM 适配优先级等 |

与后端记忆体、画像、tool 契约的衔接见 [后端各子页](../backend/index.md)。
