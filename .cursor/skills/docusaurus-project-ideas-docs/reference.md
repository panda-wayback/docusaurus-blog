# 参考：路径、链接、分层示例

路径相对仓库 `docs/`。

## 分层含义（与固定目录名无关）

| 层级 | 角色 |
|------|------|
| 项目根 `…/<project>/index.md` | **项目级汇总**：有哪些大块、链到各块 |
| 项目内某文件夹 `…/<topic>/index.md` | **该块想法的汇总**：子主题列表 + 短摘要 |
| 更深子文件夹 | **局部方案、实现细节、深度思考** 等，宜一主题一夹 |

目录名按**你想表达的想法**起即可；下列树只是当前仓库里的**一个实例**。

## 示例树（social-account-auto-reply，仅供参考）

```
project-ideas/
  index.md
  social-account-auto-reply/
    index.md                 # 项目汇总
    architecture/index.md    # 「架构」这块的汇总或短文
    protocol/index.md
    backend/
      index.md               # 后端相关汇总
      agent-framework/
      memory/
      …
    client-extension/
      index.md
      inbound-messages/
      …
```

## 相对链接

| 从 | 到 | 示例 |
|----|-----|------|
| 项目根 `index.md` | 子块 | `./<topic>/index.md` |
| 子块下的 `index.md` | 兄弟块 | `../sibling/index.md` |
| `project-ideas/index.md` | 某项目 | `./<project-slug>/index.md` |

原则：链到**具体 `.md`**，避免裸 `./文件夹`。

## 新增一块「子想法」时的步骤

1. 在合适的**父文件夹**下新建子目录（名称体现想法）。  
2. 子目录内 `_category_.json` + `index.md`（正文）。  
3. 更新**父级** `index.md` 的导航表。  
4. `yarn build`。
