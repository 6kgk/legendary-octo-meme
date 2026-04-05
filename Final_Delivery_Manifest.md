# 【职教通】(Vocational Bridge) V1.0 最终交付清单 (Manifest)

本清单涵盖了“职教通” V1.0 开发阶段的所有交付物，包含核心代码库、功能模块说明及运行指南。

## 1. 核心代码库
项目采用前后端分离架构，核心代码存放于 `D:\CampusAppProject\src` 目录下。

### 后端服务 (NestJS/Node.js)
- **主入口**：`src/backend/src/main.ts` (API 聚合中心)
- **提分大脑**：`src/backend/src/tutor.service.ts` (AI 启发式讲题逻辑)
- **学情追踪**：`src/backend/src/learning-progress.service.ts` (100+ 高职录取分预测引擎)
- **复盘报告**：`src/backend/src/weekly-report.service.ts` (自动化提分周报)
- **家长互动**：`src/backend/src/parent-feedback.service.ts` (Token 分享与寄语反馈)
- **实习审计**：`src/backend/src/contract-audit.service.ts` (合同风险 AI 扫描)
- **避雷中心**：`src/backend/src/company-credit.service.ts` (50+ 深圳中职实习避雷库)
- **职业背书**：`src/backend/src/resume-engine.controller.ts` (学情转软技能评价引擎)
- **成本控制**：`src/backend/src/token-tracker.ts` (API 消耗实时监控)

### 前端应用 (Flutter)
- **主入口**：`src/frontend/lib/main.dart`
- **核心界面**：
  - **提分中心 (Dashboard)**：包含录取分进度条、拍题入口、家长寄语。
  - **提分周报 (Learning Report)**：详细展示本周战果、录取概率及下周目标。
  - **实习卫士 (Internship Tools)**：集成避雷查询、合同审计、简历生成工具。

## 2. 核心功能特性
1.  **苏格拉底式 AI 辅导**：不直接给答案，通过 3 级降维引导学生自主解题。
2.  **动态录取预测**：实时计算当前成绩与广东前 100 所高职院校的录取分差。
3.  **家庭情感纽带**：家长可查看加密周报并一键发送鼓励寄语至 APP 首页。
4.  **实习安全护盾**：集成 50+ 真实避雷企业名单，支持拍照即审合同陷阱。
5.  **数据化简历背书**：将学习数据翻译为 HR 认可的“逻辑力”、“稳定性”等能力指标。

## 3. 运行指南
### 后端启动
```bash
cd D:\CampusAppProject\src\backend
npm install
npm run start
```
*API 运行于: http://localhost:3000*

### 前端启动
```bash
cd D:\CampusAppProject\src\frontend
flutter pub get
flutter run
```

## 4. V1.9.0 核心回归版 - 特性升级 (2026-04-06)
1.  **500+ 实战知识点映射库**：`500_Core_Knowledge_Mapping_V1.0.md`，将 3+证书及专业考证（电工、计算机）的高精尖公式降维映射为“大白话”模型。
2.  **苏格拉底流式讲题引擎 (Task #99, #102)**：实现 SSE 流式逐字输出，模拟“邻家哥哥”面对面辅导的真实呼吸感。
3.  **认知溯源诊断系统**：AI 讲题前自动识别学生的“底层认知断层”（如：三角函数差是因为相似三角形没学透），并进行针对性补课。
4.  **全功能内核闭环**：真实相机调用、本地 SQLite 持久化、全真 2026 广东省 3+证书 考场系统。

## 5. V2.0.0 商业化重构版 - 全链路进化 (Phase 20-26)
1.  **专业级设计系统 (Task #103)**：`Professional_UX_Design_System_V2.0.md`，对标作业帮。
2.  **3000+ 实战知识库扩容 (Task #106, #114, #118)**：`3000_Knowledge_Points_Master_V2.0.md`，包含跨学科逻辑与底层思维模型。
3.  **视觉直觉卡片系统 (Task #116)**：`Visual_Intuition_Cards_Spec_V2.0.md`，物理感滑块交互反馈。
4.  **战果化辅导闭环 (Task #117)**：`Victory_Summary_UX_Spec_V2.0.md`，职场价值量化的“战报”结课页。
5.  **精准提分大厅 (Task #113)**：`Precision_Hub_UX_Design_V2.0.md`，提分任务包动态攻坚地图。
6.  **全功能内核最终闭环**：真实相机调用、本地 SQLite 持久化、SSE 流式 AI 讲题、概念防火墙、艾宾浩斯记忆模型。

## 6. 最终交付总结
“职教通” V2.0.0 已完成从“UI 样板”到“实战内核”再到“商业化引擎”的终极三级跳。

**核心交付资产：**
- **代码库**：`D:\CampusAppProject\src` (包含 V2.0 升级逻辑)
- **知识库**：`3000_Knowledge_Points_Master_V2.0.md`
- **架构书**：`Commercial_Architecture_Overhaul_V2.0.md`
- **设计书**：`Professional_UX_Design_System_V2.0.md`

**交付团队：邓绍鹏 (Dev), 点子大师 (Creative), 项目经理 (TL)**
**交付日期：2026-04-06 (Professional/Commercial Release)**
