import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import OpenAI from 'openai';
import * as dotenv from 'dotenv';
// 导入核心业务逻辑服务与优化模块 (Task #20, #22, #24, #26, #27)
import { ResumeEngineController } from './resume-engine.controller.js';
import { ContractAuditService } from './contract-audit.service.js';
import { RecommendationService } from './recommendation.service.js';
import { UserService } from './user.service.js';
import { PaymentService } from './payment.service.js';
import { TutorService } from './tutor.service.js';
import { TokenTracker } from './token-tracker.js';
import { CompanyCreditService } from './company-credit.service.js';
console.log('正在启动【职教通】后端服务...');
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
const paymentService = new PaymentService(userService);
const creditService = new CompanyCreditService();
const recommendationService = new RecommendationService(userService, creditService);
const resumeController = new ResumeEngineController();
const contractService = new ContractAuditService();
const tutorService = new TutorService();
const tokenTracker = new TokenTracker();
console.log('服务初始化完成');
// --- 0. 用户中心：隐私优先的注册与分阶段实名引导 (Task #20) ---
app.post('/api/user/register', async (req, res) => {
    const { username, phoneNumber, schoolName, grade, major } = req.body;
    try {
        const user = await userService.register({ username, phoneNumber, schoolName, grade, major });
        res.json({ success: true, data: user });
    }
    catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
});
// --- 1. 商业中心：付费订阅与支付系统 (Task #22) ---
app.get('/api/payment/plans', (req, res) => {
    res.json({ success: true, data: paymentService.getAvailablePlans() });
});
app.post('/api/payment/create-order', async (req, res) => {
    const { userId, planId } = req.body;
    try {
        const order = await paymentService.createPaymentOrder(userId, planId);
        res.json({ success: true, data: order });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});
app.post('/api/payment/confirm', async (req, res) => {
    const { transactionId } = req.body;
    try {
        const result = await paymentService.confirmPayment(transactionId);
        res.json(result);
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});
// --- 2. 核心业务服务：讲题、简历、审计、避雷推荐 (Task #27) ---
app.post('/api/recommend/analyze', async (req, res) => {
    const { userId, companyName } = req.body;
    if (!userId || !companyName)
        return res.status(400).json({ success: false, error: '请提供用户 ID 和公司名称' });
    try {
        const report = await recommendationService.getRecommendation(userId, companyName);
        res.json({ success: true, data: report });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});
app.post('/api/tutor/guide', async (req, res) => {
    const { userMessage, imageBase64, studentId } = req.body;
    if (!imageBase64)
        return res.status(400).json({ success: false, error: '请上传题目图片' });
    try {
        const result = await tutorService.guideStudent(studentId || 'default', Buffer.from(imageBase64, 'base64'), userMessage);
        if (result.usage)
            tokenTracker.trackUsage(result.usage, 'TutorService');
        const totalTokens = result.usage.total_tokens || (result.usage.prompt_tokens + result.usage.completion_tokens) || 0;
        res.json({ success: true, data: result.tutorResponse, tokenUsed: totalTokens });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});
app.post('/api/contract/audit', async (req, res) => {
    const { imageBase64 } = req.body;
    if (!imageBase64)
        return res.status(400).json({ success: false, error: '请上传合同图像' });
    try {
        const result = await contractService.auditContract(imageBase64);
        if (result.usage)
            tokenTracker.trackUsage(result.usage, 'ContractAudit');
        const totalTokens = result.usage.total_tokens || (result.usage.prompt_tokens + result.usage.completion_tokens) || 0;
        res.json({ success: true, ...result, tokenUsed: totalTokens });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});
app.post('/api/resume/analyze', async (req, res) => {
    const { userId, stats, major } = req.body;
    if (!userId)
        return res.status(401).json({ success: false, error: '请先登录' });
    try {
        const result = await resumeController.generateResumeInsights({
            accuracy: stats?.accuracy || 0.85,
            studyTime: stats?.studyTimeHours || 120,
            reviewRate: stats?.reviewRate || 0.95,
            major: major || '机电一体化'
        });
        res.json({ success: true, ...result });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});
// --- 3. 动态仪表盘数据流 ---
app.get('/api/dashboard/feed', (req, res) => {
    const mockFeed = {
        dailyTips: [
            "【避雷】凡是要求交‘服装押金’的实习，99% 是黑中介，请直接拒绝。",
            "【建议】实习合同必须写明具体的‘报酬金额’与‘发放日期’，不得模糊。"
        ],
        userStats: { coverage: 68.5, competency: 842 }
    };
    res.json({ success: true, data: mockFeed });
});
app.listen(port, () => {
    console.log(`【职教通】专家级数据集成版 - 服务已启动: http://localhost:${port}`);
});
