# Tool 与契约

- Agent 上声明的 tools **语义上对应** [前端与扩展](../../client-extension/index.md) 中的「类 API」（含 [发送消息与 UI 宏](../../client-extension/send-message-macro/index.md) 等）。  
- **默认不在 Python 内执行**这些 tool 的页面副作用；产出 **可序列化调用意图**，经 **WebSocket** 下发给扩展（载荷见 [通信与协议](../../protocol/index.md)）。  
- **契约**：tool 名、参数 schema 与扩展注册表一致；变更需版本或兼容策略。

全局数据流：[架构与数据流](../../architecture/index.md)。
