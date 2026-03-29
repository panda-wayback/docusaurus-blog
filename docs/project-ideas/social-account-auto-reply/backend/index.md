# 后端（Pydantic AI）

## 主框架

- 使用 **[Pydantic AI](https://ai.pydantic.dev/)** 承载智能体：模型选择、依赖注入、结构化输出等。  

## 重心：记忆体

- **会话 / 长期记忆**的配置与持久化是后端主要工作：按租户、平台账号、会话维度存历史与事实，保证每次推理上下文一致、可审计。  
- 与 [产品与变现](../product/index.md) 中的「多账号、团队」档位设计会互相影响（隔离模型、配额）。

## Tool 与前端的关系

- 在 Agent 上声明的 tools 语义上对应 [前端与扩展](../client-extension/index.md) 里的「类 API」能力。  
- **默认不在 Python 进程内执行这些 tool 的真实副作用**；推理产出的是**可序列化的调用意图**，经 **WebSocket** 下发给扩展执行（载荷形状见 [通信与协议](../protocol/index.md)）。  
- **工具契约**：tool 名称、参数 schema 与前端注册表保持一致；变更要有版本或兼容策略（在协议区细化）。

## 与架构备忘的衔接

数据流总览见 [架构与数据流](../architecture/index.md)；消息长什么样见 [通信与协议](../protocol/index.md)。
