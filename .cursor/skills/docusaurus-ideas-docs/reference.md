# 参考：路径、链接、分层示例

路径相对仓库 `docs/`。

## 分层含义（与固定目录名无关）

| 层级 | 角色 |
|------|------|
| `ideas/index.md` | **分区总览**：轻量想法与立项项目列表、导航 |
| 项目根 `ideas/<project>/index.md` | **项目级汇总**：有哪些大块、链到各块 |
| 项目内 `…/<topic>/index.md` | **该块想法的汇总**：子主题列表 + 短摘要 |
| 更深子文件夹 | **局部方案、实现细节、深度思考** 等，宜一主题一夹 |

目录名按**你想表达的想法**起即可；下列树只是当前仓库里的**一个实例**。

## 示例树（ideas/，仅供参考）

```
ideas/
  index.md
  agent-memory-writable-artifacts/   # 短文 / 需求备忘
    index.md
  social-account-auto-reply/         # 立项级项目
    index.md
    architecture/index.md
    protocol/index.md
    backend/
      index.md
      …
```

## 相对链接

| 从 | 到 | 示例 |
|----|-----|------|
| `ideas/index.md` | 子块 | `./<slug>/index.md` 或 `/docs/ideas/<slug>` |
| 项目根 `index.md` | 子块 | `./<topic>/index.md` |
| 子块下的 `index.md` | 兄弟块 | `../sibling/index.md` |

原则：链到**具体 `.md`**，避免裸 `./文件夹`。

**`index.md` 与同目录其它 `.md`**：无尾斜杠 URL 时 `./foo.md` 易错解析；可用 `/docs/<当前目录>/foo`。

## 新增一块「子想法」时的步骤

1. 在合适的**父文件夹**下新建子目录（名称体现想法）。  
2. 子目录内 `_category_.json` + `index.md`（正文）。  
3. 更新**父级** `index.md` 的导航表（含 `ideas/index.md` 若为大区入口）。  
4. `yarn build`。
