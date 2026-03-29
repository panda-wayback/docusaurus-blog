---
name: docusaurus-project-ideas-docs
description: >-
  Enforces hierarchical doc structure for this repo: split ideas across folders,
  keep each folder index.md as a rollup, put deep or scoped writing in child
  folders—not one giant file. Covers docs/project-ideas, _category_.json, and
  safe Docusaurus links. Use when adding project docs, 文档分类、想法拆分、避免单文件堆叠,
  or broken links.
---

# Docusaurus 项目想法文档规范（本仓库）

## 核心原则（优先于任何目录名）

1. **用文件夹做分类**：按「想法 → 子想法 → 更细的局部」拆成**多层目录**，避免所有内容挤在**一个 `.md`** 里。  
2. **每一层的 `index.md` = 汇总**：只放**导航、摘要、与其它块的衔接**；具体论证、方案细节、备忘写在**下级文件夹**的页面里。  
3. **子文件夹表示「一块想法」或其「具体实现 / 深度思考」**：文件夹名由**内容语义**决定，**没有**规定的固定清单（不要强行套用 `architecture` / `backend` 等名，除非它们正好表达你的拆分）。  
4. **现有项目（如 `social-account-auto-reply`）是示例**：展示的是「如何分层」，不是全仓库必须复制的模板。

## 何时应用

在以下情况按本 skill 操作，改链后执行 `yarn build` 确认无 broken links：

- 在 `docs/project-ideas/` 下新增或调整文档  
- 发现某个 `index.md` 过长、主题混杂 → **拆文件夹**并把本层改成汇总  
- 修改跨文件夹 Markdown **链接**

## 顶层分区（docs/）

- 顶栏与侧栏由 `docs-nav-autogen.ts` 按 `docs/` **一级目录**生成；一级目录需有 `_category_.json`（至少 `label`）。  
- **日常想法**：`docs/thoughts/`（短片段、随笔）。  
- **项目想法**：`docs/project-ideas/`（可立项、结构更完整）。项目级内容放在这里，与 `thoughts` 区分开即可。

## project-ideas：一个「项目」= 一层想法容器

路径：`docs/project-ideas/<project-slug>/`

- **项目根** `index.md`：**整个项目的汇总**（目标一句话、当前有哪些大块想法、**导航表**指向下级）。  
- **项目根** `_category_.json`：侧栏上这一项目的显示名。  
- 建议根 `index.md` 使用 front matter：`sidebar_position: 0`，让总览排在子分类前。

### 项目内部怎么拆（语义驱动，不背表）

- **下一层文件夹** = 项目下的**一大类想法**（例如架构、协议、商业化——名字随你，能概括即可）。  
- **再下一层** = 某一类里的**子话题、某条功能线、或需要单独展开的深写**；继续往下拆，直到「一个文件主要讲一件事」。  
- **同一父级下**多个子文件夹并列时，用各自 `_category_.json` 的 `label` + `position` 控制侧栏顺序与可读性。

### 大区再分子文件夹（习惯）

若某一层下面还会长期增内容（例如「后端相关的一堆子想法」），该层用 **`index.md` 只做汇总 + 子区导航表**，**不要**把后续所有细节都写进这一页——**每个子话题一个子文件夹**。

## `_category_.json`

```json
{
  "label": "侧栏显示名",
  "collapsed": false,
  "position": 1
}
```

字段说明、更多选项见 `docs/thoughts/docusaurus-_category_-json-说明.md`（不必在 skill 里重复）。

## 链接规则（自动生成最易错）

嵌套 docs 下，裸链 `./子文件夹` 常被解析成**错误层级**。跨文件夹请写到**具体文件**，例如 `./某块/index.md`、`../兄弟块/index.md`。

- ✅ `./architecture/index.md`（从同项目根 `index.md`）  
- ❌ 避免单独 `./architecture`（易 broken）

从 `docs/project-ideas/index.md` 进某项目：`./<project-slug>/index.md`。改完 **必须** `yarn build`。

## 检查清单

- [ ] 是否避免「一个文件装下整坨想法」→ 该拆的已拆成**文件夹**  
- [ ] 当前层 `index.md` 是否主要是**汇总 + 导航**，细节是否在下级  
- [ ] 新文件夹是否有 `_category_.json`（`label`，同级多时用 `position`）  
- [ ] 父级汇总页是否已更新**导航表**  
- [ ] 跨目录链接是否指向明确 `.md` 路径；`yarn build` 通过  

## 延伸阅读

- 路径与链接示例（含现有一个项目布局样例）：[reference.md](reference.md)
