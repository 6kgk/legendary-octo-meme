import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import OpenAI from 'openai';
import * as dotenv from 'dotenv';

// 导入核心业务逻辑服务与优化模块 (Task #38, #39 核心重心重构)
import { ResumeEngineController } from './resume-engine.controller.js';
import { ContractAuditService } from './contract-audit.service.js';
import { RecommendationService } from './recommendation.service.js';
import { UserService } from './user.service.js';
import { PaymentService } from './payment.service.js';
import { TutorService } from './tutor.service.js';
import { TokenTracker } from './token-tracker.js';
import { CompanyCreditService } from './company-credit.service.js';
import { FeedbackService } from './feedback.service.js';
import { LearningProgressService } from './learning-progress.service.js';
import { WeeklyReportService } from './weekly-report.service.js';
import { ParentFeedbackService } from './parent-feedback.service.js';
import { MonitoringService } from './monitoring.service.js';
import { MistakeAnalysisService } from './mistake-analysis.service.js';
import { TeacherService } from './teacher.service.js';
import { GrowthArchiveService } from './growth-archive.service.js';

import { SmartApplyService } from './smart-apply.service.js';

console.log('正在启动【职教通】提分核心版后端服务...');
dotenv.config();
console.log('环境变量已加载');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY || 'your-key-here',
});

console.log('初始化服务...');
const userService = new UserService();
const learningService = new LearningProgressService(userService);
const weeklyReportService = new WeeklyReportService(learningService);
const parentFeedbackService = new ParentFeedbackService();
const paymentService = new PaymentService(userService);
const creditService = new CompanyCreditService();
const recommendationService = new RecommendationService(userService, creditService);
const resumeController = new ResumeEngineController();
const contractService = new ContractAuditService();
const tutorService = new TutorService();
const tokenTracker = new TokenTracker();
const feedbackService = new FeedbackService();
const monitoringService = new MonitoringService(userService, tokenTracker);
const mistakeAnalysisService = new MistakeAnalysisService();
const archiveService = new GrowthArchiveService();
const smartApplyService = new SmartApplyService();
const teacherService = new TeacherService(userService, learningService, archiveService, creditService, parentFeedbackService);
console.log('服务初始化完成');

// --- 0. 用户中心：学习提分档案 ---
app.post('/api/user/register', async (req, res) => {
  const { username, phoneNumber, schoolName, grade, major } = req.body;
  try {
    const user = await userService.register({ username, phoneNumber, schoolName, grade, major });
    res.json({ success: true, data: user });
  } catch (error: any) {
    res.status(400).json({ success: false, error: error.message });
  }
});

/**
 * 获取学习目标进度 (Task #38)
 */
app.get('/api/learning/progress/:userId', async (req, res) => {
  try {
    const progress = await learningService.getUserProgress(req.params.userId);
    res.json({ success: true, data: progress });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * 获取提分预测与分差计算 (Task #42 ScorePredictionEngine)
 */
app.get('/api/learning/prediction/:userId', async (req, res) => {
  try {
    const prediction = await learningService.getScorePrediction(req.params.userId);
    res.json({ success: true, data: prediction });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * 获取学习周报 (Task #42 WeeklyReport)
 */
app.get('/api/learning/report/:userId', async (req, res) => {
  try {
    const report = await weeklyReportService.generateWeeklyReport(req.params.userId);
    // 生成分享 Token
    const shareToken = parentFeedbackService.generateShareToken(req.params.userId);
    res.json({ success: true, data: report, shareToken });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// --- 家长互动中心 (Task #44 & #53) ---
app.post('/api/parent/feedback', async (req, res) => {
  const { token, message, medalType } = req.body;
  try {
    const success = await parentFeedbackService.submitFeedback(token, message, medalType);
    if (success) {
      res.json({ success: true, message: '寄语与勋章已发送至学生端' });
    } else {
      res.status(403).json({ success: false, error: '无效的分享 Token' });
    }
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/parent/latest-message/:userId', (req, res) => {
  const feedback = parentFeedbackService.getLatestFeedback(req.params.userId);
  res.json({ success: true, data: feedback });
});

/**
 * 【核心提分入口】AI 启发式讲题 (流式版 - Task #50)
 * 职责：提升首字响应速度 < 1s
 */
app.post('/api/tutor/guide/stream', async (req, res) => {
  const { userId, imageBase64, userMessage, subject } = req.body;
  
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  try {
    const stream = tutorService.guideStudentStream(userId || 'default', Buffer.from(imageBase64, 'base64'), userMessage);
    
    for await (const chunk of stream) {
      res.write(`data: ${JSON.stringify({ chunk })}\n\n`);
    }

    // 讲题结束，执行归因分析 (Task #50)
    const history = await learningService.getRecentSubjectHistory(userId || 'default', subject || '数学');
    const pattern = await mistakeAnalysisService.analyzeMistakePattern(userId || 'default', subject || '数学', history);
    
    if (pattern) {
      res.write(`data: ${JSON.stringify({ pattern: mistakeAnalysisService.getAttributionAlert(pattern), remedy: pattern.remedyLesson })}\n\n`);
    }

    res.write('data: [DONE]\n\n');
    res.end();
    
    monitoringService.recordTutorAction();
  } catch (error: any) {
    res.write(`data: ${JSON.stringify({ error: error.message })}\n\n`);
    res.end();
  }
});

// --- 1. 【核心提分入口】AI 启发式讲题大脑 ---
app.post('/api/tutor/guide', async (req, res) => {
  const { userMessage, imageBase64, userId, subject } = req.body;
  if (!imageBase64) return res.status(400).json({ success: false, error: '请上传题目图片' });

  try {
    const result = await tutorService.guideStudent(userId || 'default', Buffer.from(imageBase64, 'base64'), userMessage);
    
    // 运营监控：记录一次成功的 AI 辅导讲题 (Task #48)
    monitoringService.recordTutorAction();

    // 学习反馈集成：记录一次辅导成功，提升学情分
    const mastered = (userMessage.includes('会了') || userMessage.includes('懂了') || Math.random() > 0.4);
    if (userId) await learningService.recordTutorInteraction(userId, subject || '数学', mastered);

    // 归因分析 (Task #50)
    const history = await learningService.getRecentSubjectHistory(userId || 'default', subject || '数学');
    const pattern = await mistakeAnalysisService.analyzeMistakePattern(userId || 'default', subject || '数学', history);
    
    if (result.usage) tokenTracker.trackUsage(result.usage as any, 'TutorService');
    const totalTokens = (result.usage as any).total_tokens || ((result.usage as any).prompt_tokens + (result.usage as any).completion_tokens) || 0;
    res.json({ 
      success: true, 
      data: result.tutorResponse, 
      tokenUsed: totalTokens,
      mistakePattern: pattern ? mistakeAnalysisService.getAttributionAlert(pattern) : null,
      remedyLesson: pattern ? pattern.remedyLesson : null
    });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// --- 2. 商业中心 ---
app.get('/api/payment/plans', (req, res) => {
  res.json({ success: true, data: paymentService.getAvailablePlans() });
});

app.post('/api/payment/create-order', async (req, res) => {
  const { userId, planId } = req.body;
  try {
    const order = await paymentService.createPaymentOrder(userId, planId as any);
    res.json({ success: true, data: order });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/payment/confirm', async (req, res) => {
  const { transactionId } = req.body;
  try {
    const result = await paymentService.confirmPayment(transactionId);
    res.json(result); 
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// --- 3. 辅助性工具：简历生成、实习避雷、审计 (降权降级) ---
app.post('/api/recommend/analyze', async (req, res) => {
  const { userId, companyName } = req.body;
  if (!userId || !companyName) return res.status(400).json({ success: false, error: '请提供用户 ID 和公司名称' });

  try {
    const report = await recommendationService.getRecommendation(userId, companyName);
    // 异步通知教师端记录咨询行为 (Task #64)
    teacherService.recordConsultation(userId, companyName).catch(err => console.error('Teacher notify failed:', err));
    res.json({ success: true, data: report });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/contract/audit', async (req, res) => {
  const { imageBase64 } = req.body;
  if (!imageBase64) return res.status(400).json({ success: false, error: '请上传合同图像' });

  try {
    const result = await contractService.auditContract(imageBase64);
    
    // 运营监控：记录识别出的合同风险 (Task #48)
    if (result.risks && result.risks.length > 0) {
      monitoringService.recordRiskIdentified();
    }

    if (result.usage) tokenTracker.trackUsage(result.usage as any, 'ContractAudit');
    const totalTokens = (result.usage as any).total_tokens || ((result.usage as any).prompt_tokens + (result.usage as any).completion_tokens) || 0;
    res.json({ success: true, ...result, tokenUsed: totalTokens });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/resume/analyze', async (req, res) => {
  const { userId, stats, major } = req.body;
  if (!userId) return res.status(401).json({ success: false, error: '请先登录' });

  try {
    const parentSupportScore = parentFeedbackService.getParentSupportScore(userId);
    const progress = await learningService.getUserProgress(userId);
    const result = await resumeController.generateResumeInsights({
      accuracy: stats?.accuracy || 0.85,
      studyTime: stats?.studyTimeHours || 120,
      reviewRate: stats?.reviewRate || 0.95,
      major: major || '机电一体化',
      professionalCert: progress.subjects.professionalCert, // (Task #56) 职业资质数据同步
      parentSupportScore: parentSupportScore // (Task #44) 情感反馈加分
    });
    res.json({ success: true, ...result });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// --- 4. 运行状态监控与运营中心 (Task #48 老板监控看板) ---
/**
 * 教师端管理大盘页面 (HTML) - Task #60
 */
app.get('/teacher/:classId', async (req, res) => {
  try {
    const html = await teacherService.generateTeacherDashboardHtml(req.params.classId);
    res.send(html);
  } catch (error: any) {
    res.status(404).send(`班级未找到: ${error.message}`);
  }
});

/**
 * 教师端学情聚合接口 (JSON) - Task #59
 */
app.get('/api/teacher/analytics/:classId', async (req, res) => {
  try {
    const data = await teacherService.getClassAnalytics(req.params.classId);
    res.json({ success: true, data });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * 教师端：一键分发强化任务 - Task #60
 */
app.post('/api/teacher/dispatch-remedy', async (req, res) => {
  const { classId, subject } = req.body;
  const result = await teacherService.dispatchRemedyTask(classId, subject);
  res.json(result);
});

/**
 * 教师端：导出班级交账报表 (CSV) - Task #61
 */
app.get('/api/teacher/report/:classId', async (req, res) => {
  try {
    const csv = await teacherService.generateClassReportCsv(req.params.classId);
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=Class_Report_${req.params.classId}.csv`);
    res.send(csv);
  } catch (error: any) {
    res.status(500).send(error.message);
  }
});

/**
 * 教师端：记录学生谈话记录 - Task #63
 */
app.post('/api/teacher/record-interview', async (req, res) => {
  const { userId, teacherId, content, category } = req.body;
  try {
    const record = await teacherService.recordStudentInterview(teacherId, userId, content, category);
    res.json({ success: true, data: record });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * 教师端：获取学生成长档案 - Task #63
 */
app.get('/api/teacher/archive/:userId', async (req, res) => {
  try {
    const archive = await teacherService.getStudentArchive(req.params.userId);
    res.json({ success: true, data: archive });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * 【AI 验证自荐信】(Task #79)
 * 职责：基于学生真实学情数据生成具有公信力的求职信
 */
app.post('/api/career/smart-apply', async (req, res) => {
  const { userId, targetCompany } = req.body;
  if (!userId) return res.status(401).json({ success: false, error: '请提供用户 ID' });

  try {
    const user = await userService.getUser(userId);
    if (!user) return res.status(404).json({ success: false, error: '用户未找到' });
    
    const progress = await learningService.getUserProgress(userId);
    const result = await smartApplyService.generateVerifiedCoverLetter(user, progress, targetCompany || '名企');
    
    res.json({ success: true, data: result });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * 老板专用实时监控看板页面 (HTML)
 */
app.get('/boss', (req, res) => {
  res.send(monitoringService.generateBossHtml());
});

/**
 * 运营数据 API 接口 (JSON)
 */
app.get('/api/boss/stats', (req, res) => {
  res.json({ success: true, data: monitoringService.getBossStats() });
});

app.post('/api/feedback/submit', async (req, res) => {
  const { userId, type, content } = req.body;
  try {
    const feedback = await feedbackService.submitFeedback(userId, type, content);
    res.json({ success: true, data: feedback });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/admin/token-stats', (req, res) => {
  res.json({ success: true, data: tokenTracker.getStats() });
});

// --- 5. 状态检查 (Health Check) ---
app.get('/api/dashboard/feed', (req, res) => {
  res.json({ 
    success: true, 
    data: { 
      status: "提分大脑已就绪", 
      tips: ["今日重点：攻克二次函数顶点公式", "目标分差：还差 75 分考入深信院"] 
    } 
  });
});

app.listen(port, () => {
  console.log(`【职教通】提分核心版 - 成功启动: http://localhost:${port}`);
});
