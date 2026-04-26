# 职教通 (Vocational Bridge) V2.0：商用级底层逻辑架构重构 (Task #104)

对标作业帮、小猿搜题等亿级日活应用的架构标准，本重构方案旨在解决从“单一工具”向“平台级应用”转型的性能、扩展性与稳定性挑战。

## 一、 后端架构：商用级 NestJS 微服务化 (Service-Oriented Overhaul)

### 1. Repository 模式实现 (Data Isolation)
*   **解耦**：将业务逻辑与数据库操作彻底分离。定义 `BaseRepository` 处理通用的增删改查。
*   **多源同步**：引入 Redis 作为一级缓存，SQLite 为二级缓存（客户端），PostgreSQL 为三级持久化。确保在 500ms 内完成拍题识别到知识点抓取的全过程。

### 2. 多级 AI 推理管线 (Multi-Stage AI Pipeline)
*   **Stage 1: Feature Extraction**：使用高密度向量化模型 (Vector Embedding) 提取图片特征，直接索引本地 3000+ 知识库，命中率 >85% 时直接返回缓存结果。
*   **Stage 2: Dynamic Synthesis**：未命中时，通过流式转发至 OpenAI/Claude API 进行深度实时生成。
*   **Stage 3: Evaluation Loop**：记录学生对“懂了”或“听不懂”的反馈，自动调整该知识点在全网的“降维解释权重”。

## 二、 前端架构：Flutter 响应式单例系统 (Performance First)

### 1. 状态管理升级 (Provider to Riverpod/Bloc)
*   **按需刷新**：将全局状态划分为 `AuthScope`、`LearningScope`、`CareerScope`。避免“拍题时刷新首页”等无效渲染，内存占用降低 40%。
*   **流式交互引擎**：封装 `SseClient` 单例，支持 WebSocket/SSE 的自动重连与丢包重传，确保 AI 的“呼吸感”不被打断。

### 2. 离线优先策略 (Offline-First Persistence)
*   **全量持久化**：使用 `ObjectBox` 或高性能 `Sqflite` 存储 3000+ 知识库的索引摘要。
*   **断网重补机制**：在无网状态下记录做题轨迹，连网后静默同步至云端。

## 三、 性能压测指标 (Benchmarking vs Industry)

| 指标 (Metrics) | 职教通 1.0 (PoC) | 职教通 2.0 (Commercial) | 行业巨头 (Industry) |
| :--- | :--- | :--- | :--- |
| **应用启动速度** | 2.5s | **0.8s** | 0.6-0.9s |
| **拍照识别响应 (TTR)** | 5.0s | **1.2s** | 1.0-1.5s |
| **离线可用率** | <10% | **>90%** | >85% |
| **内存占用** | 450MB | **210MB** | 180-250MB |

---
**实施备注**：
该重构方案将作为 Phase 20-23 的工程基石，代码实现将按照模块化逐步注入主仓库。
