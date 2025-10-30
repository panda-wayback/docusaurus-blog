# API 测试和设计最佳实践

## REST Client - API 测试利器

### 什么是 REST Client

`api.http` 文件是一个非常好用的 API 测试工具，它是 REST Client 扩展提供的功能。可以直接在编辑器中编写 HTTP 请求并测试 API，非常方便。

### 为什么好用

1. **无需额外工具**：不需要打开 Postman、Insomnia 等独立应用
2. **代码即文档**：HTTP 请求代码可以直接保存在项目中，作为文档使用
3. **快速测试**：在开发过程中可以直接测试 API，提高效率
4. **版本控制**：`api.http` 文件可以提交到 Git，团队共享

### 简单示例

创建一个 `api.http` 文件：

```http
### 获取用户信息
GET http://localhost:3000/api/users/123

### 创建用户
POST http://localhost:3000/api/users
Content-Type: application/json

{
  "name": "张三",
  "email": "zhangsan@example.com"
}

### 更新用户
PUT http://localhost:3000/api/users/123
Content-Type: application/json

{
  "name": "李四"
}

### 删除用户
DELETE http://localhost:3000/api/users/123
```

直接在编辑器中点击 "Send Request" 就可以测试这些 API。

## API 设计最佳实践

### 简单参数放在 URL 中

在设计 API 时，**简单的参数尽量放在地址中（URL），而不是放在 body 中**，这样更加方便和符合 RESTful 规范。

### 优点

1. **更直观**：URL 参数一目了然，不需要查看 body
2. **更符合 RESTful**：GET 请求使用查询参数是标准做法
3. **便于测试**：在浏览器地址栏就能直接测试，不需要构造 body
4. **便于缓存**：URL 参数可以作为缓存键的一部分

### 示例对比

#### ❌ 不推荐：参数放在 body 中

```http
### 获取用户列表 - 不推荐的方式
GET http://localhost:3000/api/users
Content-Type: application/json

{
  "page": 1,
  "limit": 10,
  "status": "active"
}
```

#### ✅ 推荐：参数放在 URL 中

```http
### 获取用户列表 - 推荐的方式
GET http://localhost:3000/api/users?page=1&limit=10&status=active
```

### 何时使用 URL 参数，何时使用 body

**使用 URL 参数（查询参数）：**
- GET 请求
- 简单的筛选、分页、排序参数
- 不需要嵌套的简单数据

**使用 body：**
- POST/PUT/PATCH 请求的复杂数据
- 需要嵌套结构的数据
- 敏感信息（虽然应该用 HTTPS）

### 实际应用示例

```http
### 分页查询用户
GET http://localhost:3000/api/users?page=1&pageSize=20

### 筛选特定状态的用户
GET http://localhost:3000/api/users?status=active&role=admin

### 排序
GET http://localhost:3000/api/users?sortBy=createdAt&order=desc

### 复杂数据创建 - 使用 body
POST http://localhost:3000/api/users
Content-Type: application/json

{
  "name": "张三",
  "email": "zhangsan@example.com",
  "profile": {
    "age": 25,
    "address": "北京市"
  }
}
```

## 总结

1. **REST Client（api.http）** 是测试 API 的利器，可以提高开发效率
2. **简单的 API 参数应该放在 URL 中**，这样更直观、更方便测试、更符合 RESTful 规范
3. 复杂的数据结构仍然应该使用 body，但简单的筛选、分页、排序等参数推荐使用 URL 查询参数

