# Agent 框架

- 使用 **[Pydantic AI](https://ai.pydantic.dev/)** 承载智能体：模型选择、依赖注入、结构化输出等。  
- **Agent 循环**跑在服务端进程内；与浏览器通过 [通信与协议](../../protocol/index.md) 约定的 **WebSocket** 交换观测与 tool 指令。

相关：[记忆体](../memory/index.md)、[Tool 与契约](../tools-contract/index.md)。
