# Next.js 介绍

## 什么是 Next.js

Next.js 是一个基于 React 的全栈框架，它不仅能用来开发前端页面，还能轻松编写后端 API，非常方便。

## 主要特点

### 1. 前后端一体化

- **前端页面**：可以像写 React 组件一样写页面
- **后端 API**：在项目中的 `pages/api` 目录下直接写 API 接口
- **无需配置**：开箱即用，不需要单独搭建后端服务器

### 2. 快速开发

- 文件系统即路由：页面文件位置自动成为路由
- 热更新：修改代码立即生效
- 零配置：大部分情况下不需要复杂的配置

### 3. 性能优化

- 自动代码分割
- 图片优化
- 静态页面生成
- 服务器端渲染（SSR）

## 简单示例

### 前端页面

在 `pages/index.js` 中：

```jsx
export default function Home() {
  return <h1>Hello Next.js!</h1>
}
```

### API 接口

在 `pages/api/hello.js` 中：

```jsx
export default function handler(req, res) {
  res.status(200).json({ name: 'Next.js API' })
}
```

访问 `/api/hello` 就能得到 JSON 响应。

## 总结

Next.js 让前后端开发变得一体化，不需要来回切换不同的项目，特别适合想要快速搭建全栈应用的开发者。
