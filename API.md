# Bluebell API 接口文档

## 基础信息

- **Base URL**: `http://localhost:8080/api/v1`
- **认证方式**: JWT Token（Bearer Token）
- **数据格式**: JSON

## 响应格式

所有接口统一返回格式：

```json
{
  "code": 1000,
  "msg": "success",
  "data": {}
}
```

### 响应码说明

| 响应码 | 说明 |
|--------|------|
| 1000 | 成功 |
| 1001 | 请求参数有误 |
| 1002 | 用户已存在 |
| 1003 | 用户不存在 |
| 1004 | 用户名或密码错误 |
| 1005 | 用户重复投票 |
| 1006 | 服务器繁忙 |
| 1007 | 查询不到帖子 |
| 1008 | 用户未登录 |
| 1009 | Token已失效 |

---

## 1. 用户相关接口

### 1.1 用户注册

**接口地址**: `POST /signup`

**请求头**: 无需认证

**请求参数**:

```json
{
  "username": "string",
  "password": "string",
  "re_password": "string"
}
```

**参数说明**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | string | 是 | 用户名 |
| password | string | 是 | 密码 |
| re_password | string | 是 | 确认密码，必须与 password 相同 |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": null
}
```

**错误响应**:

- `1002`: 用户已存在
- `1001`: 请求参数有误

---

### 1.2 用户登录

**接口地址**: `POST /login`

**请求头**: 无需认证

**请求参数**:

```json
{
  "username": "string",
  "password": "string"
}
```

**参数说明**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | string | 是 | 用户名 |
| password | string | 是 | 密码 |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": {
    "user_id": "123456789",
    "username": "testuser",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**错误响应**:

- `1003`: 用户不存在
- `1004`: 用户名或密码错误
- `1001`: 请求参数有误

---

## 2. 帖子相关接口

### 2.1 获取帖子列表（简单版）

**接口地址**: `GET /posts`

**请求头**: 无需认证

**查询参数**:

| 参数 | 类型 | 必填 | 说明 | 默认值 |
|------|------|------|------|--------|
| page | int | 否 | 页码 | 1 |
| size | int | 否 | 每页数量 | 10 |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": [
    {
      "id": "123456789",
      "author_id": "987654321",
      "community_id": 1,
      "status": 0,
      "title": "帖子标题",
      "content": "帖子内容",
      "create_time": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### 2.2 获取帖子列表（高级版）

**接口地址**: `GET /posts2`

**请求头**: 无需认证

**查询参数**:

| 参数 | 类型 | 必填 | 说明 | 默认值 |
|------|------|------|------|--------|
| page | int | 否 | 页码 | 1 |
| size | int | 否 | 每页数量 | 10 |
| order | string | 否 | 排序方式：time（时间）或 score（分数） | time |
| community_id | int | 否 | 社区ID，为空则获取所有社区 | - |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": [
    {
      "id": "123456789",
      "author_id": "987654321",
      "community_id": 1,
      "status": 0,
      "title": "帖子标题",
      "content": "帖子内容",
      "create_time": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### 2.3 获取帖子详情

**接口地址**: `GET /post/:id`

**请求头**: 无需认证

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | int | 是 | 帖子ID |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": {
    "id": "123456789",
    "author_id": "987654321",
    "author_name": "testuser",
    "community_id": 1,
    "status": 0,
    "title": "帖子标题",
    "content": "帖子内容",
    "create_time": "2024-01-01T00:00:00Z",
    "vote_num": 10,
    "community": {
      "id": 1,
      "name": "社区名称",
      "introduction": "社区介绍",
      "create_time": "2024-01-01T00:00:00Z"
    }
  }
}
```

**错误响应**:

- `1007`: 查询不到帖子

---

### 2.4 创建帖子

**接口地址**: `POST /post`

**请求头**: 
```
Authorization: Bearer {token}
```

**请求参数**:

```json
{
  "title": "string",
  "content": "string",
  "community_id": 1
}
```

**参数说明**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | string | 是 | 帖子标题 |
| content | string | 是 | 帖子内容 |
| community_id | int | 是 | 社区ID |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": null
}
```

**错误响应**:

- `1008`: 用户未登录
- `1001`: 请求参数有误

---

## 3. 社区相关接口

### 3.1 获取所有社区列表

**接口地址**: `GET /community`

**请求头**: 无需认证

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": [
    {
      "id": 1,
      "name": "社区名称"
    }
  ]
}
```

---

### 3.2 获取社区详情

**接口地址**: `GET /community/:id`

**请求头**: 无需认证

**路径参数**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | int | 是 | 社区ID |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": {
    "id": 1,
    "name": "社区名称",
    "introduction": "社区介绍",
    "create_time": "2024-01-01T00:00:00Z"
  }
}
```

---

## 4. 投票相关接口

### 4.1 为帖子投票

**接口地址**: `POST /vote`

**请求头**: 
```
Authorization: Bearer {token}
```

**请求参数**:

```json
{
  "post_id": "123456789",
  "direction": 1
}
```

**参数说明**:

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| post_id | string | 是 | 帖子ID |
| direction | int | 是 | 投票方向：1（赞成）、-1（反对）、0（取消投票） |

**响应示例**:

```json
{
  "code": 1000,
  "msg": "success",
  "data": null
}
```

**错误响应**:

- `1008`: 用户未登录
- `1005`: 用户重复投票
- `1001`: 请求参数有误

---

## 使用示例

### JavaScript/TypeScript 示例

```typescript
// 登录
const login = async (username: string, password: string) => {
  const response = await fetch('http://localhost:8080/api/v1/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ username, password }),
  });
  const data = await response.json();
  if (data.code === 1000) {
    localStorage.setItem('token', data.data.token);
  }
  return data;
};

// 获取帖子列表
const getPosts = async (page: number = 1, size: number = 10, order: string = 'time') => {
  const response = await fetch(
    `http://localhost:8080/api/v1/posts2?page=${page}&size=${size}&order=${order}`
  );
  return await response.json();
};

// 创建帖子（需要认证）
const createPost = async (title: string, content: string, communityId: number) => {
  const token = localStorage.getItem('token');
  const response = await fetch('http://localhost:8080/api/v1/post', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify({ title, content, community_id: communityId }),
  });
  return await response.json();
};

// 投票
const vote = async (postId: string, direction: number) => {
  const token = localStorage.getItem('token');
  const response = await fetch('http://localhost:8080/api/v1/vote', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify({ post_id: postId, direction }),
  });
  return await response.json();
};
```

---

## 注意事项

1. 所有需要认证的接口都需要在请求头中携带 `Authorization: Bearer {token}`
2. Token 通过登录接口获取，需要妥善保存
3. 分页参数从 1 开始
4. 投票方向：1 表示赞成，-1 表示反对，0 表示取消投票
5. 排序方式：`time` 表示按时间排序，`score` 表示按分数排序

