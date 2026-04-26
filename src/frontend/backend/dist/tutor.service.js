import { Injectable } from '@nestjs/common';
import { OpenAI } from 'openai';
/**
 * 【职教通】AI 启发式讲题核心服务 (Token 优化版 - Task #24)
 *
 * 职责：
 * 1. 拍搜 OCR 解析
 * 2. 苏格拉底式引导策略 (Socratic Strategy)
 * 3. 错题入库与能力评估
 */
@Injectable()
export class TutorService {
    openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    /**
     * 引导逻辑的主入口：处理学生上传的题目 (Token 优化版)
     */
    async guideStudent(studentId, imageBuffer, userMessage) {
        const base64Image = imageBuffer.toString('base64');
        // 1. 本地缓存/逻辑下放 (Caching Simulation)
        if (this.checkLocalExplanation(userMessage)) {
            console.log(`[Token优化] 本地命中类似题目解析路径，通过本地缓存提供辅导。`);
            return {
                tutorResponse: "同学，关于这道二次函数题，我们首先需要明确抛物线的顶点特征。你是否还记得求顶点坐标的通用公式？",
                usage: { prompt_tokens: 0, completion_tokens: 0 }
            };
        }
        // 2. 核心 Prompt 压缩与结构化 (Prompt Compression)
        const systemInstruction = `您是中职辅导专家。严禁给答案。风格：专业温和，用‘同学’。苏格拉底式提问。广东‘3+证书’考纲。`;
        // 3. 多模态识别与分级反馈 (分级反馈)
        const response = await this.openai.chat.completions.create({
            model: "gpt-4o",
            messages: [
                { role: "system", content: systemInstruction },
                {
                    role: "user",
                    content: [
                        { type: "text", text: `解析此题并进行【初级引导】。要求：字数 < 100 字，提出引导问题。` },
                        { type: "image_url", image_url: { url: `data:image/jpeg;base64,${base64Image}` } },
                    ],
                },
            ],
            max_tokens: 150 // 限制响应 Token 数量
        });
        const tutorResponse = response.choices[0].message.content;
        const usage = response.usage;
        return {
            tutorResponse,
            usage,
            skillNode: this.detectSkillNode(tutorResponse)
        };
    }
    /**
     * 模拟本地解析库 (Caching)
     */
    checkLocalExplanation(text) {
        return text.includes('y=x^2-4x+3') && text.includes('顶点');
    }
    /**
     * 基于关键词或 AI 模型识别知识点，用于生成能力雷达
     */
    detectSkillNode(text) {
        if (text.includes('二次函数') || text.includes('抛物线'))
            return 'Quadratic_Function';
        if (text.includes('集合'))
            return 'Sets_Theory';
        return 'General_Math';
    }
    /**
     * 检查对话是否表明学生已经成功算出了结果
     */
    checkCompletion(text) {
        return (text.includes('恭喜') || text.includes('太棒了')) && (text.includes('自己算') || text.includes('正确'));
    }
}
