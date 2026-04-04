---
name: docusaurus-ideas-docs
description: >-
  Enforces hierarchical doc structure for this repo: split ideas across folders,
  keep each folder index.md as a rollup, put deep or scoped writing in child
  folders—not one giant file. Covers docs/ideas (日常随想与立项项目同一分区),
  _category_.json, and safe Docusaurus links. Use when adding or editing idea
  docs, 文档分类、想法拆分、避免单文件堆叠, or broken links.
---

# Docusaurus 想法与项目文档规范（本仓库）

## 核心原则（优先于任何目录名）

1. **用文件夹做分类**：按「想法 → 子想法 → 更细的局部」拆成**多层目录**，避免所有内容挤在**一个 `.md`** 里。  
2. **每一层的 `index.md` = 汇总**：只放**导航、摘要、与其它块的衔接**；具体论证、方案细节、备忘写在**下级文件夹**的页面里。  
3. **子文件夹表示「一块想法」或其「具体实现 / 深度思考」**：文件夹名由**内容语义**决定，**没有**规定的固定清单（不要强行套用 `architecture` / `backend` 等名，除非它们正好表达你的拆分）。  
4. **日常与项目不拆顶栏**：碎片与立项文档都放在 **`docs/ideas/`**；深化后自然长成子文件夹（如 `social-account-auto-reply`），不必与「日常」分两个入口。  
5. **现有项目（如 `social-account-auto-reply`）是示例**：展示的是「如何分层」，不是全仓库必须复制的模板。

## 何时应用

在以下情况按本 skill 操作，改链后执行 `yarn build` 确认无 broken links：

- 在 `docs/ideas/` 下新增或调整文档  
- 发现某个 `index.md` 过长、主题混杂 → **拆文件夹**并把本层改成汇总  
- 修改跨文件夹 Markdown **链接**

## 顶层分区（docs/）

- 顶栏与侧栏由 `docs-nav-autogen.ts` 按 `docs/` **一级目录**生成；**无** `_category_.json` 的一级目录仍会出现在顶栏（显示名由文件夹名推导）。建议为需要中文名或侧栏元数据的分区补 `_category_.json`（至少 `label`）。  
- **想法与项目**：`docs/ideas/`（日常随想、需求备忘与立项级项目文档**同一分区**，用子文件夹区分深浅）。  
- **博客配置**：`docs/blog-config/`（本站 Docusaurus 侧栏元数据、`preset` 与博客开关等——**不要**与 `ideas/` 内容混写）。  
- **教程**：`docs/tutorial/`（模板自带的 Docusaurus Tutorial，与自有内容分区）。

## `docs/ideas/`：大区与项目

路径：`docs/ideas/<slug>/`

- **`ideas/index.md`**：分区总览（轻量与项目列表、**导航表**）。建议 `sidebar_position: 0`。  
- **并列子文件夹**可以是：短文（如「记忆体与可书写记忆」）、或完整项目（如「多平台账号自动回复」）。  
- **项目根** `index.md`：**该项目的汇总**（目标一句话、大块导航表）。**项目根** `_category_.json`：侧栏上该项目的显示名。

### 项目内部怎么拆（语义驱动，不背表）

- **下一层文件夹** = 项目下的**一大类想法**（例如架构、协议、商业化——名字随你）。  
- **再下一层** = 子话题、功能线或深写；继续拆到「一文件一事」。  
- **同一父级下**多个子文件夹并列时，用各自 `_category_.json` 的 `label` + `position` 控制侧栏顺序。

### 大区再分子文件夹（习惯）

若某一层下面还会长期增内容，该层 **`index.md` 只做汇总 + 子区导航表**，**不要**把细节都堆在一页——**每个子话题一个子文件夹**。

## `_category_.json`

```json
{
  "label": "侧栏显示名",
  "collapsed": false,
  "position": 1
}
```

字段说明、更多选项见 `docs/blog-config/docusaurus-category-json.md`（不必在 skill 里重复）。

## 链接规则（自动生成最易错）

嵌套 docs 下，裸链 `./子文件夹` 常被解析成**错误层级**。跨文件夹请写到**具体文件**，例如 `./某块/index.md`、`../兄弟块/index.md`。

- ✅ `./architecture/index.md`（从同项目根 `index.md`）  
- ❌ 避免单独 `./architecture`（易 broken）

从 `docs/ideas/index.md` 进某子区：`./<slug>/index.md` 或站内绝对路径 `/docs/ideas/<slug>/...`。

**同目录下的 `index.md` 链到并列 `.md` 时**：若页面 URL 为 `/docs/某目录`（无尾斜杠），`./foo.md` 在浏览器里可能被当成 `/docs/foo` 而 404。并列文档宜用 **`/docs/某目录/foo`**（站内绝对路径），或把并列页改成 `foo/index.md` 并用 `./foo/index.md` 链接。改完 **必须** `yarn build`。

## 检查清单

- [ ] 是否避免「一个文件装下整坨想法」→ 该拆的已拆成**文件夹**  
- [ ] 当前层 `index.md` 是否主要是**汇总 + 导航**，细节是否在下级  
- [ ] 新文件夹是否有 `_category_.json`（`label`，同级多时用 `position`）  
- [ ] 父级汇总页是否已更新**导航表**  
- [ ] 跨目录链接是否指向明确 `.md` 路径；`yarn build` 通过  

## 延伸阅读

- 路径与链接示例：[reference.md](reference.md)
