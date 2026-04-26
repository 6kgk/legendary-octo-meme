import { Injectable } from '@nestjs/common';
import OpenAI from 'openai';
/**
 * 【职教通】简历背书核心引擎控制器逻辑
 * 职责：
 * 1. 聚合数据库学习表现数据
 * 2. 调用 AI 算法将“学情”翻译为“才华”
 * 3. 实时输出雷达能力评分与简历评价
 */
@Injectable()
export class ResumeEngineController {
    openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    /**
     * 处理简历生成请求
     * @param stats 学生刷题数据 (正确率、时长、错题率)
     */
    async generateResumeInsights(stats) {
        // 逻辑：将学术分翻译为职业软素质评价
        const prompt = `
      您是一名资深的教育专家与职业顾问。请根据以下中职生学习数据，撰写一段具有“背书性质”的职业胜任力评价。
      
      【学生背景】：专业为 ${stats.major}。
      【学习表现】：正确率 ${(stats.accuracy * 100).toFixed(1)}%，复盘频率为 ${(stats.reviewRate * 100).toFixed(1)}%。
      【评价要求】：
      - 严禁空洞。
      - 必须引用数据支撑能力（如：逻辑严密、韧性极佳）。
      - 针对深圳本地基层岗位进行适配。
      - 语气必须表现出对该生“学有所成”的认可。
    `;
        const response = await this.openai.chat.completions.create({
            model: "gpt-4o",
            messages: [{ role: "system", content: prompt }]
        });
        // 计算雷达分 (算法模拟)
        const radarData = {
            logic: Math.round(stats.accuracy * 100),
            stability: Math.round(Math.min(100, stats.studyTime * 0.8)),
            resilience: Math.round(stats.reviewRate * 100),
            communication: 75 // 默认分，后续根据语文/英语表现动态调整
        };
        return {
            insights: response.choices[0].message.content,
            radarData: radarData
        };
    }
}
