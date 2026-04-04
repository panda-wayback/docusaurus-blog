# 预设与博客开关（本站）

> 对应仓库根目录 `docusaurus.config.ts`，此处仅作**文档化**，修改行为仍以代码为准。

## `preset-classic` 中关闭内置博客

- 配置里 **`blog: false`**：未使用仓库内默认的 `blog/` 目录时关闭，否则会因缺少文章出现构建错误（配置内注释已说明）。  
- 若将来恢复第二套博客，需新建目录（如 `blog-panda/`）并单独配置 `@docusaurus/plugin-content-blog`（见配置内注释）。

## 本地搜索插件

- `@easyops-cn/docusaurus-search-local` 中 **`indexBlog: false`**：与上一条一致，当前不索引博客内容。

## 顶栏与侧栏生成

- 各顶层 `docs/<分区>/_category_.yml` 的 `label` 与 **`docs-nav-autogen.ts`** 如何生成顶栏文档标签，见 [分类元数据说明](./docusaurus-category-json.md) 中「和你站点的关系」一节。
