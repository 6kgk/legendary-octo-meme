# Legendary Octo Meme Backend API

这是一个基于 Node.js 和 Express 的后端 API 服务，为中考助手项目提供数据接口。

## 项目结构
- `server.js`: 入口文件，配置 Express 和中间件。
- `routes/`: 存放路由逻辑。
  - `questions.js`: 题目相关 API。
  - `schools.js`: 院校相关 API。
  - `posts.js`: 社区帖子相关 API。
- `package.json`: 项目配置和依赖管理。

## 运行方式
在 `src/backend` 目录下执行以下操作：

1. **安装依赖** (如果尚未安装):
   ```bash
   npm install
   ```

2. **启动服务**:
   - 开发模式 (自动热重启):
     ```bash
     npm run dev
     ```
   - 生产模式:
     ```bash
     npm start
     ```

服务默认在 `http://localhost:3000` 运行。

## API 接口文档

### 题目 API
- `GET /api/questions`: 获取所有题目。
  - 查询参数: `?subject=语文` (可选，按科目筛选)。
- `GET /api/questions/:id`: 获取单道题目。

### 院校 API
- `GET /api/schools`: 获取所有院校。
  - 查询参数: `?type=公办` (可选，按办学性质筛选)。
  - 查询参数: `?search=深圳` (可选，按名称或地点搜索)。
- `GET /api/schools/:id`: 获取单个院校详情。

### 社区帖子 API
- `GET /api/posts`: 获取所有社区帖子。
- `POST /api/posts`: 创建新帖子。
  - 请求体: `{ "title": "标题", "content": "内容", "author": "作者" }`
- `POST /api/posts/:id/like`: 给帖子点赞。

## 数据来源
- 题目和院校数据通过读取 `src/frontend/assets/data/` 目录下的 JSON 文件获得。
- 帖子数据暂时存储在内存数组中，服务器重启后会重置。
